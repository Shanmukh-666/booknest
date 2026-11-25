import 'package:material_ui/material_ui.dart';

/// Origin of a book entry.
enum BookSource {
  localSample('Local Sample'),
  googleBooks('Google Books'),
  openLibrary('Open Library'),
  gutendex('Project Gutenberg');

  final String label;
  const BookSource(this.label);
}

/// Represents a single chapter or section in a book.
class BookChapter {
  final String title;
  final String content;

  const BookChapter({
    required this.title,
    required this.content,
  });

  Map<String, dynamic> toJson() => {
        'title': title,
        'content': content,
      };

  factory BookChapter.fromJson(Map<String, dynamic> json) {
    return BookChapter(
      title: json['title'] as String? ?? 'Section',
      content: json['content'] as String? ?? '',
    );
  }
}

/// Visual cover pattern styles for generated fallback book covers.
enum CoverPattern {
  editorialGrid,
  horizonBand,
  orbitalRings,
  archway,
  diagonalSplit,
  minimalFrame,
}

/// Core Book model for BookNest supporting local and external API sources.
class Book {
  final String id;
  final String title;
  final String author;
  final String description;
  final String category;
  final double rating;
  final int pageCount;
  final int publicationYear;
  final int popularityScore;
  final bool isFeatured;
  final bool isPopular;
  final bool isTrending;
  final bool isRecentlyAdded;
  final Color coverColor;
  final Color coverAccentColor;
  final CoverPattern coverPattern;
  final String? coverAssetPath;
  final List<BookChapter> chapters;

  // External API metadata
  final BookSource source;
  final String? coverImageUrl;
  final String? publisher;
  final String? publishedDateRaw;
  final String? previewLink;
  final String? infoLink;
  final String? fullTextUrl;
  final String? htmlReadUrl;
  final String? epubUrl;
  final bool isPublicDomain;
  final List<String> subjects;

  const Book({
    required this.id,
    required this.title,
    required this.author,
    required this.description,
    required this.category,
    required this.rating,
    required this.pageCount,
    required this.publicationYear,
    required this.popularityScore,
    this.isFeatured = false,
    this.isPopular = false,
    this.isTrending = false,
    this.isRecentlyAdded = false,
    required this.coverColor,
    required this.coverAccentColor,
    this.coverPattern = CoverPattern.minimalFrame,
    this.coverAssetPath,
    required this.chapters,
    this.source = BookSource.localSample,
    this.coverImageUrl,
    this.publisher,
    this.publishedDateRaw,
    this.previewLink,
    this.infoLink,
    this.fullTextUrl,
    this.htmlReadUrl,
    this.epubUrl,
    this.isPublicDomain = false,
    this.subjects = const [],
  });

  String get readingAvailabilityLabel {
    if (source == BookSource.localSample) {
      return 'Local Sample Edition';
    }
    if (isPublicDomain || fullTextUrl != null || htmlReadUrl != null) {
      return 'Public Domain • Free Reading';
    }
    if (previewLink != null && previewLink!.isNotEmpty) {
      return 'Preview Available';
    }
    return 'Metadata & Reference';
  }

  bool get hasInAppReadableChapters => chapters.isNotEmpty;

  Book copyWith({
    List<BookChapter>? chapters,
    String? description,
  }) {
    return Book(
      id: id,
      title: title,
      author: author,
      description: description ?? this.description,
      category: category,
      rating: rating,
      pageCount: pageCount,
      publicationYear: publicationYear,
      popularityScore: popularityScore,
      isFeatured: isFeatured,
      isPopular: isPopular,
      isTrending: isTrending,
      isRecentlyAdded: isRecentlyAdded,
      coverColor: coverColor,
      coverAccentColor: coverAccentColor,
      coverPattern: coverPattern,
      coverAssetPath: coverAssetPath,
      chapters: chapters ?? this.chapters,
      source: source,
      coverImageUrl: coverImageUrl,
      publisher: publisher,
      publishedDateRaw: publishedDateRaw,
      previewLink: previewLink,
      infoLink: infoLink,
      fullTextUrl: fullTextUrl,
      htmlReadUrl: htmlReadUrl,
      epubUrl: epubUrl,
      isPublicDomain: isPublicDomain,
      subjects: subjects,
    );
  }

  Map<String, dynamic> toJson() => {
        'id': id,
        'title': title,
        'author': author,
        'description': description,
        'category': category,
        'rating': rating,
        'pageCount': pageCount,
        'publicationYear': publicationYear,
        'popularityScore': popularityScore,
        'coverColor': coverColor.toARGB32(),
        'coverAccentColor': coverAccentColor.toARGB32(),
        'coverPattern': coverPattern.index,
        'source': source.index,
        'coverImageUrl': coverImageUrl,
        'publisher': publisher,
        'publishedDateRaw': publishedDateRaw,
        'previewLink': previewLink,
        'infoLink': infoLink,
        'fullTextUrl': fullTextUrl,
        'htmlReadUrl': htmlReadUrl,
        'epubUrl': epubUrl,
        'isPublicDomain': isPublicDomain,
        'subjects': subjects,
        'chapters': chapters.map((c) => c.toJson()).toList(),
      };

  factory Book.fromJson(Map<String, dynamic> json) {
    final sourceIndex = (json['source'] as num?)?.toInt() ?? 0;
    final patternIndex = (json['coverPattern'] as num?)?.toInt() ?? 0;
    final rawChapters = json['chapters'] as List<dynamic>? ?? const [];

    return Book(
      id: json['id'] as String? ?? 'unknown',
      title: json['title'] as String? ?? 'Untitled',
      author: json['author'] as String? ?? 'Unknown Author',
      description: json['description'] as String? ?? '',
      category: json['category'] as String? ?? 'General',
      rating: (json['rating'] as num?)?.toDouble() ?? 4.0,
      pageCount: (json['pageCount'] as num?)?.toInt() ?? 0,
      publicationYear: (json['publicationYear'] as num?)?.toInt() ?? 2024,
      popularityScore: (json['popularityScore'] as num?)?.toInt() ?? 50,
      coverColor: Color((json['coverColor'] as num?)?.toInt() ?? 0xFF16243B),
      coverAccentColor:
          Color((json['coverAccentColor'] as num?)?.toInt() ?? 0xFFD97724),
      coverPattern: CoverPattern
          .values[patternIndex.clamp(0, CoverPattern.values.length - 1)],
      source: BookSource
          .values[sourceIndex.clamp(0, BookSource.values.length - 1)],
      coverImageUrl: json['coverImageUrl'] as String?,
      publisher: json['publisher'] as String?,
      publishedDateRaw: json['publishedDateRaw'] as String?,
      previewLink: json['previewLink'] as String?,
      infoLink: json['infoLink'] as String?,
      fullTextUrl: json['fullTextUrl'] as String?,
      htmlReadUrl: json['htmlReadUrl'] as String?,
      epubUrl: json['epubUrl'] as String?,
      isPublicDomain: (json['isPublicDomain'] as bool?) ?? false,
      subjects: (json['subjects'] as List<dynamic>?)
              ?.map((e) => e.toString())
              .toList() ??
          const [],
      chapters: rawChapters
          .map((e) => BookChapter.fromJson(e as Map<String, dynamic>))
          .toList(),
    );
  }
}
