import 'package:material_ui/material_ui.dart';
import '../../models/book.dart';
import 'api_client.dart';

/// Primary API service integrating Google Books v1 Volumes API.
/// Docs: https://developers.google.com/books/docs/v1/using
class GoogleBooksService {
  static const String _baseHost = 'www.googleapis.com';
  static const String _volumesPath = '/books/v1/volumes';

  final ApiClient _client;

  GoogleBooksService(this._client);

  Future<({List<Book> books, int totalItems})> searchBooks(
    String query, {
    int startIndex = 0,
    int maxResults = 20,
    String? category,
  }) async {
    final trimmed = query.trim();
    final qParts = <String>[];
    if (trimmed.isNotEmpty) {
      qParts.add(trimmed);
    }
    if (category != null && category != 'All' && category.isNotEmpty) {
      qParts.add('subject:$category');
    }
    final effectiveQuery = qParts.isEmpty ? 'subject:fiction' : qParts.join('+');

    final uri = Uri.https(_baseHost, _volumesPath, {
      'q': effectiveQuery,
      'startIndex': startIndex.toString(),
      'maxResults': maxResults.clamp(1, 40).toString(),
      'printType': 'books',
    });

    final json = await _client.getJson(uri);
    final totalItems = (json['totalItems'] as num?)?.toInt() ?? 0;
    final items = json['items'] as List<dynamic>? ?? const [];

    final books = <Book>[];
    for (var i = 0; i < items.length; i++) {
      final item = items[i];
      if (item is Map<String, dynamic>) {
        books.add(_parseVolume(item, index: startIndex + i));
      }
    }
    return (books: books, totalItems: totalItems);
  }

  Book _parseVolume(Map<String, dynamic> item, {required int index}) {
    final id = item['id'] as String? ?? 'gb-$index';
    final volumeInfo = item['volumeInfo'] as Map<String, dynamic>? ?? const {};
    final accessInfo = item['accessInfo'] as Map<String, dynamic>? ?? const {};

    final title = (volumeInfo['title'] as String?)?.trim();
    final authorsRaw = volumeInfo['authors'] as List<dynamic>?;
    final author = (authorsRaw != null && authorsRaw.isNotEmpty)
        ? authorsRaw.map((e) => e.toString()).join(', ')
        : 'Unknown Author';

    final description = (volumeInfo['description'] as String?)?.trim() ??
        'No description provided by Google Books for this edition.';

    final categoriesRaw = volumeInfo['categories'] as List<dynamic>?;
    final category = (categoriesRaw != null && categoriesRaw.isNotEmpty)
        ? categoriesRaw.first.toString()
        : 'General';

    final pageCount = (volumeInfo['pageCount'] as num?)?.toInt() ?? 0;
    final publishedDate = (volumeInfo['publishedDate'] as String?) ?? '';
    final year = _extractYear(publishedDate);
    final publisher = volumeInfo['publisher'] as String?;
    final rating = (volumeInfo['averageRating'] as num?)?.toDouble() ?? 4.2;

    final imageLinks =
        volumeInfo['imageLinks'] as Map<String, dynamic>? ?? const {};
    String? coverUrl = (imageLinks['thumbnail'] as String?) ??
        (imageLinks['smallThumbnail'] as String?);
    if (coverUrl != null && coverUrl.startsWith('http://')) {
      coverUrl = coverUrl.replaceFirst('http://', 'https://');
    }

    final previewLink = _ensureHttps(
      (volumeInfo['previewLink'] as String?) ??
          (accessInfo['webReaderLink'] as String?),
    );
    final infoLink = _ensureHttps(volumeInfo['infoLink'] as String?);
    final isPublicDomain = (accessInfo['publicDomain'] as bool?) ?? false;

    const palette = [
      (Color(0xFF16243B), Color(0xFFD97724)),
      (Color(0xFF1D4E5F), Color(0xFFF4A261)),
      (Color(0xFF2B2D42), Color(0xFF8D99AE)),
      (Color(0xFF3D405B), Color(0xFFE07A5F)),
    ];
    final colors = palette[index % palette.length];

    return Book(
      id: 'gb_$id',
      title: (title == null || title.isEmpty) ? 'Untitled Book' : title,
      author: author,
      description: description,
      category: category,
      rating: rating.clamp(1.0, 5.0),
      pageCount: pageCount,
      publicationYear: year,
      popularityScore: 80 - (index % 20),
      coverColor: colors.$1,
      coverAccentColor: colors.$2,
      coverPattern: CoverPattern.values[index % CoverPattern.values.length],
      chapters: const [],
      source: BookSource.googleBooks,
      coverImageUrl: coverUrl,
      publisher: publisher,
      publishedDateRaw: publishedDate.isEmpty ? null : publishedDate,
      previewLink: previewLink,
      infoLink: infoLink,
      isPublicDomain: isPublicDomain,
      subjects: categoriesRaw?.map((e) => e.toString()).toList() ?? const [],
    );
  }

  int _extractYear(String dateStr) {
    final match = RegExp(r'\d{4}').firstMatch(dateStr);
    if (match != null) {
      return int.tryParse(match.group(0)!) ?? 2024;
    }
    return 2024;
  }

  String? _ensureHttps(String? url) {
    if (url == null || url.isEmpty) return null;
    if (url.startsWith('http://')) {
      return url.replaceFirst('http://', 'https://');
    }
    return url;
  }
}

