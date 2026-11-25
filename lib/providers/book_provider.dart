import 'package:flutter/foundation.dart';
import '../data/books_data.dart';
import '../data/categories_data.dart';
import '../models/book.dart';
import '../models/category.dart';
import '../services/api/api_client.dart';
import '../services/api/book_repository.dart';

enum BookSortOption {
  popularity('Popularity'),
  rating('Highest Rated'),
  title('Title (A–Z)');

  final String label;
  const BookSortOption(this.label);
}

enum ApiLoadState { idle, loading, loaded, error }

enum ExploreSourceMode {
  online('Online APIs'),
  publicDomain('Public Domain'),
  offlineCatalog('Offline Shelf');

  final String label;
  const ExploreSourceMode(this.label);
}

/// Manages local sample catalog + live Google Books, Open Library, and Gutendex APIs.
class BookProvider extends ChangeNotifier {
  final BookRepository _repository;

  final List<Book> _allBooks = kBooks;
  final List<BookCategory> _categories = kCategories;

  String _searchQuery = '';
  String _selectedCategory = 'All';
  BookSortOption _sortOption = BookSortOption.popularity;
  ExploreSourceMode _sourceMode = ExploreSourceMode.online;

  // Online Combined Search (Google Books + Open Library)
  List<Book> _onlineBooks = [];
  ApiLoadState _onlineState = ApiLoadState.idle;
  String? _onlineError;
  int _onlinePage = 1;
  bool _hasMoreOnline = false;
  bool _isLoadingMoreOnline = false;

  // Gutendex Public Domain Catalog
  List<Book> _publicDomainBooks = [];
  ApiLoadState _publicDomainState = ApiLoadState.idle;
  String? _publicDomainError;
  int _publicDomainPage = 1;
  bool _hasMorePublicDomain = false;
  bool _isLoadingMorePublicDomain = false;

  BookProvider({BookRepository? repository})
      : _repository = repository ?? BookRepository.create();

  List<Book> get allBooks => _allBooks;
  List<BookCategory> get categories => _categories;
  String get searchQuery => _searchQuery;
  String get selectedCategory => _selectedCategory;
  BookSortOption get sortOption => _sortOption;
  ExploreSourceMode get sourceMode => _sourceMode;

  List<Book> get onlineBooks => _onlineBooks;
  ApiLoadState get onlineState => _onlineState;
  String? get onlineError => _onlineError;
  bool get hasMoreOnline => _hasMoreOnline;
  bool get isLoadingMoreOnline => _isLoadingMoreOnline;

  List<Book> get publicDomainBooks => _publicDomainBooks;
  ApiLoadState get publicDomainState => _publicDomainState;
  String? get publicDomainError => _publicDomainError;
  bool get hasMorePublicDomain => _hasMorePublicDomain;
  bool get isLoadingMorePublicDomain => _isLoadingMorePublicDomain;

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

  List<Book> get filteredLocalBooks {
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

    return _sortBooks(list);
  }

  /// Active list for Explore screen based on selected source mode.
  List<Book> get activeExploreBooks {
    switch (_sourceMode) {
      case ExploreSourceMode.online:
        return _sortBooks(List<Book>.from(_onlineBooks));
      case ExploreSourceMode.publicDomain:
        return _sortBooks(List<Book>.from(_publicDomainBooks));
      case ExploreSourceMode.offlineCatalog:
        return filteredLocalBooks;
    }
  }

