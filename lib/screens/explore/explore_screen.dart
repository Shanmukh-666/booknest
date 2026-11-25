import 'dart:async';
import 'package:material_ui/material_ui.dart';
import 'package:provider/provider.dart';
import '../../providers/book_provider.dart';
import '../../theme/app_colors.dart';
import '../../theme/app_text_styles.dart';
import '../../widgets/book_card.dart';
import '../../widgets/search_bar_widget.dart';
import '../book_details/book_details_screen.dart';

/// Screen 2: Explore Books with live API search, source switching, pagination, and offline fallback.
class ExploreScreen extends StatefulWidget {
  const ExploreScreen({super.key});

  @override
  State<ExploreScreen> createState() => _ExploreScreenState();
}

class _ExploreScreenState extends State<ExploreScreen> {
  Timer? _debounce;

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      if (mounted) {
        context.read<BookProvider>().ensureInitialOnlineLoad();
      }
    });
  }

  @override
  void dispose() {
    _debounce?.cancel();
    super.dispose();
  }

  void _onSearchChanged(BookProvider provider, String value) {
    if (provider.sourceMode == ExploreSourceMode.offlineCatalog) {
      provider.setSearchQuery(value, triggerApi: false);
      return;
    }
    _debounce?.cancel();
    provider.setSearchQuery(value, triggerApi: false);
    _debounce = Timer(const Duration(milliseconds: 500), () {
      if (mounted) {
        provider.setSearchQuery(value, triggerApi: true);
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    final provider = context.watch<BookProvider>();
    final books = provider.activeExploreBooks;
    final theme = Theme.of(context);
    final width = MediaQuery.sizeOf(context).width;
    final horizontalPad = width >= 900 ? 32.0 : 16.0;

    final categoryOptions = [
      'All',
      ...provider.categories.map((c) => c.name),
    ];

    int crossAxisCount = 2;
    if (width >= 1280) {
      crossAxisCount = 5;
    } else if (width >= 960) {
      crossAxisCount = 4;
    } else if (width >= 600) {
      crossAxisCount = 3;
    }

    final isLoading = (provider.sourceMode == ExploreSourceMode.online &&
            provider.onlineState == ApiLoadState.loading) ||
        (provider.sourceMode == ExploreSourceMode.publicDomain &&
            provider.publicDomainState == ApiLoadState.loading);

    final activeError = provider.sourceMode == ExploreSourceMode.online
        ? provider.onlineError
        : (provider.sourceMode == ExploreSourceMode.publicDomain
            ? provider.publicDomainError
            : null);

    final isErrorState = (provider.sourceMode == ExploreSourceMode.online &&
            provider.onlineState == ApiLoadState.error) ||
        (provider.sourceMode == ExploreSourceMode.publicDomain &&
            provider.publicDomainState == ApiLoadState.error);

    final canLoadMore = (provider.sourceMode == ExploreSourceMode.online &&
            provider.hasMoreOnline) ||
        (provider.sourceMode == ExploreSourceMode.publicDomain &&
            provider.hasMorePublicDomain);

    final isLoadingMore = (provider.sourceMode == ExploreSourceMode.online &&
            provider.isLoadingMoreOnline) ||
        (provider.sourceMode == ExploreSourceMode.publicDomain &&
            provider.isLoadingMorePublicDomain);

    return Align(
      alignment: Alignment.topCenter,
      child: ConstrainedBox(
        constraints: const BoxConstraints(maxWidth: 1320),
        child: CustomScrollView(
          slivers: [
            SliverPadding(
              padding: EdgeInsets.fromLTRB(horizontalPad, 20, horizontalPad, 12),
              sliver: SliverList(
                delegate: SliverChildListDelegate([
                  Text(
                    'Explore Catalog',
                    style: AppTextStyles.displayTitle(context)
                        .copyWith(fontSize: 28),
                  ),
                  const SizedBox(height: 4),
                  Text(
                    'Search Google Books, Open Library, Project Gutenberg, or your offline sample shelf.',
                    style: AppTextStyles.body(
                      context,
                      color: theme.colorScheme.onSurfaceVariant,
                    ),
                  ),
                  const SizedBox(height: 16),
                  Wrap(
                    spacing: 8,
                    runSpacing: 8,
                    children: ExploreSourceMode.values.map((mode) {
                      final selected = provider.sourceMode == mode;
                      return ChoiceChip(
                        label: Text(mode.label),
                        selected: selected,
                        labelStyle: TextStyle(
                          color: selected
                              ? theme.colorScheme.onPrimary
                              : theme.colorScheme.onSurface,
                          fontWeight:
                              selected ? FontWeight.w700 : FontWeight.w500,
                        ),
                        onSelected: (_) => provider.setSourceMode(mode),
                      );
                    }).toList(),
                  ),
                  const SizedBox(height: 14),
                  LayoutBuilder(
                    builder: (context, constraints) {
                      final isWideControls = constraints.maxWidth >= 680;
                      final searchField = SearchBarWidget(
                        initialValue: provider.searchQuery,
                        hintText: provider.sourceMode ==
                                ExploreSourceMode.publicDomain
                            ? 'Search public-domain books (Gutendex)...'
                            : 'Search by title, author, or topic...',
                        onChanged: (val) => _onSearchChanged(provider, val),
                        onSubmitted: (val) =>
                            provider.setSearchQuery(val, triggerApi: true),
                      );
                      final sortDropdown = DropdownButtonHideUnderline(
                        child: Container(
                          padding: const EdgeInsets.symmetric(
                            horizontal: 14,
                            vertical: 4,
                          ),
                          decoration: BoxDecoration(
                            color: theme.colorScheme.surface,
                            borderRadius: BorderRadius.circular(14),
                            border: Border.all(color: theme.colorScheme.outline),
                          ),
                          child: DropdownButton<BookSortOption>(
                            value: provider.sortOption,
                            icon: const Icon(Icons.sort_rounded),
                            borderRadius: BorderRadius.circular(12),
                            items: BookSortOption.values
                                .map(
                                  (opt) => DropdownMenuItem(
                                    value: opt,
                                    child: Text('Sort: ${opt.label}'),
                                  ),
                                )
                                .toList(),
                            onChanged: (val) {
                              if (val != null) provider.setSortOption(val);
                            },
                          ),
                        ),
                      );

                      if (isWideControls) {
                        return Row(
                          children: [
                            Expanded(child: searchField),
                            const SizedBox(width: 12),
                            sortDropdown,
                          ],
                        );
                      }
                      return Column(
                        crossAxisAlignment: CrossAxisAlignment.stretch,
                        children: [
                          searchField,
                          const SizedBox(height: 10),
                          Align(
                            alignment: Alignment.centerLeft,
                            child: sortDropdown,
                          ),
                        ],
                      );
                    },
                  ),
                  if (provider.sourceMode !=
                      ExploreSourceMode.publicDomain) ...[
                    const SizedBox(height: 14),
                    SizedBox(
                      height: 42,
                      child: ListView.separated(
                        scrollDirection: Axis.horizontal,
                        itemCount: categoryOptions.length,
                        separatorBuilder: (_, _) => const SizedBox(width: 8),
                        itemBuilder: (context, index) {
                          final cat = categoryOptions[index];
                          final selected = provider.selectedCategory == cat;
                          return ChoiceChip(
                            label: Text(cat),
                            selected: selected,
                            labelStyle: TextStyle(
                              color: selected
                                  ? theme.colorScheme.onPrimary
                                  : theme.colorScheme.onSurface,
                              fontWeight:
                                  selected ? FontWeight.w700 : FontWeight.w500,
                            ),
                            onSelected: (_) =>
                                provider.setSelectedCategory(cat),
                          );
                        },
                      ),
                    ),
                  ],
                  if (activeError != null && books.isNotEmpty) ...[
                    const SizedBox(height: 12),
                    Container(
                      padding: const EdgeInsets.symmetric(
                        horizontal: 12,
                        vertical: 8,
                      ),
                      decoration: BoxDecoration(
                        color: AppColors.accentAmber.withValues(alpha: 0.12),
                        borderRadius: BorderRadius.circular(10),
                      ),
                      child: Row(
                        children: [
                          const Icon(
                            Icons.info_outline_rounded,
                            size: 18,
                            color: AppColors.accentAmber,
                          ),
                          const SizedBox(width: 8),
                          Expanded(
                            child: Text(
                              activeError,
                              style: AppTextStyles.caption(context),
                            ),
                          ),
                        ],
                      ),
                    ),
                  ],
                  const SizedBox(height: 14),
                  Text(
                    'Showing ${books.length} ${books.length == 1 ? 'book' : 'books'} (${provider.sourceMode.label})',
                    style: AppTextStyles.caption(context),
                  ),
                ]),
              ),
            ),
            if (isLoading)
              const SliverFillRemaining(
                hasScrollBody: false,
                child: Center(child: CircularProgressIndicator()),
              )
            else if (isErrorState && books.isEmpty)
              SliverFillRemaining(
                hasScrollBody: false,
                child: Center(
                  child: Padding(
                    padding: const EdgeInsets.all(32),
                    child: Column(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        const Icon(
                          Icons.cloud_off_rounded,
                          size: 52,
                          color: AppColors.accentAmber,
                        ),
                        const SizedBox(height: 14),
                        Text(
                          'Unable to reach external book APIs',
                          textAlign: TextAlign.center,
                          style: AppTextStyles.sectionTitle(context),
                        ),
                        const SizedBox(height: 6),
                        Text(
                          activeError ??
                              'Please check your connection or switch to the offline shelf.',
                          textAlign: TextAlign.center,
                          style: AppTextStyles.body(
                            context,
                            color: theme.colorScheme.onSurfaceVariant,
                          ),
                        ),
                        const SizedBox(height: 18),
                        Wrap(
                          spacing: 12,
                          runSpacing: 10,
                          alignment: WrapAlignment.center,
                          children: [
                            FilledButton.icon(
                              onPressed: () {
                                if (provider.sourceMode ==
                                    ExploreSourceMode.publicDomain) {
                                  provider.fetchPublicDomainBooks();
                                } else {
                                  provider.fetchOnlineBooks();
                                }
                              },
                              icon: const Icon(Icons.refresh_rounded),
                              label: const Text('Retry'),
                            ),
                            OutlinedButton.icon(
                              onPressed: () => provider.setSourceMode(
                                ExploreSourceMode.offlineCatalog,
                              ),
                              icon: const Icon(Icons.offline_pin_rounded),
                              label: const Text('Use Offline Shelf'),
                            ),
                          ],
                        ),
                      ],
                    ),
                  ),
                ),
              )
            else if (books.isEmpty)
              SliverFillRemaining(
                hasScrollBody: false,
                child: Center(
                  child: Padding(
                    padding: const EdgeInsets.all(32),
                    child: Column(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        Icon(
                          Icons.menu_book_outlined,
                          size: 56,
                          color: theme.colorScheme.onSurfaceVariant,
                        ),
                        const SizedBox(height: 14),
                        Text(
                          'No matching books found',
                          style: AppTextStyles.sectionTitle(context),
                        ),
                        const SizedBox(height: 6),
                        Text(
                          'Try clearing your search or selecting a different category.',
                          textAlign: TextAlign.center,
                          style: AppTextStyles.body(
                            context,
                            color: theme.colorScheme.onSurfaceVariant,
                          ),
                        ),
                        const SizedBox(height: 18),
                        FilledButton.icon(
                          onPressed: provider.resetFilters,
                          icon: const Icon(Icons.refresh_rounded),
                          label: const Text('Reset Filters'),
                        ),
                      ],
                    ),
                  ),
                ),
              )
            else ...[
              SliverPadding(
                padding: EdgeInsets.fromLTRB(horizontalPad, 8, horizontalPad, 16),
                sliver: SliverGrid(
                  gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                    crossAxisCount: crossAxisCount,
                    mainAxisSpacing: 14,
                    crossAxisSpacing: 14,
                    mainAxisExtent: 312,
                  ),
                  delegate: SliverChildBuilderDelegate(
                    (context, index) {
                      final book = books[index];
                      return BookCard(
                        book: book,
                        onTap: () {
                          Navigator.of(context).push(
                            MaterialPageRoute(
                              builder: (_) => BookDetailsScreen(book: book),
                            ),
                          );
                        },
                      );
                    },
                    childCount: books.length,
                  ),
                ),
              ),
              if (canLoadMore)
                SliverToBoxAdapter(
                  child: Padding(
                    padding: const EdgeInsets.fromLTRB(16, 8, 16, 32),
                    child: Center(
                      child: isLoadingMore
                          ? const CircularProgressIndicator()
                          : OutlinedButton.icon(
                              onPressed: () {
                                if (provider.sourceMode ==
                                    ExploreSourceMode.publicDomain) {
                                  provider.fetchPublicDomainBooks(
                                    loadMore: true,
                                  );
                                } else {
                                  provider.fetchOnlineBooks(loadMore: true);
                                }
                              },
                              icon: const Icon(Icons.expand_more_rounded),
                              label: const Text('Load More Books'),
                            ),
                    ),
                  ),
                ),
            ],
          ],
        ),
      ),
    );
  }
}
