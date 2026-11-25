import 'package:material_ui/material_ui.dart';
import 'package:provider/provider.dart';
import '../../providers/reading_provider.dart';
import '../../theme/app_colors.dart';
import '../../theme/app_text_styles.dart';
import '../book_details/book_details_screen.dart';

/// Screen 7: Frontend-only Local Reader Profile & Statistics.
class ProfileScreen extends StatelessWidget {
  const ProfileScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final reading = context.watch<ReadingProvider>();
    final theme = Theme.of(context);
    final width = MediaQuery.sizeOf(context).width;
    final horizontalPad = width >= 900 ? 32.0 : 16.0;

    final totalActive =
        reading.currentlyReadingBooks.length + reading.completedBooks.length;
    final activity = reading.recentActivity;

    return SingleChildScrollView(
      padding: EdgeInsets.fromLTRB(horizontalPad, 20, horizontalPad, 28),
      child: Center(
        child: ConstrainedBox(
          constraints: const BoxConstraints(maxWidth: 920),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                'Reader Profile',
                style:
                    AppTextStyles.displayTitle(context).copyWith(fontSize: 28),
              ),
              const SizedBox(height: 16),
              Card(
                child: Padding(
                  padding: const EdgeInsets.all(20),
                  child: Row(
                    children: [
                      CircleAvatar(
                        radius: 34,
                        backgroundColor:
                            AppColors.accentAmber.withValues(alpha: 0.16),
                        child: const Text(
                          'BN',
                          style: TextStyle(
                            fontSize: 22,
                            fontWeight: FontWeight.w800,
                            color: AppColors.accentAmber,
                          ),
                        ),
                      ),
                      const SizedBox(width: 18),
                      Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              'BookNest Reader',
                              style: AppTextStyles.headline(context),
                            ),
                            const SizedBox(height: 4),
                            Text(
                              'Local Demo Profile • Saved on this browser/device',
                              style: AppTextStyles.caption(context),
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),
                ),
              ),
              const SizedBox(height: 20),
              Text(
                'Reading Statistics',
                style: AppTextStyles.sectionTitle(context),
              ),
              const SizedBox(height: 12),
              LayoutBuilder(
                builder: (context, constraints) {
                  final cols = constraints.maxWidth >= 640 ? 4 : 2;
                  return GridView.count(
                    crossAxisCount: cols,
                    shrinkWrap: true,
                    physics: const NeverScrollableScrollPhysics(),
                    mainAxisSpacing: 12,
                    crossAxisSpacing: 12,
                    childAspectRatio: 1.5,
                    children: [
                      _StatTile(
                        label: 'Books Opened',
                        value: '$totalActive',
                        icon: Icons.auto_stories_rounded,
                        color: theme.colorScheme.primary,
                      ),
                      _StatTile(
                        label: 'Currently Reading',
                        value: '${reading.currentlyReadingBooks.length}',
                        icon: Icons.menu_book_rounded,
                        color: AppColors.accentAmber,
                      ),
                      _StatTile(
                        label: 'Favourites',
                        value: '${reading.favouriteBooks.length}',
                        icon: Icons.favorite_rounded,
                        color: const Color(0xFFE05252),
                      ),
                      _StatTile(
                        label: 'Completed',
                        value: '${reading.completedBooks.length}',
                        icon: Icons.check_circle_rounded,
                        color: AppColors.success,
                      ),
                    ],
                  );
                },
              ),
              const SizedBox(height: 26),
              Text(
                'Recent Reading Activity',
                style: AppTextStyles.sectionTitle(context),
              ),
              const SizedBox(height: 12),
              if (activity.isEmpty)
                Card(
                  child: Padding(
                    padding: const EdgeInsets.all(24),
                    child: Center(
                      child: Text(
                        'No reading activity recorded yet. Start reading any book to see your timeline here.',
                        textAlign: TextAlign.center,
                        style: AppTextStyles.body(
                          context,
                          color: theme.colorScheme.onSurfaceVariant,
                        ),
                      ),
                    ),
                  ),
                )
              else
                ...activity.map((entry) {
                  final book = entry.key;
                  final progress = entry.value;
                  return Card(
                    margin: const EdgeInsets.only(bottom: 10),
                    child: ListTile(
                      leading: Icon(
                        progress.isCompleted
                            ? Icons.check_circle_rounded
                            : Icons.schedule_rounded,
                        color: progress.isCompleted
                            ? AppColors.success
                            : AppColors.accentAmber,
                      ),
                      title: Text(
                        book.title,
                        style: AppTextStyles.bookTitle(context, fontSize: 15),
                      ),
                      subtitle: Text(
                        progress.isCompleted
                            ? 'Completed sample edition'
                            : 'Chapter ${progress.chapterIndex + 1} of ${book.chapters.length} • ${(progress.progressFraction * 100).round()}%',
                        style: AppTextStyles.caption(context),
                      ),
                      trailing: const Icon(Icons.chevron_right_rounded),
                      onTap: () {
                        Navigator.of(context).push(
                          MaterialPageRoute(
                            builder: (_) => BookDetailsScreen(book: book),
                          ),
                        );
                      },
                    ),
                  );
                }),
            ],
          ),
        ),
      ),
    );
  }
}

class _StatTile extends StatelessWidget {
  final String label;
  final String value;
  final IconData icon;
  final Color color;

  const _StatTile({
    required this.label,
    required this.value,
    required this.icon,
    required this.color,
  });

  @override
  Widget build(BuildContext context) {
    return Card(
      child: Padding(
        padding: const EdgeInsets.all(14),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(icon, color: color, size: 22),
            const Spacer(),
            Text(
              value,
              style: AppTextStyles.headline(context).copyWith(fontSize: 22),
            ),
            Text(
              label,
              maxLines: 1,
              overflow: TextOverflow.ellipsis,
              style: AppTextStyles.caption(context),
            ),
          ],
        ),
      ),
    );
  }
}
