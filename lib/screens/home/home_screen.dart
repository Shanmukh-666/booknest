import 'package:material_ui/material_ui.dart';
import 'package:provider/provider.dart';
import '../../models/book.dart';
import '../../providers/book_provider.dart';
import '../../providers/reading_provider.dart';
import '../../theme/app_colors.dart';
import '../../theme/app_text_styles.dart';
import '../../widgets/book_card.dart';
import '../../widgets/featured_book_banner.dart';
import '../../widgets/search_bar_widget.dart';
import '../book_details/book_details_screen.dart';
import '../reader/reader_screen.dart';

/// Screen 1: Home Dashboard.
class HomeScreen extends StatelessWidget {
  final ValueChanged<int> onNavigateTab;

  const HomeScreen({
    super.key,
    required this.onNavigateTab,
  });

  void _openBookDetails(BuildContext context, Book book) {
    Navigator.of(context).push(
      MaterialPageRoute(
        builder: (_) => BookDetailsScreen(book: book),
      ),
    );
  }

  void _openReader(BuildContext context, Book book) {
    final reading = context.read<ReadingProvider>();
    final savedChapter = reading.progressFor(book.id)?.chapterIndex ?? 0;
    Navigator.of(context).push(
      MaterialPageRoute(
        builder: (_) => ReaderScreen(
          book: book,
          initialChapterIndex: savedChapter,
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final bookProvider = context.watch<BookProvider>();
    final readingProvider = context.watch<ReadingProvider>();
    final continueReading = readingProvider.currentlyReadingBooks;
    final featured = bookProvider.featuredBook;
    final width = MediaQuery.sizeOf(context).width;
    final horizontalPad = width >= 900 ? 32.0 : 16.0;

    return CustomScrollView(
      slivers: [
        SliverPadding(
          padding: EdgeInsets.fromLTRB(horizontalPad, 20, horizontalPad, 28),
          sliver: SliverList(
            delegate: SliverChildListDelegate([
              _buildWelcomeHeader(context),
              const SizedBox(height: 18),
              SearchBarWidget(
                hintText: 'Search books, authors, or genres...',
                onChanged: (_) {},
                onSubmitted: (query) {
                  bookProvider.setSelectedCategory('All');
                  bookProvider.setSearchQuery(query);
                  onNavigateTab(1); // Explore tab
                },
              ),
              const SizedBox(height: 24),
              FeaturedBookBanner(
                book: featured,
                onReadNow: () => _openReader(context, featured),
                onViewDetails: () => _openBookDetails(context, featured),
              ),
              if (continueReading.isNotEmpty) ...[
                const SizedBox(height: 30),
                _SectionHeader(
                  title: 'Continue Reading',
                  actionLabel: 'My Library',
                  onAction: () => onNavigateTab(3),
                ),
                const SizedBox(height: 12),
                _HorizontalBookShelf(
                  books: continueReading,
                  showProgress: true,
                  onBookTap: (book) => _openReader(context, book),
                ),
              ],
              const SizedBox(height: 30),
              _SectionHeader(
                title: 'Browse Categories',
                actionLabel: 'All Categories',
                onAction: () => onNavigateTab(2),
              ),
              const SizedBox(height: 12),
              SizedBox(
                height: 44,
                child: ListView.separated(
                  scrollDirection: Axis.horizontal,
                  itemCount: bookProvider.categories.length,
                  separatorBuilder: (_, _) => const SizedBox(width: 10),
                  itemBuilder: (context, index) {
                    final cat = bookProvider.categories[index];
                    return ActionChip(
                      avatar: Icon(cat.icon, size: 17),
                      label: Text(cat.name),
                      onPressed: () {
                        bookProvider.setSearchQuery('');
                        bookProvider.setSelectedCategory(cat.name);
                        onNavigateTab(1);
                      },
                    );
                  },
                ),
              ),
              const SizedBox(height: 30),
              _SectionHeader(
                title: 'Trending Now',
                actionLabel: 'Explore All',
                onAction: () => onNavigateTab(1),
              ),
              const SizedBox(height: 12),
              _HorizontalBookShelf(
                books: bookProvider.trendingBooks,
                onBookTap: (book) => _openBookDetails(context, book),
              ),
              const SizedBox(height: 30),
              _SectionHeader(
                title: 'Popular Classics & Picks',
                actionLabel: 'See More',
                onAction: () => onNavigateTab(1),
              ),
              const SizedBox(height: 12),
              _HorizontalBookShelf(
                books: bookProvider.popularBooks,
                onBookTap: (book) => _openBookDetails(context, book),
              ),
              const SizedBox(height: 30),
              _SectionHeader(
                title: 'Recently Added',
                actionLabel: 'View Catalog',
                onAction: () => onNavigateTab(1),
              ),
              const SizedBox(height: 12),
              _HorizontalBookShelf(
                books: bookProvider.recentlyAddedBooks,
                onBookTap: (book) => _openBookDetails(context, book),
              ),
            ]),
          ),
        ),
      ],
    );
  }

  Widget _buildWelcomeHeader(BuildContext context) {
    final theme = Theme.of(context);
    return Row(
      crossAxisAlignment: CrossAxisAlignment.center,
      children: [
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                children: [
                  Container(
                    padding: const EdgeInsets.all(7),
                    decoration: BoxDecoration(
                      color: AppColors.accentAmber.withValues(alpha: 0.14),
                      borderRadius: BorderRadius.circular(10),
                    ),
                    child: const Icon(
                      Icons.local_library_rounded,
                      color: AppColors.accentAmber,
                      size: 20,
                    ),
                  ),
                  const SizedBox(width: 10),
                  Text(
                    'BookNest Library',
                    style: AppTextStyles.caption(
                      context,
                      color: theme.colorScheme.secondary,
                    ).copyWith(
                      fontWeight: FontWeight.w700,
                      letterSpacing: 0.6,
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 8),
              Text(
                'Welcome back, Reader',
                style: AppTextStyles.displayTitle(context).copyWith(fontSize: 28),
              ),
              const SizedBox(height: 4),
              Text(
                'Discover curated digital editions, track your reading, and build your personal shelf.',
                style: AppTextStyles.body(
                  context,
                  color: theme.colorScheme.onSurfaceVariant,
                ),
              ),
            ],
          ),
        ),
      ],
    );
  }
}

class _SectionHeader extends StatelessWidget {
  final String title;
  final String actionLabel;
  final VoidCallback onAction;

  const _SectionHeader({
    required this.title,
    required this.actionLabel,
    required this.onAction,
  });

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        Expanded(
          child: Text(title, style: AppTextStyles.sectionTitle(context)),
        ),
        TextButton(
          onPressed: onAction,
          child: Row(
            mainAxisSize: MainAxisSize.min,
            children: [
              Text(actionLabel),
              const SizedBox(width: 4),
              const Icon(Icons.arrow_forward_rounded, size: 16),
            ],
          ),
        ),
      ],
    );
  }
}

class _HorizontalBookShelf extends StatelessWidget {
  final List<Book> books;
  final ValueChanged<Book> onBookTap;
  final bool showProgress;

  const _HorizontalBookShelf({
    required this.books,
    required this.onBookTap,
    this.showProgress = false,
  });

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: showProgress ? 324 : 310,
      child: ListView.separated(
        scrollDirection: Axis.horizontal,
        itemCount: books.length,
        separatorBuilder: (_, _) => const SizedBox(width: 14),
        itemBuilder: (context, index) {
          final book = books[index];
          return BookCard(
            book: book,
            width: 172,
            showProgress: showProgress,
            onTap: () => onBookTap(book),
          );
        },
      ),
    );
  }
}
