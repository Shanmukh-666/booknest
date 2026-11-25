import 'package:flutter/foundation.dart';
import '../data/books_data.dart';
import '../models/book.dart';
import '../services/local_storage_service.dart';

/// Manages user library state: favourites, bookmarks, and reading progress
/// across both local sample books and external API books.
class ReadingProvider extends ChangeNotifier {
  final LocalStorageService _storage;

  late List<String> _favouriteIds;
  late List<String> _bookmarkIds;
  late Map<String, ReadingProgress> _progressMap;
  late Map<String, Book> _savedApiBooks;

  ReadingProvider(this._storage) {
    _favouriteIds = List<String>.from(_storage.getFavourites());
    _bookmarkIds = List<String>.from(_storage.getBookmarks());
    _progressMap = Map<String, ReadingProgress>.from(
      _storage.getReadingProgress(),
    );
    _savedApiBooks = Map<String, Book>.from(_storage.getSavedApiBooks());
  }

  List<String> get favouriteIds => List.unmodifiable(_favouriteIds);
  List<String> get bookmarkIds => List.unmodifiable(_bookmarkIds);

  bool isFavourite(String bookId) => _favouriteIds.contains(bookId);
  bool isBookmarked(String bookId) => _bookmarkIds.contains(bookId);

  ReadingProgress? progressFor(String bookId) => _progressMap[bookId];

  Book? _resolveBook(String id) {
    for (final b in kBooks) {
      if (b.id == id) return b;
    }
    return _savedApiBooks[id];
  }

  Future<void> _cacheBookIfExternal(Book book) async {
    if (book.source != BookSource.localSample &&
        !_savedApiBooks.containsKey(book.id)) {
      _savedApiBooks[book.id] = book;
      await _storage.saveApiBooks(_savedApiBooks);
    }
  }

  List<Book> get favouriteBooks =>
      _favouriteIds.map(_resolveBook).whereType<Book>().toList();

  List<Book> get bookmarkedBooks =>
      _bookmarkIds.map(_resolveBook).whereType<Book>().toList();

  List<Book> get currentlyReadingBooks {
    final entries = _progressMap.entries
        .where((e) => !e.value.isCompleted)
        .toList()
      ..sort((a, b) => b.value.lastReadAt.compareTo(a.value.lastReadAt));
    return entries.map((e) => _resolveBook(e.key)).whereType<Book>().toList();
  }

  List<Book> get completedBooks {
    final entries = _progressMap.entries
        .where((e) => e.value.isCompleted)
        .toList()
      ..sort((a, b) => b.value.lastReadAt.compareTo(a.value.lastReadAt));
    return entries.map((e) => _resolveBook(e.key)).whereType<Book>().toList();
  }

  List<MapEntry<Book, ReadingProgress>> get recentActivity {
    final entries = _progressMap.entries.toList()
      ..sort((a, b) => b.value.lastReadAt.compareTo(a.value.lastReadAt));
    final result = <MapEntry<Book, ReadingProgress>>[];
    for (final entry in entries.take(6)) {
      final book = _resolveBook(entry.key);
      if (book != null) {
        result.add(MapEntry(book, entry.value));
      }
    }
    return result;
  }

  Future<void> toggleFavourite(String bookId, {Book? book}) async {
    if (book != null) {
      await _cacheBookIfExternal(book);
    }
    if (_favouriteIds.contains(bookId)) {
      _favouriteIds.remove(bookId);
    } else {
      _favouriteIds.add(bookId);
    }
    await _storage.saveFavourites(_favouriteIds);
    notifyListeners();
  }

  Future<void> toggleBookmark(String bookId, {Book? book}) async {
    if (book != null) {
      await _cacheBookIfExternal(book);
    }
    if (_bookmarkIds.contains(bookId)) {
      _bookmarkIds.remove(bookId);
    } else {
      _bookmarkIds.add(bookId);
    }
    await _storage.saveBookmarks(_bookmarkIds);
    notifyListeners();
  }

  Future<void> updateProgress({
    required String bookId,
    required int chapterIndex,
    required int totalChapters,
    bool? markCompleted,
    Book? book,
  }) async {
    if (book != null) {
      await _cacheBookIfExternal(book);
    }
    final safeTotal = totalChapters <= 0 ? 1 : totalChapters;
    final clampedChapter = chapterIndex.clamp(0, safeTotal - 1);
    final isLast = clampedChapter == safeTotal - 1;
    final completed = markCompleted ?? _progressMap[bookId]?.isCompleted ?? false;
    final fraction = completed ? 1.0 : ((clampedChapter + 1) / safeTotal);

    _progressMap[bookId] = ReadingProgress(
      chapterIndex: clampedChapter,
      progressFraction: isLast && completed ? 1.0 : fraction,
      isCompleted: completed,
      lastReadAt: DateTime.now(),
    );
    await _storage.saveReadingProgress(_progressMap);
    notifyListeners();
  }

  Future<void> toggleCompleted(
    String bookId,
    int totalChapters, {
    Book? book,
  }) async {
    if (book != null) {
      await _cacheBookIfExternal(book);
    }
    final current = _progressMap[bookId];
    final nextCompleted = !(current?.isCompleted ?? false);
    final chapterIdx = current?.chapterIndex ?? 0;
    _progressMap[bookId] = ReadingProgress(
      chapterIndex:
          nextCompleted ? (totalChapters - 1).clamp(0, 999) : chapterIdx,
      progressFraction: nextCompleted
          ? 1.0
          : ((chapterIdx + 1) / (totalChapters <= 0 ? 1 : totalChapters)),
      isCompleted: nextCompleted,
      lastReadAt: DateTime.now(),
    );
    await _storage.saveReadingProgress(_progressMap);
    notifyListeners();
  }
}
