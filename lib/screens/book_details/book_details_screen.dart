import 'package:material_ui/material_ui.dart';
import 'package:provider/provider.dart';
import 'package:url_launcher/url_launcher.dart';
import '../../models/book.dart';
import '../../providers/reading_provider.dart';
import '../../theme/app_colors.dart';
import '../../theme/app_text_styles.dart';
import '../../widgets/book_cover.dart';
import '../reader/reader_screen.dart';

/// Screen 3: Editorial Book Details view supporting local & external API books.
class BookDetailsScreen extends StatelessWidget {
  final Book book;

  const BookDetailsScreen({
    super.key,
    required this.book,
  });

  void _openReader(BuildContext context, int chapterIndex) {
    Navigator.of(context).push(
      MaterialPageRoute(
        builder: (_) => ReaderScreen(
          book: book,
          initialChapterIndex: chapterIndex,
        ),
      ),
    );
  }

  Future<void> _launchExternalUrl(BuildContext context, String url) async {
    final uri = Uri.tryParse(url);
    if (uri == null) return;
    final launched = await launchUrl(uri, mode: LaunchMode.externalApplication);
    if (!launched && context.mounted) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Could not open $url')),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    final reading = context.watch<ReadingProvider>();
    final isFav = reading.isFavourite(book.id);
    final isBookmarked = reading.isBookmarked(book.id);
    final progress = reading.progressFor(book.id);
    final theme = Theme.of(context);
    final width = MediaQuery.sizeOf(context).width;
    final isWide = width >= 760;

    return Scaffold(
      appBar: AppBar(
        title: const Text('Book Details'),
        actions: [
          IconButton(
            tooltip: isFav ? 'Remove from Favourites' : 'Add to Favourites',
            icon: Icon(
              isFav ? Icons.favorite_rounded : Icons.favorite_border_rounded,
              color: isFav ? const Color(0xFFE05252) : null,
            ),
            onPressed: () => reading.toggleFavourite(book.id, book: book),
          ),
          IconButton(
            tooltip: isBookmarked ? 'Remove Bookmark' : 'Bookmark Book',
            icon: Icon(
              isBookmarked
                  ? Icons.bookmark_rounded
                  : Icons.bookmark_border_rounded,
              color: isBookmarked ? AppColors.accentAmber : null,
            ),
            onPressed: () => reading.toggleBookmark(book.id, book: book),
          ),
          const SizedBox(width: 8),
        ],
      ),
      body: SingleChildScrollView(
        padding: EdgeInsets.symmetric(
          horizontal: isWide ? 40 : 18,
          vertical: 20,
        ),
        child: Center(
          child: ConstrainedBox(
            constraints: const BoxConstraints(maxWidth: 960),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                if (isWide)
                  Row(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      BookCover(
                        book: book,
                        width: 220,
                        height: 320,
                        borderRadius: 14,
                      ),
                      const SizedBox(width: 36),
                      Expanded(
                        child: _buildMetaSection(
                          context,
                          reading,
                          isFav,
                          isBookmarked,
                          progress?.chapterIndex ?? 0,
                          progress != null,
                        ),
                      ),
                    ],
                  )
                else
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Center(
                        child: BookCover(
                          book: book,
                          width: 190,
                          height: 276,
                          borderRadius: 14,
                        ),
                      ),
                      const SizedBox(height: 24),
                      _buildMetaSection(
                        context,
                        reading,
                        isFav,
                        isBookmarked,
                        progress?.chapterIndex ?? 0,
                        progress != null,
                      ),
                    ],
                  ),
                const SizedBox(height: 32),
                const Divider(),
                const SizedBox(height: 20),
                Text(
                  'About this Book',
                  style: AppTextStyles.sectionTitle(context),
                ),
                const SizedBox(height: 10),
                Text(
                  book.description,
                  style: AppTextStyles.body(context, fontSize: 15.5).copyWith(
                    height: 1.7,
                  ),
                ),
                if (book.subjects.isNotEmpty) ...[
                  const SizedBox(height: 20),
                  Wrap(
                    spacing: 8,
                    runSpacing: 8,
                    children: book.subjects
                        .take(6)
                        .map((s) => Chip(label: Text(s)))
                        .toList(),
                  ),
                ],
                if (book.chapters.isNotEmpty) ...[
                  const SizedBox(height: 28),
                  Text(
                    'Sample Chapters (${book.chapters.length})',
                    style: AppTextStyles.sectionTitle(context),
                  ),
                  const SizedBox(height: 12),
                  ...List.generate(book.chapters.length, (index) {
                    final chapter = book.chapters[index];
                    final isCurrent = progress?.chapterIndex == index;
                    return Card(
                      margin: const EdgeInsets.only(bottom: 10),
                      child: ListTile(
                        leading: CircleAvatar(
                          backgroundColor: isCurrent
                              ? AppColors.accentAmber.withValues(alpha: 0.18)
                              : theme.colorScheme.surfaceContainerHighest,
                          child: Text(
                            '${index + 1}',
                            style: TextStyle(
                              fontWeight: FontWeight.w700,
                              color: isCurrent
                                  ? AppColors.accentAmber
                                  : theme.colorScheme.onSurface,
                            ),
                          ),
                        ),
                        title: Text(
                          chapter.title,
                          style: AppTextStyles.bookTitle(context, fontSize: 15),
                        ),
                        subtitle: Text(
                          isCurrent
                              ? 'Last read chapter'
                              : 'Tap to start reading from here',
                          style: AppTextStyles.caption(context),
                        ),
                        trailing: const Icon(Icons.chevron_right_rounded),
                        onTap: () => _openReader(context, index),
                      ),
                    );
                  }),
                ],
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildMetaSection(
    BuildContext context,
    ReadingProvider reading,
    bool isFav,
    bool isBookmarked,
    int savedChapter,
    bool hasProgress,
  ) {
    final theme = Theme.of(context);
    final canReadInApp =
        book.hasInAppReadableChapters || book.fullTextUrl != null;

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Wrap(
          spacing: 8,
          runSpacing: 8,
          children: [
            Container(
              padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 5),
              decoration: BoxDecoration(
                color: theme.colorScheme.secondaryContainer,
                borderRadius: BorderRadius.circular(20),
              ),
              child: Text(
                book.category,
                style: TextStyle(
                  color: theme.colorScheme.onSecondaryContainer,
                  fontSize: 12,
                  fontWeight: FontWeight.w700,
                ),
              ),
            ),
            Container(
              padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 5),
              decoration: BoxDecoration(
                color: theme.colorScheme.surfaceContainerHighest,
                borderRadius: BorderRadius.circular(20),
              ),
              child: Text(
                '${book.source.label} • ${book.readingAvailabilityLabel}',
                style: AppTextStyles.caption(context).copyWith(
                  fontWeight: FontWeight.w600,
                ),
              ),
            ),
          ],
        ),
        const SizedBox(height: 12),
        Text(
          book.title,
          style: AppTextStyles.displayTitle(context),
        ),
        const SizedBox(height: 6),
        Text(
          'by ${book.author}',
          style: AppTextStyles.sectionTitle(
            context,
            color: theme.colorScheme.onSurfaceVariant,
          ).copyWith(fontWeight: FontWeight.w500),
        ),
        if (book.publisher != null && book.publisher!.isNotEmpty) ...[
          const SizedBox(height: 4),
          Text(
            'Publisher: ${book.publisher}',
            style: AppTextStyles.caption(context),
          ),
        ],
        const SizedBox(height: 18),
        Wrap(
          spacing: 12,
          runSpacing: 10,
          children: [
            _StatPill(
              icon: Icons.star_rounded,
              iconColor: AppColors.ratingStar,
              label: '${book.rating.toStringAsFixed(1)} Rating',
            ),
            if (book.pageCount > 0)
              _StatPill(
                icon: Icons.menu_book_rounded,
                label: '${book.pageCount} Pages',
              ),
            _StatPill(
              icon: Icons.calendar_today_rounded,
              label: book.publishedDateRaw ?? '${book.publicationYear}',
            ),
          ],
        ),
        const SizedBox(height: 24),
        Wrap(
          spacing: 12,
          runSpacing: 12,
          children: [
            if (canReadInApp)
              FilledButton.icon(
                onPressed: () => _openReader(context, savedChapter),
                style: FilledButton.styleFrom(
                  backgroundColor: AppColors.accentAmber,
                  foregroundColor: Colors.white,
                  padding:
                      const EdgeInsets.symmetric(horizontal: 22, vertical: 15),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(12),
                  ),
                ),
                icon: const Icon(Icons.chrome_reader_mode_rounded, size: 19),
                label: Text(
                  hasProgress
                      ? 'Continue Reading'
                      : (book.isPublicDomain ? 'Read Full Text' : 'Read Now'),
                  style: const TextStyle(fontWeight: FontWeight.w700),
                ),
              ),
            if (book.previewLink != null && book.previewLink!.isNotEmpty)
              FilledButton.tonalIcon(
                onPressed: () =>
                    _launchExternalUrl(context, book.previewLink!),
                style: FilledButton.styleFrom(
                  padding:
                      const EdgeInsets.symmetric(horizontal: 18, vertical: 15),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(12),
                  ),
                ),
                icon: const Icon(Icons.open_in_new_rounded, size: 18),
                label: Text(
                  book.isPublicDomain
                      ? 'Read on Gutenberg'
                      : 'Open Preview / Info',
                ),
              ),
            if (book.epubUrl != null && book.epubUrl!.isNotEmpty)
              OutlinedButton.icon(
                onPressed: () => _launchExternalUrl(context, book.epubUrl!),
                style: OutlinedButton.styleFrom(
                  padding:
                      const EdgeInsets.symmetric(horizontal: 16, vertical: 15),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(12),
                  ),
                ),
                icon: const Icon(Icons.download_rounded, size: 18),
                label: const Text('EPUB'),
              ),
            OutlinedButton.icon(
              onPressed: () => reading.toggleFavourite(book.id, book: book),
              style: OutlinedButton.styleFrom(
                padding:
                    const EdgeInsets.symmetric(horizontal: 16, vertical: 15),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(12),
                ),
              ),
              icon: Icon(
                isFav ? Icons.favorite_rounded : Icons.favorite_border_rounded,
                color: isFav ? const Color(0xFFE05252) : null,
              ),
              label: Text(isFav ? 'Favourited' : 'Favourite'),
            ),
            OutlinedButton.icon(
              onPressed: () => reading.toggleBookmark(book.id, book: book),
              style: OutlinedButton.styleFrom(
                padding:
                    const EdgeInsets.symmetric(horizontal: 16, vertical: 15),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(12),
                ),
              ),
              icon: Icon(
                isBookmarked
                    ? Icons.bookmark_rounded
                    : Icons.bookmark_border_rounded,
                color: isBookmarked ? AppColors.accentAmber : null,
              ),
              label: Text(isBookmarked ? 'Bookmarked' : 'Bookmark'),
            ),
          ],
        ),
      ],
    );
  }
}

class _StatPill extends StatelessWidget {
  final IconData icon;
  final Color? iconColor;
  final String label;

  const _StatPill({
    required this.icon,
    this.iconColor,
    required this.label,
  });

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
      decoration: BoxDecoration(
        color: theme.colorScheme.surfaceContainerHighest,
        borderRadius: BorderRadius.circular(10),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(
            icon,
            size: 16,
            color: iconColor ?? theme.colorScheme.onSurfaceVariant,
          ),
          const SizedBox(width: 6),
          Text(
            label,
            style: AppTextStyles.caption(
              context,
              color: theme.colorScheme.onSurface,
            ).copyWith(fontWeight: FontWeight.w600),
          ),
        ],
      ),
    );
  }
}
