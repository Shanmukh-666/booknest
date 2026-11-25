import 'package:material_ui/material_ui.dart';
import 'package:provider/provider.dart';
import 'providers/book_provider.dart';
import 'providers/reading_provider.dart';
import 'providers/theme_provider.dart';
import 'services/local_storage_service.dart';
import 'theme/app_theme.dart';
import 'widgets/app_shell.dart';

/// Root BookNest application widget.
class BookNestApp extends StatelessWidget {
  final LocalStorageService storageService;

  const BookNestApp({
    super.key,
    required this.storageService,
  });

  @override
  Widget build(BuildContext context) {
    return MultiProvider(
      providers: [
        ChangeNotifierProvider(create: (_) => ThemeProvider(storageService)),
        ChangeNotifierProvider(create: (_) => BookProvider()),
        ChangeNotifierProvider(create: (_) => ReadingProvider(storageService)),
      ],
      child: Consumer<ThemeProvider>(
        builder: (context, themeProvider, _) {
          return MaterialApp(
            title: 'BookNest – Online Book Library',
            debugShowCheckedModeBanner: false,
            theme: AppTheme.lightTheme,
            darkTheme: AppTheme.darkTheme,
            themeMode: themeProvider.themeMode,
            home: const AppShell(),
          );
        },
      ),
    );
  }
}
