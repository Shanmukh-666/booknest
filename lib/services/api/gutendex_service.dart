import 'package:material_ui/material_ui.dart';
import '../../models/book.dart';
import 'api_client.dart';

/// Public-domain books API service integrating Gutendex (Project Gutenberg).
/// Docs: https://gutendex.com/
class GutendexService {
  static const String _baseHost = 'gutendex.com';
  static const String _booksPath = '/books/';

  final ApiClient _client;

  GutendexService(this._client);

  Future<({List<Book> books, bool hasNext})> fetchPublicDomainBooks({
    String? query,
    int page = 1,
  }) async {
    final params = <String, String>{
      'page': page.toString(),
    };
    if (query != null && query.trim().isNotEmpty) {
      params['search'] = query.trim();
    }

    final uri = Uri.https(_baseHost, _booksPath, params);
    final json = await _client.getJson(
      uri,
      timeout: const Duration(seconds: 22),
    );
    final hasNext = json['next'] != null;
    final results = json['results'] as List<dynamic>? ?? const [];

    final books = <Book>[];
    for (var i = 0; i < results.length; i++) {
      final item = results[i];
      if (item is Map<String, dynamic>) {
        books.add(_parseGutendexBook(item, index: i));
      }
    }
    return (books: books, hasNext: hasNext);
  }

  /// Fetches and paginates real plain-text content from Project Gutenberg.
  Future<List<BookChapter>> fetchBookTextChapters(String textUrl) async {
    final raw = await _client.getText(
      Uri.parse(textUrl),
      timeout: const Duration(seconds: 20),
    );
    final cleaned = _stripGutenbergBoilerplate(raw);
    if (cleaned.trim().isEmpty) {
      throw const ApiException('The plain-text edition returned empty content.');
    }
    return _paginateText(cleaned);
  }

  Book _parseGutendexBook(Map<String, dynamic> item, {required int index}) {
    final id = (item['id'] as num?)?.toInt() ?? index;
    final title = (item['title'] as String?)?.trim() ?? 'Public Domain Work';

    final authorsRaw = item['authors'] as List<dynamic>? ?? const [];
    final author = authorsRaw.isNotEmpty
        ? authorsRaw
            .map((a) => (a as Map<String, dynamic>)['name'] ?? 'Unknown')
            .join(', ')
        : 'Public Domain Author';

    final subjectsRaw = item['subjects'] as List<dynamic>? ?? const [];
    final subjects = subjectsRaw.take(5).map((e) => e.toString()).toList();
    final bookshelves = item['bookshelves'] as List<dynamic>? ?? const [];
    final category = bookshelves.isNotEmpty
        ? bookshelves.first.toString().replaceFirst('Category: ', '')
        : (subjects.isNotEmpty ? subjects.first : 'Public Domain');

    final summaries = item['summaries'] as List<dynamic>? ?? const [];
    final description = summaries.isNotEmpty
        ? summaries.first.toString()
        : (subjects.isNotEmpty
            ? 'Project Gutenberg public-domain edition. Subjects: ${subjects.join(', ')}.'
            : 'Free public-domain ebook provided by Project Gutenberg via Gutendex.');

    final formats = item['formats'] as Map<String, dynamic>? ?? const {};
    final coverUrl = _ensureHttps(formats['image/jpeg'] as String?);
    final plainTextUrl = _ensureHttps(
      (formats['text/plain; charset=utf-8'] as String?) ??
          (formats['text/plain; charset=us-ascii'] as String?) ??
          (formats['text/plain'] as String?),
    );
    final htmlUrl = _ensureHttps(
      (formats['text/html'] as String?) ??
          (formats['text/html; charset=utf-8'] as String?),
    );
    final epubUrl = _ensureHttps(formats['application/epub+zip'] as String?);
    final gutenbergPage = 'https://www.gutenberg.org/ebooks/$id';

    final downloads = (item['download_count'] as num?)?.toInt() ?? 0;

    return Book(
      id: 'gx_$id',
      title: title,
      author: author,
      description: description,
      category: category,
      rating: 4.6,
      pageCount: 0,
      publicationYear: 1900,
      popularityScore: downloads,
      coverColor: const Color(0xFF1B4332),
      coverAccentColor: const Color(0xFF74C69D),
      coverPattern: CoverPattern.archway,
      chapters: const [],
      source: BookSource.gutendex,
      coverImageUrl: coverUrl,
      publisher: 'Project Gutenberg',
      previewLink: htmlUrl ?? gutenbergPage,
      infoLink: gutenbergPage,
      fullTextUrl: plainTextUrl,
      htmlReadUrl: htmlUrl ?? gutenbergPage,
      epubUrl: epubUrl,
      isPublicDomain: true,
      subjects: subjects,
    );
  }

  String _stripGutenbergBoilerplate(String raw) {
    var text = raw.replaceAll('\r\n', '\n');
    final startMatch = RegExp(r'\*\*\* START OF (THE|THIS) PROJECT GUTENBERG EBOOK.*?\*\*\*',
            caseSensitive: false)
        .firstMatch(text);
    if (startMatch != null) {
      text = text.substring(startMatch.end);
    }
    final endMatch = RegExp(r'\*\*\* END OF (THE|THIS) PROJECT GUTENBERG EBOOK.*?\*\*\*',
            caseSensitive: false)
        .firstMatch(text);
    if (endMatch != null) {
      text = text.substring(0, endMatch.start);
    }
    return text.trim();
  }

  List<BookChapter> _paginateText(String text) {
    const int targetChunkSize = 2800;
    const int maxSections = 40;
    final paragraphs = text.split(RegExp(r'\n{2,}'));
    final chapters = <BookChapter>[];
    final buffer = StringBuffer();

    for (final para in paragraphs) {
      final cleaned = para.trim();
      if (cleaned.isEmpty) continue;
      if (buffer.length + cleaned.length > targetChunkSize &&
          buffer.isNotEmpty) {
        chapters.add(
          BookChapter(
            title: 'Section ${chapters.length + 1}',
            content: buffer.toString().trim(),
          ),
        );
        buffer.clear();
        if (chapters.length >= maxSections) break;
      }
      buffer.writeln(cleaned);
      buffer.writeln();
    }

    if (buffer.isNotEmpty && chapters.length < maxSections) {
      chapters.add(
        BookChapter(
          title: 'Section ${chapters.length + 1}',
          content: buffer.toString().trim(),
        ),
      );
    }

    return chapters;
  }

  String? _ensureHttps(String? url) {
    if (url == null || url.isEmpty) return null;
    if (url.startsWith('http://')) {
      return url.replaceFirst('http://', 'https://');
    }
    return url;
  }
}

