import 'package:material_ui/material_ui.dart';
import 'package:provider/provider.dart';
import '../../providers/theme_provider.dart';
import '../../theme/app_text_styles.dart';

/// Screen 8: Application & Reading Preferences.
class SettingsScreen extends StatelessWidget {
  const SettingsScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final themeProvider = context.watch<ThemeProvider>();
    final theme = Theme.of(context);
    final width = MediaQuery.sizeOf(context).width;
    final horizontalPad = width >= 900 ? 32.0 : 16.0;

    return SingleChildScrollView(
      padding: EdgeInsets.fromLTRB(horizontalPad, 20, horizontalPad, 28),
      child: Center(
        child: ConstrainedBox(
          constraints: const BoxConstraints(maxWidth: 760),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                'Settings',
                style:
                    AppTextStyles.displayTitle(context).copyWith(fontSize: 28),
              ),
              const SizedBox(height: 4),
              Text(
                'Customize appearance and reading comfort. All preferences are saved locally.',
                style: AppTextStyles.body(
                  context,
                  color: theme.colorScheme.onSurfaceVariant,
                ),
              ),
              const SizedBox(height: 22),
              Text('Appearance', style: AppTextStyles.sectionTitle(context)),
              const SizedBox(height: 10),
              Card(
                child: SwitchListTile(
                  secondary: Icon(
                    themeProvider.isDarkMode
                        ? Icons.dark_mode_rounded
                        : Icons.light_mode_rounded,
                  ),
                  title: const Text('Dark Theme'),
                  subtitle: const Text(
                    'Switch between Warm Editorial Light and Midnight Dark',
                  ),
                  value: themeProvider.isDarkMode,
                  onChanged: (_) => themeProvider.toggleTheme(),
                ),
              ),
              const SizedBox(height: 22),
              Text(
                'Reading Preferences',
                style: AppTextStyles.sectionTitle(context),
              ),
              const SizedBox(height: 10),
              Card(
                child: Padding(
                  padding: const EdgeInsets.all(16),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      SwitchListTile(
                        contentPadding: EdgeInsets.zero,
                        secondary: const Icon(Icons.nights_stay_outlined),
                        title: const Text('Dark Reader Mode'),
                        subtitle: const Text(
                          'Use a dark canvas inside the sample book reader',
                        ),
                        value: themeProvider.isReaderDark,
                        onChanged: themeProvider.setReaderDark,
                      ),
                      const Divider(),
                      const SizedBox(height: 8),
                      Row(
                        children: [
                          const Icon(Icons.format_size_rounded, size: 20),
                          const SizedBox(width: 12),
                          const Text(
                            'Reader Font Size',
                            style: TextStyle(fontWeight: FontWeight.w600),
                          ),
                          const Spacer(),
                          Text(
                            '${themeProvider.readerFontSize.round()} pt',
                            style: const TextStyle(fontWeight: FontWeight.w700),
                          ),
                        ],
                      ),
                      Slider(
                        min: 14,
                        max: 26,
                        divisions: 6,
                        value: themeProvider.readerFontSize,
                        onChanged: themeProvider.setReaderFontSize,
                      ),
                      Container(
                        width: double.infinity,
                        padding: const EdgeInsets.all(14),
                        decoration: BoxDecoration(
                          color: theme.colorScheme.surfaceContainerHighest,
                          borderRadius: BorderRadius.circular(12),
                        ),
                        child: Text(
                          'Sample preview: Quiet mornings and good books turn small hours into lasting memories.',
                          style: AppTextStyles.readerBody(
                            fontSize: themeProvider.readerFontSize,
                            color: theme.colorScheme.onSurface,
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              ),
              const SizedBox(height: 22),
              Text('About BookNest', style: AppTextStyles.sectionTitle(context)),
              const SizedBox(height: 10),
              const Card(
                child: Column(
                  children: [
                    ListTile(
                      leading: Icon(Icons.local_library_rounded),
                      title: Text('BookNest – Online Book Library'),
                      subtitle: Text(
                        'Frontend-only digital library powered by local Dart catalog data and browser/device storage.',
                      ),
                    ),
                    Divider(height: 1),
                    ListTile(
                      leading: Icon(Icons.info_outline_rounded),
                      title: Text('Application Version'),
                      trailing: Text('1.0.0'),
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
