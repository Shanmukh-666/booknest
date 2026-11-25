import 'package:material_ui/material_ui.dart';
import 'package:provider/provider.dart';
import '../../providers/book_provider.dart';
import '../../theme/app_text_styles.dart';
import '../../widgets/book_card.dart';
import '../../widgets/search_bar_widget.dart';
import '../book_details/book_details_screen.dart';

/// Screen 2: Explore Books with search, category filter, and sorting.
class ExploreScreen extends StatelessWidget {
  const ExploreScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final provider = context.watch<BookProvider>();
    final books = provider.filteredBooks;
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
    } else if (width >= 640) {
      crossAxisCount = 3;
    }

    return CustomScrollView(
      slivers: [
        SliverPadding(
          padding: EdgeInsets.fromLTRB(horizontalPad, 20, horizontalPad, 12),
          sliver: SliverList(
            delegate: SliverChildListDelegate([
              Text(
                'Explore Catalog',
                style: AppTextStyles.displayTitle(context).copyWith(fontSize: 28),
              ),
              const SizedBox(height: 4),
              Text(
                'Browse ${provider.allBooks.length} curated digital titles across ${provider.categories.length} genres.',
                style: AppTextStyles.body(
                  context,
                  color: theme.colorScheme.onSurfaceVariant,
                ),
              ),
              const SizedBox(height: 16),
              Wrap(
                spacing: 12,
                runSpacing: 12,
                crossAxisAlignment: WrapCrossAlignment.center,
                children: [
                  SizedBox(
                    width: width >= 720 ? 420 : double.infinity,
                    child: SearchBarWidget(
                      initialValue: provider.searchQuery,
                      onChanged: provider.setSearchQuery,
                    ),
                  ),
                  DropdownButtonHideUnderline(
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
                  ),
                ],
              ),
              const SizedBox(height: 16),
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
                      onSelected: (_) => provider.setSelectedCategory(cat),
                    );
                  },
                ),
              ),
              const SizedBox(height: 14),
              Text(
                'Showing ${books.length} ${books.length == 1 ? 'book' : 'books'}',
                style: AppTextStyles.caption(context),
              ),
            ]),
          ),
        ),
        if (books.isEmpty)
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
        else
          SliverPadding(
            padding: EdgeInsets.fromLTRB(horizontalPad, 8, horizontalPad, 28),
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
      ],
    );
  }
}
