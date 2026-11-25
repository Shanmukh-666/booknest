import 'package:material_ui/material_ui.dart';
import '../../models/book.dart';
import 'api_client.dart';

/// Secondary API service integrating Open Library Search & Covers APIs.
/// Docs: https://openlibrary.org/developers/api
class OpenLibraryService {
  static const String _baseHost = 'openlibrary.org';
  static const String _searchPath = '/search.json';

  final ApiClient _client;

  OpenLibraryService(this._client);

  Future<({List<Book> books, int numFound})> searchBooks(
    String query, {
    int page = 1,
    int limit = 20,
    String? category,
  }) async {
    final trimmed = query.trim();
    final params = <String, String>{
      'page': page.toString(),
      'limit': limit.toString(),
      'fields':
          'key,title,author_name,first_publish_year,publisher,number_of_pages_median,cover_i,subject,ratings_average,first_sentence',
    };

    if (trimmed.isNotEmpty) {
      params['q'] = trimmed;
    } else if (category != null && category != 'All') {
      params['subject'] = category.toLowerCase();
    } else {
      params['q'] = 'classic literature';
    }

    final uri = Uri.https(_baseHost, _searchPath, params);
    final json = await _client.getJson(uri);
    final numFound = (json['numFound'] as num?)?.toInt() ?? 0;
    final docs = json['docs'] as List<dynamic>? ?? const [];

    final books = <Book>[];
    for (var i = 0; i < docs.length; i++) {
      final doc = docs[i];
      if (doc is Map<String, dynamic>) {
        books.add(_parseDoc(doc, index: (page - 1) * limit + i));
      }
    }
    return (books: books, numFound: numFound);
  }

  Book _parseDoc(Map<String, dynamic> doc, {required int index}) {
    final key = doc['key'] as String? ?? '/works/OL$index';
    final title = (doc['title'] as String?)?.trim() ?? 'Untitled Work';

    final authorsRaw = doc['author_name'] as List<dynamic>?;
    final author = (authorsRaw != null && authorsRaw.isNotEmpty)
        ? authorsRaw.take(2).map((e) => e.toString()).join(', ')
        : 'Unknown Author';

    final coverId = (doc['cover_i'] as num?)?.toInt();
    final coverUrl = coverId != null
        ? 'https://covers.openlibrary.org/b/id/$coverId-L.jpg'
        : null;

    final year = (doc['first_publish_year'] as num?)?.toInt() ?? 2020;
    final pageCount = (doc['number_of_pages_median'] as num?)?.toInt() ?? 0;
    final rating = (doc['ratings_average'] as num?)?.toDouble() ?? 4.1;

    final publishersRaw = doc['publisher'] as List<dynamic>?;
    final publisher = (publishersRaw != null && publishersRaw.isNotEmpty)
        ? publishersRaw.first.toString()
        : null;

    final subjectsRaw = doc['subject'] as List<dynamic>?;
    final subjects = subjectsRaw?.take(5).map((e) => e.toString()).toList() ??
        const <String>[];
    final category = subjects.isNotEmpty ? subjects.first : 'General';

    final firstSentence = doc['first_sentence'];
    String description = 'Published edition indexed by Open Library.';
    if (firstSentence is List && firstSentence.isNotEmpty) {
      description = firstSentence.first.toString();
    } else if (firstSentence is String && firstSentence.isNotEmpty) {
      description = firstSentence;
    } else if (subjects.isNotEmpty) {
      description = 'Topics: ${subjects.join(', ')}.';
    }

    final workUrl = 'https://openlibrary.org$key';

    return Book(
      id: 'ol_${key.replaceAll('/', '_')}',
      title: title,
      author: author,
      description: description,
      category: category,
      rating: rating.clamp(1.0, 5.0),
      pageCount: pageCount,
      publicationYear: year,
      popularityScore: 72 - (index % 20),
      coverColor: const Color(0xFF23395B),
      coverAccentColor: const Color(0xFFE9C46A),
      coverPattern: CoverPattern.values[index % CoverPattern.values.length],
      chapters: const [],
      source: BookSource.openLibrary,
      coverImageUrl: coverUrl,
      publisher: publisher,
      publishedDateRaw: year.toString(),
      previewLink: workUrl,
      infoLink: workUrl,
      subjects: subjects,
    );
  }
}

