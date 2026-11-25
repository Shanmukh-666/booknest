import 'package:material_ui/material_ui.dart';

/// Represents a single chapter in a sample book.
class BookChapter {
  final String title;
  final String content;

  const BookChapter({
    required this.title,
    required this.content,
  });
}

/// Visual cover pattern styles for generated editorial book covers.
enum CoverPattern {
  editorialGrid,
  horizonBand,
  orbitalRings,
  archway,
  diagonalSplit,
  minimalFrame,
}

/// Core Book model for BookNest.
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
  });
}
