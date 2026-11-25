import 'package:flutter/foundation.dart';
import '../data/books_data.dart';
import '../data/categories_data.dart';
import '../models/book.dart';
import '../models/category.dart';

enum BookSortOption {
  popularity('Popularity'),
  rating('Highest Rated'),
  title('Title (A–Z)');

  final String label;
  const BookSortOption(this.label);
}

/// Manages the book catalog, search, category filtering, and sorting.
class BookProvider extends ChangeNotifier {
  final List<Book> _allBooks = kBooks;
  final List<BookCategory> _categories = kCategories;

  String _searchQuery = '';
  String _selectedCategory = 'All';
  BookSortOption _sortOption = BookSortOption.popularity;

  List<Book> get allBooks => _allBooks;
  List<BookCategory> get categories => _categories;
  String get searchQuery => _searchQuery;
  String get selectedCategory => _selectedCategory;
  BookSortOption get sortOption => _sortOption;

  Book get featuredBook => _allBooks.firstWhere(
        (b) => b.isFeatured,
        orElse: () => _allBooks.first,
      );

  List<Book> get trendingBooks =>
      _allBooks.where((b) => b.isTrending).toList();

  List<Book> get popularBooks =>
      _allBooks.where((b) => b.isPopular).toList();

  List<Book> get recentlyAddedBooks =>
      _allBooks.where((b) => b.isRecentlyAdded).toList();

  List<Book> get filteredBooks {
    final query = _searchQuery.trim().toLowerCase();
    final list = _allBooks.where((book) {
      final matchesCategory =
          _selectedCategory == 'All' || book.category == _selectedCategory;
      final matchesQuery = query.isEmpty ||
          book.title.toLowerCase().contains(query) ||
          book.author.toLowerCase().contains(query) ||
          book.category.toLowerCase().contains(query);
      return matchesCategory && matchesQuery;
    }).toList();

    switch (_sortOption) {
      case BookSortOption.popularity:
        list.sort((a, b) => b.popularityScore.compareTo(a.popularityScore));
      case BookSortOption.rating:
        list.sort((a, b) => b.rating.compareTo(a.rating));
      case BookSortOption.title:
        list.sort((a, b) => a.title.compareTo(b.title));
    }
    return list;
  }

  List<Book> booksByCategory(String categoryName) {
    return _allBooks.where((b) => b.category == categoryName).toList();
  }

  int bookCountForCategory(String categoryName) {
    return _allBooks.where((b) => b.category == categoryName).length;
  }

  Book? findById(String id) {
    for (final book in _allBooks) {
      if (book.id == id) return book;
    }
    return null;
  }

  void setSearchQuery(String query) {
    if (_searchQuery == query) return;
    _searchQuery = query;
    notifyListeners();
  }

  void setSelectedCategory(String category) {
    if (_selectedCategory == category) return;
    _selectedCategory = category;
    notifyListeners();
  }

  void setSortOption(BookSortOption option) {
    if (_sortOption == option) return;
    _sortOption = option;
    notifyListeners();
  }

  void resetFilters() {
    _searchQuery = '';
    _selectedCategory = 'All';
    _sortOption = BookSortOption.popularity;
    notifyListeners();
  }
}

