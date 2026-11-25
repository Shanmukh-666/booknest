import 'package:material_ui/material_ui.dart';
import '../services/local_storage_service.dart';

/// Manages app-wide light/dark theme and reader typography preferences.
class ThemeProvider extends ChangeNotifier {
  final LocalStorageService _storage;

  late ThemeMode _themeMode;
  late double _readerFontSize;
  late bool _isReaderDark;

  ThemeProvider(this._storage) {
    final storedTheme = _storage.getThemeMode();
    _themeMode = switch (storedTheme) {
      'dark' => ThemeMode.dark,
      'system' => ThemeMode.system,
      _ => ThemeMode.light,
    };
    _readerFontSize = _storage.getReaderFontSize().clamp(14.0, 26.0);
    _isReaderDark = _storage.getReaderDark();
  }

  ThemeMode get themeMode => _themeMode;
  bool get isDarkMode => _themeMode == ThemeMode.dark;
  double get readerFontSize => _readerFontSize;
  bool get isReaderDark => _isReaderDark;

  Future<void> toggleTheme() async {
    _themeMode =
        _themeMode == ThemeMode.dark ? ThemeMode.light : ThemeMode.dark;
    await _storage.saveThemeMode(
      _themeMode == ThemeMode.dark ? 'dark' : 'light',
    );
    notifyListeners();
  }

  Future<void> setThemeMode(ThemeMode mode) async {
    _themeMode = mode;
    final label = switch (mode) {
      ThemeMode.dark => 'dark',
      ThemeMode.system => 'system',
      ThemeMode.light => 'light',
    };
    await _storage.saveThemeMode(label);
    notifyListeners();
  }

  Future<void> setReaderFontSize(double size) async {
    _readerFontSize = size.clamp(14.0, 26.0);
    await _storage.saveReaderFontSize(_readerFontSize);
    notifyListeners();
  }

  Future<void> setReaderDark(bool value) async {
    _isReaderDark = value;
    await _storage.saveReaderDark(value);
    notifyListeners();
  }
}
