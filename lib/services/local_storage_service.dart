import 'dart:convert';
import 'package:shared_preferences/shared_preferences.dart';
import '../models/book.dart';

/// Persisted reading progress for a single book.
class ReadingProgress {
  final int chapterIndex;
  final double progressFraction;
  final bool isCompleted;
  final DateTime lastReadAt;

  const ReadingProgress({
    required this.chapterIndex,
    required this.progressFraction,
    required this.isCompleted,
    required this.lastReadAt,
  });

  Map<String, dynamic> toJson() => {
        'chapterIndex': chapterIndex,
        'progressFraction': progressFraction,
        'isCompleted': isCompleted,
        'lastReadAt': lastReadAt.toIso8601String(),
      };

  factory ReadingProgress.fromJson(Map<String, dynamic> json) {
    return ReadingProgress(
      chapterIndex: (json['chapterIndex'] as num?)?.toInt() ?? 0,
      progressFraction: (json['progressFraction'] as num?)?.toDouble() ?? 0.0,
      isCompleted: (json['isCompleted'] as bool?) ?? false,
      lastReadAt: DateTime.tryParse(json['lastReadAt'] as String? ?? '') ??
          DateTime.now(),
    );
  }
}

/// Local persistence service backed by SharedPreferences.
class LocalStorageService {
  static const String _keyFavourites = 'booknest_favourites';
  static const String _keyBookmarks = 'booknest_bookmarks';
  static const String _keyProgress = 'booknest_reading_progress';
  static const String _keyThemeMode = 'booknest_theme_mode';
  static const String _keyReaderFontSize = 'booknest_reader_font_size';
  static const String _keyReaderDark = 'booknest_reader_dark';
  static const String _keySavedBooks = 'booknest_saved_api_books';

  final SharedPreferences _prefs;

  LocalStorageService(this._prefs);

  static Future<LocalStorageService> init() async {
    final prefs = await SharedPreferences.getInstance();
    return LocalStorageService(prefs);
  }

  // Favourites
  List<String> getFavourites() => _prefs.getStringList(_keyFavourites) ?? [];

  Future<void> saveFavourites(List<String> ids) =>
      _prefs.setStringList(_keyFavourites, ids);

  // Bookmarks
  List<String> getBookmarks() => _prefs.getStringList(_keyBookmarks) ?? [];

  Future<void> saveBookmarks(List<String> ids) =>
      _prefs.setStringList(_keyBookmarks, ids);

  // Reading Progress
  Map<String, ReadingProgress> getReadingProgress() {
    final raw = _prefs.getString(_keyProgress);
    if (raw == null || raw.isEmpty) return {};
    try {
      final decoded = jsonDecode(raw) as Map<String, dynamic>;
      return decoded.map(
        (key, value) => MapEntry(
          key,
          ReadingProgress.fromJson(value as Map<String, dynamic>),
        ),
      );
    } catch (_) {
      return {};
    }
  }

  Future<void> saveReadingProgress(Map<String, ReadingProgress> progress) {
    final encoded = jsonEncode(
      progress.map((key, value) => MapEntry(key, value.toJson())),
    );
    return _prefs.setString(_keyProgress, encoded);
  }

  // Theme Mode ('light' | 'dark' | 'system')
  String getThemeMode() => _prefs.getString(_keyThemeMode) ?? 'light';

  Future<void> saveThemeMode(String mode) =>
      _prefs.setString(_keyThemeMode, mode);

  // Reader Font Size
  double getReaderFontSize() => _prefs.getDouble(_keyReaderFontSize) ?? 18.0;

  Future<void> saveReaderFontSize(double size) =>
      _prefs.setDouble(_keyReaderFontSize, size);

  // Reader Dark Theme
  bool getReaderDark() => _prefs.getBool(_keyReaderDark) ?? false;

  Future<void> saveReaderDark(bool isDark) =>
      _prefs.setBool(_keyReaderDark, isDark);

  // Cached External API Books (for Favourites / Bookmarks / Progress persistence)
  Map<String, Book> getSavedApiBooks() {
    final raw = _prefs.getString(_keySavedBooks);
    if (raw == null || raw.isEmpty) return {};
    try {
      final decoded = jsonDecode(raw) as Map<String, dynamic>;
      return decoded.map(
        (key, value) => MapEntry(
          key,
          Book.fromJson(value as Map<String, dynamic>),
        ),
      );
    } catch (_) {
      return {};
    }
  }

  Future<void> saveApiBooks(Map<String, Book> books) {
    final encoded = jsonEncode(
      books.map((key, value) => MapEntry(key, value.toJson())),
    );
    return _prefs.setString(_keySavedBooks, encoded);
  }
}

