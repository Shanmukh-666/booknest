import 'package:material_ui/material_ui.dart';
import 'package:provider/provider.dart';
import '../../models/book.dart';
import '../../providers/reading_provider.dart';
import '../../theme/app_colors.dart';
import '../../theme/app_text_styles.dart';
import '../../widgets/book_cover.dart';
import '../book_details/book_details_screen.dart';
import '../reader/reader_screen.dart';

/// Screen 5: Personal Bookshelf (Currently Reading, Favourites, Bookmarks, Completed).
class LibraryScreen extends StatelessWidget {
  final VoidCallback onBrowseCatalog;

  const LibraryScreen({
    super.key,
    required this.onBrowseCatalog,
  });

  @override
  Widget build(BuildContext context) {
    final reading = context.watch<ReadingProvider>();
    final width = MediaQuery.sizeOf(context).width;
    final horizontalPad = width >= 900 ? 32.0 : 16.0;

    return DefaultTabController(
      length: 4,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Padding(
            padding: EdgeInsets.fromLTRB(horizontalPad, 20, horizontalPad, 8),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  'My Library',
                  style:
                      AppTextStyles.displayTitle(context).copyWith(fontSize: 28),
                ),
                const SizedBox(height: 4),
                Text(
                  'Your saved favourites, bookmarks, and reading progress stored locally.',
                  style: AppTextStyles.body(
                    context,
                    color: Theme.of(context).colorScheme.onSurfaceVariant,
                  ),
                ),
              ],
            ),
          ),
          Padding(
            padding: EdgeInsets.symmetric(horizontal: horizontalPad),
            child: TabBar(
              isScrollable: true,
              tabAlignment: TabAlignment.start,
              tabs: [
                Tab(text: 'Reading (${reading.currentlyReadingBooks.length})'),
                Tab(text: 'Favourites (${reading.favouriteBooks.length})'),
                Tab(text: 'Bookmarked (${reading.bookmarkedBooks.length})'),
                Tab(text: 'Completed (${reading.completedBooks.length})'),
              ],
            ),
          ),
          const Divider(height: 1),
          Expanded(
            child: TabBarView(
              children: [
                _LibraryBookList(
                  books: reading.currentlyReadingBooks,
                  emptyTitle: 'Nothing in progress yet',
                  emptySubtitle:
                      'Open any book and tap Read Now to start tracking your progress.',
                  onBrowseCatalog: onBrowseCatalog,
                  mode: _LibraryListMode.reading,
                ),
                _LibraryBookList(
                  books: reading.favouriteBooks,
                  emptyTitle: 'No favourite books yet',
                  emptySubtitle:
                      'Tap the heart icon on any book to save it to your favourites.',
                  onBrowseCatalog: onBrowseCatalog,
                  mode: _LibraryListMode.favourites,
                ),
                _LibraryBookList(
                  books: reading.bookmarkedBooks,
                  emptyTitle: 'No bookmarked titles yet',
                  emptySubtitle:
                      'Bookmark books you want to revisit later.',
                  onBrowseCatalog: onBrowseCatalog,
                  mode: _LibraryListMode.bookmarks,
                ),
                _LibraryBookList(
                  books: reading.completedBooks,
                  emptyTitle: 'No completed books yet',
                  emptySubtitle:
                      'Finish reading a sample edition or mark a book as completed.',
                  onBrowseCatalog: onBrowseCatalog,
                  mode: _LibraryListMode.completed,
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

enum _LibraryListMode { reading, favourites, bookmarks, completed }

class _LibraryBookList extends StatelessWidget {
  final List<Book> books;
  final String emptyTitle;
  final String emptySubtitle;
  final VoidCallback onBrowseCatalog;
  final _LibraryListMode mode;

  const _LibraryBookList({
    required this.books,
    required this.emptyTitle,
    required this.emptySubtitle,
    required this.onBrowseCatalog,
    required this.mode,
  });

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final reading = context.watch<ReadingProvider>();
    final width = MediaQuery.sizeOf(context).width;
    final horizontalPad = width >= 900 ? 32.0 : 16.0;

    if (books.isEmpty) {
      return Center(
        child: Padding(
          padding: const EdgeInsets.all(32),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Icon(
                Icons.bookmarks_outlined,
                size: 54,
                color: theme.colorScheme.onSurfaceVariant,
              ),
              const SizedBox(height: 14),
              Text(emptyTitle, style: AppTextStyles.sectionTitle(context)),
              const SizedBox(height: 6),
              Text(
                emptySubtitle,
                textAlign: TextAlign.center,
                style: AppTextStyles.body(
                  context,
                  color: theme.colorScheme.onSurfaceVariant,
                ),
              ),
              const SizedBox(height: 18),
              FilledButton.icon(
                onPressed: onBrowseCatalog,
                icon: const Icon(Icons.explore_rounded, size: 18),
                label: const Text('Explore Books'),
              ),
            ],
          ),
        ),
      );
    }

    return ListView.separated(
      padding: EdgeInsets.fromLTRB(horizontalPad, 16, horizontalPad, 28),
      itemCount: books.length,
      separatorBuilder: (_, _) => const SizedBox(height: 12),
      itemBuilder: (context, index) {
        final book = books[index];
        final progress = reading.progressFor(book.id);

        return Card(
          child: InkWell(
            borderRadius: BorderRadius.circular(16),
            onTap: () {
              Navigator.of(context).push(
                MaterialPageRoute(
                  builder: (_) => BookDetailsScreen(book: book),
                ),
              );
            },
            child: Padding(
              padding: const EdgeInsets.all(14),
              child: Row(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  BookCover(
                    book: book,
                    width: 72,
                    height: 104,
                    borderRadius: 8,
                    showDetails: false,
                  ),
                  const SizedBox(width: 16),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          book.title,
                          maxLines: 2,
                          overflow: TextOverflow.ellipsis,
                          style: AppTextStyles.bookTitle(context, fontSize: 16),
                        ),
                        const SizedBox(height: 3),
                        Text(
                          '${book.author} • ${book.category}',
                          style: AppTextStyles.caption(context),
                        ),
                        const SizedBox(height: 10),
                        if (progress != null) ...[
                          Row(
                            children: [
                              Expanded(
                                child: ClipRRect(
                                  borderRadius: BorderRadius.circular(4),
                                  child: LinearProgressIndicator(
                                    value: progress.progressFraction
                                        .clamp(0.05, 1.0),
                                    minHeight: 6,
                                  ),
                                ),
                              ),
                              const SizedBox(width: 10),
                              Text(
                                progress.isCompleted
                                    ? 'Completed'
                                    : 'Ch. ${progress.chapterIndex + 1}/${book.chapters.length}',
                                style: AppTextStyles.caption(context).copyWith(
                                  fontWeight: FontWeight.w700,
                                  color: progress.isCompleted
                                      ? AppColors.success
                                      : null,
                                ),
                              ),
                            ],
                          ),
                          const SizedBox(height: 10),
                        ],
                        Wrap(
                          spacing: 8,
                          runSpacing: 6,
                          children: [
                            FilledButton.tonalIcon(
                              onPressed: () {
                                if (book.hasInAppReadableChapters ||
                                    book.fullTextUrl != null) {
                                  Navigator.of(context).push(
                                    MaterialPageRoute(
                                      builder: (_) => ReaderScreen(
                                        book: book,
                                        initialChapterIndex:
                                            progress?.chapterIndex ?? 0,
                                      ),
                                    ),
                                  );
                                } else {
                                  Navigator.of(context).push(
                                    MaterialPageRoute(
                                      builder: (_) =>
                                          BookDetailsScreen(book: book),
                                    ),
                                  );
                                }
                              },
                              icon: const Icon(
                                Icons.menu_book_rounded,
                                size: 16,
                              ),
                              label: Text(
                                progress != null
                                    ? 'Continue Reading'
                                    : (book.hasInAppReadableChapters ||
                                            book.fullTextUrl != null
                                        ? 'Read Now'
                                        : 'View Details'),
                              ),
                            ),
                            if (mode == _LibraryListMode.favourites)
                              TextButton.icon(
                                onPressed: () => reading.toggleFavourite(
                                  book.id,
                                  book: book,
                                ),
                                icon: const Icon(Icons.delete_outline_rounded,
                                    size: 16),
                                label: const Text('Remove'),
                              ),
                            if (mode == _LibraryListMode.bookmarks)
                              TextButton.icon(
                                onPressed: () => reading.toggleBookmark(
                                  book.id,
                                  book: book,
                                ),
                                icon: const Icon(Icons.delete_outline_rounded,
                                    size: 16),
                                label: const Text('Remove'),
                              ),
                          ],
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),
          ),
        );
      },
    );
  }
}
