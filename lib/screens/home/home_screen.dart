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

/// Screen 1: Home Dashboard with local shelves and live external API discovery.
class HomeScreen extends StatefulWidget {
  final ValueChanged<int> onNavigateTab;

  const HomeScreen({
    super.key,
    required this.onNavigateTab,
  });

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      if (mounted) {
        context.read<BookProvider>().ensureInitialOnlineLoad();
      }
    });
  }

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

    return Align(
      alignment: Alignment.topCenter,
      child: ConstrainedBox(
        constraints: const BoxConstraints(maxWidth: 1320),
        child: CustomScrollView(
          slivers: [
            SliverPadding(
              padding: EdgeInsets.fromLTRB(horizontalPad, 20, horizontalPad, 28),
              sliver: SliverList(
                delegate: SliverChildListDelegate([
                  _buildWelcomeHeader(context),
                  const SizedBox(height: 18),
                  SearchBarWidget(
                    hintText: 'Search Google Books, Open Library & Gutendex...',
                    onChanged: (_) {},
                    onSubmitted: (query) {
                      bookProvider.setSourceMode(ExploreSourceMode.online);
                      bookProvider.setSelectedCategory(
                        'All',
                        triggerApi: false,
                      );
                      bookProvider.setSearchQuery(query);
                      widget.onNavigateTab(1);
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
                      onAction: () => widget.onNavigateTab(3),
                    ),
                    const SizedBox(height: 12),
                    _HorizontalBookShelf(
                      books: continueReading,
                      showProgress: true,
                      onBookTap: (book) => _openBookDetails(context, book),
                    ),
                  ],
                  const SizedBox(height: 30),
                  _SectionHeader(
                    title: 'Live Discovery (Google Books & Open Library)',
                    actionLabel: 'Search Online',
                    onAction: () {
                      bookProvider.setSourceMode(ExploreSourceMode.online);
                      widget.onNavigateTab(1);
                    },
                  ),
                  const SizedBox(height: 12),
                  _buildApiShelf(
                    context: context,
                    state: bookProvider.onlineState,
                    books: bookProvider.onlineBooks,
                    error: bookProvider.onlineError,
                    onRetry: () => bookProvider.fetchOnlineBooks(),
                  ),
                  const SizedBox(height: 30),
                  _SectionHeader(
                    title: 'Free Public-Domain Classics (Gutendex)',
                    actionLabel: 'Browse All',
                    onAction: () {
                      bookProvider.setSourceMode(ExploreSourceMode.publicDomain);
                      widget.onNavigateTab(1);
                    },
                  ),
                  const SizedBox(height: 12),
                  _buildApiShelf(
                    context: context,
                    state: bookProvider.publicDomainState,
                    books: bookProvider.publicDomainBooks,
                    error: bookProvider.publicDomainError,
                    onRetry: () => bookProvider.fetchPublicDomainBooks(),
                  ),
                  const SizedBox(height: 30),
                  _SectionHeader(
                    title: 'Browse Categories',
                    actionLabel: 'All Categories',
                    onAction: () => widget.onNavigateTab(2),
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
                            bookProvider.setSourceMode(ExploreSourceMode.online);
                            bookProvider.setSearchQuery('', triggerApi: false);
                            bookProvider.setSelectedCategory(cat.name);
                            widget.onNavigateTab(1);
                          },
                        );
                      },
                    ),
                  ),
                  const SizedBox(height: 30),
                  _SectionHeader(
                    title: 'Trending Sample Editions',
                    actionLabel: 'Offline Shelf',
                    onAction: () {
                      bookProvider
                          .setSourceMode(ExploreSourceMode.offlineCatalog);
                      widget.onNavigateTab(1);
                    },
                  ),
                  const SizedBox(height: 12),
                  _HorizontalBookShelf(
                    books: bookProvider.trendingBooks,
                    onBookTap: (book) => _openBookDetails(context, book),
                  ),
                  const SizedBox(height: 30),
                  _SectionHeader(
                    title: 'Popular Picks',
                    actionLabel: 'Offline Shelf',
                    onAction: () {
                      bookProvider
                          .setSourceMode(ExploreSourceMode.offlineCatalog);
                      widget.onNavigateTab(1);
                    },
                  ),
                  const SizedBox(height: 12),
                  _HorizontalBookShelf(
                    books: bookProvider.popularBooks,
                    onBookTap: (book) => _openBookDetails(context, book),
                  ),
                ]),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildApiShelf({
    required BuildContext context,
    required ApiLoadState state,
    required List<Book> books,
    required String? error,
    required VoidCallback onRetry,
  }) {
    if (state == ApiLoadState.loading || state == ApiLoadState.idle) {
      return const SizedBox(
        height: 140,
        child: Center(child: CircularProgressIndicator()),
      );
    }
    if (state == ApiLoadState.error && books.isEmpty) {
      return Card(
        child: Padding(
          padding: const EdgeInsets.all(20),
          child: Row(
            children: [
              const Icon(Icons.cloud_off_rounded, color: AppColors.accentAmber),
              const SizedBox(width: 14),
              Expanded(
                child: Text(
                  error ?? 'Could not load online books right now.',
                  style: AppTextStyles.body(context),
                ),
              ),
              const SizedBox(width: 12),
              OutlinedButton.icon(
                onPressed: onRetry,
                icon: const Icon(Icons.refresh_rounded, size: 18),
                label: const Text('Retry'),
              ),
            ],
          ),
        ),
      );
    }
    if (books.isEmpty) {
      return Card(
        child: Padding(
          padding: const EdgeInsets.all(20),
          child: Text(
            'No books returned for this section.',
            style: AppTextStyles.body(context),
          ),
        ),
      );
    }
    return _HorizontalBookShelf(
      books: books.take(10).toList(),
      onBookTap: (book) => _openBookDetails(context, book),
    );
  }

  Widget _buildWelcomeHeader(BuildContext context) {
    final theme = Theme.of(context);
    return Column(
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
            Expanded(
              child: Text(
                'BookNest Library',
                maxLines: 1,
                overflow: TextOverflow.ellipsis,
                style: AppTextStyles.caption(
                  context,
                  color: theme.colorScheme.secondary,
                ).copyWith(
                  fontWeight: FontWeight.w700,
                  letterSpacing: 0.6,
                ),
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
          'Explore live books from Google Books & Open Library, read free Project Gutenberg classics, or browse your offline shelf.',
          style: AppTextStyles.body(
            context,
            color: theme.colorScheme.onSurfaceVariant,
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
          child: Text(
            title,
            maxLines: 2,
            overflow: TextOverflow.ellipsis,
            style: AppTextStyles.sectionTitle(context),
          ),
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
