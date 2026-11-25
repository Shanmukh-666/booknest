import 'package:flutter/foundation.dart';
import '../data/books_data.dart';
import '../models/book.dart';
import '../services/local_storage_service.dart';

/// Manages user library state: favourites, bookmarks, and reading progress.
class ReadingProvider extends ChangeNotifier {
  final LocalStorageService _storage;

  late List<String> _favouriteIds;
  late List<String> _bookmarkIds;
  late Map<String, ReadingProgress> _progressMap;

  ReadingProvider(this._storage) {
    _favouriteIds = List<String>.from(_storage.getFavourites());
    _bookmarkIds = List<String>.from(_storage.getBookmarks());
    _progressMap = Map<String, ReadingProgress>.from(
      _storage.getReadingProgress(),
    );
  }

  List<String> get favouriteIds => List.unmodifiable(_favouriteIds);
  List<String> get bookmarkIds => List.unmodifiable(_bookmarkIds);

  bool isFavourite(String bookId) => _favouriteIds.contains(bookId);
  bool isBookmarked(String bookId) => _bookmarkIds.contains(bookId);

  ReadingProgress? progressFor(String bookId) => _progressMap[bookId];

  List<Book> get favouriteBooks =>
      kBooks.where((b) => _favouriteIds.contains(b.id)).toList();

  List<Book> get bookmarkedBooks =>
      kBooks.where((b) => _bookmarkIds.contains(b.id)).toList();

  List<Book> get currentlyReadingBooks {
    final entries = _progressMap.entries
        .where((e) => !e.value.isCompleted)
        .toList()
      ..sort((a, b) => b.value.lastReadAt.compareTo(a.value.lastReadAt));
    return entries
        .map((e) => kBooks.where((b) => b.id == e.key).firstOrNull)
        .whereType<Book>()
        .toList();
  }

  List<Book> get completedBooks {
    final entries = _progressMap.entries
        .where((e) => e.value.isCompleted)
        .toList()
      ..sort((a, b) => b.value.lastReadAt.compareTo(a.value.lastReadAt));
    return entries
        .map((e) => kBooks.where((b) => b.id == e.key).firstOrNull)
        .whereType<Book>()
        .toList();
  }

  List<MapEntry<Book, ReadingProgress>> get recentActivity {
    final entries = _progressMap.entries.toList()
      ..sort((a, b) => b.value.lastReadAt.compareTo(a.value.lastReadAt));
    final result = <MapEntry<Book, ReadingProgress>>[];
    for (final entry in entries.take(6)) {
      final book = kBooks.where((b) => b.id == entry.key).firstOrNull;
      if (book != null) {
        result.add(MapEntry(book, entry.value));
      }
    }
    return result;
  }

  Future<void> toggleFavourite(String bookId) async {
    if (_favouriteIds.contains(bookId)) {
      _favouriteIds.remove(bookId);
    } else {
      _favouriteIds.add(bookId);
    }
    await _storage.saveFavourites(_favouriteIds);
    notifyListeners();
  }

  Future<void> toggleBookmark(String bookId) async {
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
  }) async {
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

  Future<void> toggleCompleted(String bookId, int totalChapters) async {
    final current = _progressMap[bookId];
    final nextCompleted = !(current?.isCompleted ?? false);
    final chapterIdx = current?.chapterIndex ?? 0;
    _progressMap[bookId] = ReadingProgress(
      chapterIndex: nextCompleted ? (totalChapters - 1).clamp(0, 999) : chapterIdx,
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