  List<Book> _sortBooks(List<Book> list) {
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

  /// Initial load for Home & Explore so live API data is fetched once automatically.
  Future<void> ensureInitialOnlineLoad() async {
    if (_onlineState == ApiLoadState.idle) {
      await fetchOnlineBooks(query: _searchQuery, category: _selectedCategory);
    }
    if (_publicDomainState == ApiLoadState.idle) {
      await fetchPublicDomainBooks(query: _searchQuery);
    }
  }

  Future<void> fetchOnlineBooks({
    String? query,
    String? category,
    bool loadMore = false,
  }) async {
    if (loadMore) {
      if (_isLoadingMoreOnline || !_hasMoreOnline) return;
      _isLoadingMoreOnline = true;
      _onlinePage += 1;
      notifyListeners();
    } else {
      _onlineState = ApiLoadState.loading;
      _onlineError = null;
      _onlinePage = 1;
      notifyListeners();
    }

    try {
      final res = await _repository.searchCombined(
        query: query ?? _searchQuery,
        category: category ?? _selectedCategory,
        page: _onlinePage,
      );
      if (loadMore) {
        final existingIds = _onlineBooks.map((b) => b.id).toSet();
        _onlineBooks = [
          ..._onlineBooks,
          ...res.books.where((b) => !existingIds.contains(b.id)),
        ];
      } else {
        _onlineBooks = res.books;
      }
      _hasMoreOnline = res.hasMore;
      _onlineError = res.warning;
      _onlineState = ApiLoadState.loaded;
    } on ApiException catch (e) {
      _onlineError = e.message;
      if (!loadMore) {
        _onlineState = ApiLoadState.error;
      }
    } catch (_) {
      _onlineError = 'Failed to load books from external APIs.';
      if (!loadMore) {
        _onlineState = ApiLoadState.error;
      }
    } finally {
      _isLoadingMoreOnline = false;
      notifyListeners();
    }
  }

  Future<void> fetchPublicDomainBooks({
    String? query,
    bool loadMore = false,
  }) async {
    if (loadMore) {
      if (_isLoadingMorePublicDomain || !_hasMorePublicDomain) return;
      _isLoadingMorePublicDomain = true;
      _publicDomainPage += 1;
      notifyListeners();
    } else {
      _publicDomainState = ApiLoadState.loading;
      _publicDomainError = null;
      _publicDomainPage = 1;
      notifyListeners();
    }

    try {
      final res = await _repository.fetchPublicDomain(
        query: query ?? _searchQuery,
        page: _publicDomainPage,
      );
      if (loadMore) {
        final existingIds = _publicDomainBooks.map((b) => b.id).toSet();
        _publicDomainBooks = [
          ..._publicDomainBooks,
          ...res.books.where((b) => !existingIds.contains(b.id)),
        ];
      } else {
        _publicDomainBooks = res.books;
      }
      _hasMorePublicDomain = res.hasNext;
      _publicDomainState = ApiLoadState.loaded;
    } on ApiException catch (e) {
      _publicDomainError = e.message;
      if (!loadMore) {
        _publicDomainState = ApiLoadState.error;
      }
    } catch (_) {
      _publicDomainError = 'Unable to reach Gutendex public-domain library.';
      if (!loadMore) {
        _publicDomainState = ApiLoadState.error;
      }
    } finally {
      _isLoadingMorePublicDomain = false;
      notifyListeners();
    }
  }

  Future<List<BookChapter>> loadPublicDomainChapters(Book book) async {
    if (book.chapters.isNotEmpty) return book.chapters;
    final url = book.fullTextUrl;
    if (url == null || url.isEmpty) {
      throw const ApiException(
        'No plain-text URL is available for this public-domain book.',
      );
    }
    return _repository.fetchPublicDomainText(url);
  }

  void setSourceMode(ExploreSourceMode mode) {
    if (_sourceMode == mode) return;
    _sourceMode = mode;
    notifyListeners();
    if (mode == ExploreSourceMode.online &&
        _onlineState == ApiLoadState.idle) {
      fetchOnlineBooks();
    } else if (mode == ExploreSourceMode.publicDomain &&
        _publicDomainState == ApiLoadState.idle) {
      fetchPublicDomainBooks();
    }
  }

  void setSearchQuery(String query, {bool triggerApi = true}) {
    _searchQuery = query;
    notifyListeners();
    if (!triggerApi) return;
    if (_sourceMode == ExploreSourceMode.online) {
      fetchOnlineBooks(query: query, category: _selectedCategory);
    } else if (_sourceMode == ExploreSourceMode.publicDomain) {
      fetchPublicDomainBooks(query: query);
    }
  }

  void setSelectedCategory(String category, {bool triggerApi = true}) {
    if (_selectedCategory == category) return;
    _selectedCategory = category;
    notifyListeners();
    if (triggerApi && _sourceMode == ExploreSourceMode.online) {
      fetchOnlineBooks(query: _searchQuery, category: category);
    }
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
    if (_sourceMode == ExploreSourceMode.online) {
      fetchOnlineBooks(query: '', category: 'All');
    } else if (_sourceMode == ExploreSourceMode.publicDomain) {
      fetchPublicDomainBooks(query: '');
    }
  }
}
