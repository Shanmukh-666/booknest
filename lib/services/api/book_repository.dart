import '../../models/book.dart';
import 'api_client.dart';
import 'google_books_service.dart';
import 'gutendex_service.dart';
import 'open_library_service.dart';

/// Aggregates Google Books (primary), Open Library (secondary), and Gutendex (public domain).
class BookRepository {
  final GoogleBooksService googleBooks;
  final OpenLibraryService openLibrary;
  final GutendexService gutendex;

  BookRepository({
    required this.googleBooks,
    required this.openLibrary,
    required this.gutendex,
  });

  factory BookRepository.create({ApiClient? client}) {
    final apiClient = client ?? ApiClient();
    return BookRepository(
      googleBooks: GoogleBooksService(apiClient),
      openLibrary: OpenLibraryService(apiClient),
      gutendex: GutendexService(apiClient),
    );
  }

  /// Searches Google Books first, supplements with Open Library, and deduplicates.
  Future<({List<Book> books, bool hasMore, String? warning})> searchCombined({
    required String query,
    String? category,
    int page = 1,
    int pageSize = 16,
  }) async {
    final combined = <Book>[];
    final seenKeys = <String>{};
    String? warning;
    var hasMore = false;

    final startIndex = (page - 1) * pageSize;

    // 1. Primary: Google Books API
    try {
      final gb = await googleBooks.searchBooks(
        query,
        startIndex: startIndex,
        maxResults: pageSize,
        category: category,
      );
      for (final book in gb.books) {
        final dedupKey = _dedupKey(book);
        if (seenKeys.add(dedupKey)) {
          combined.add(book);
        }
      }
      if (startIndex + gb.books.length < gb.totalItems) {
        hasMore = true;
      }
    } on ApiException catch (e) {
      warning = e.message;
    }

    // 2. Secondary: Open Library API (supplements or acts as fallback if Google Books rate-limited)
    try {
      final ol = await openLibrary.searchBooks(
        query,
        page: page,
        limit: pageSize,
        category: category,
      );
      for (final book in ol.books) {
        final dedupKey = _dedupKey(book);
        if (seenKeys.add(dedupKey)) {
          combined.add(book);
        }
      }
      if (page * pageSize < ol.numFound) {
        hasMore = true;
      }
      // If Open Library succeeded, clear warning unless both failed
      if (ol.books.isNotEmpty && combined.isNotEmpty) {
        warning = null;
      }
    } on ApiException catch (e) {
      if (combined.isEmpty) {
        throw ApiException(warning ?? e.message);
      }
    }

    return (books: combined, hasMore: hasMore, warning: warning);
  }

  Future<({List<Book> books, bool hasNext})> fetchPublicDomain({
    String? query,
    int page = 1,
  }) {
    return gutendex.fetchPublicDomainBooks(query: query, page: page);
  }

  Future<List<BookChapter>> fetchPublicDomainText(String textUrl) {
    return gutendex.fetchBookTextChapters(textUrl);
  }

  String _dedupKey(Book book) {
    final normTitle = book.title
        .toLowerCase()
        .replaceAll(RegExp(r'[^a-z0-9]'), '');
    final firstAuthor = book.author
        .split(',')
        .first
        .toLowerCase()
        .replaceAll(RegExp(r'[^a-z0-9]'), '');
    return '$normTitle|$firstAuthor';
  }
}

