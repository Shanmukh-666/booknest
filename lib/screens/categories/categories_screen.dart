import 'package:material_ui/material_ui.dart';
import 'package:provider/provider.dart';
import '../../providers/book_provider.dart';
import '../../theme/app_text_styles.dart';
import '../../widgets/book_card.dart';
import '../../widgets/category_card.dart';
import '../book_details/book_details_screen.dart';

/// Screen 6: Browse Categories and view books within a selected category.
class CategoriesScreen extends StatefulWidget {
  const CategoriesScreen({super.key});

  @override
  State<CategoriesScreen> createState() => _CategoriesScreenState();
}

class _CategoriesScreenState extends State<CategoriesScreen> {
  String? _activeCategory;

  @override
  Widget build(BuildContext context) {
    final bookProvider = context.watch<BookProvider>();
    final theme = Theme.of(context);
    final width = MediaQuery.sizeOf(context).width;
    final horizontalPad = width >= 900 ? 32.0 : 16.0;

    if (_activeCategory != null) {
      final books = bookProvider.booksByCategory(_activeCategory!);
      int crossAxisCount = 2;
      if (width >= 1280) {
        crossAxisCount = 5;
      } else if (width >= 960) {
        crossAxisCount = 4;
      } else if (width >= 640) {
        crossAxisCount = 3;
      }

      return Align(
        alignment: Alignment.topCenter,
        child: ConstrainedBox(
          constraints: const BoxConstraints(maxWidth: 1320),
          child: CustomScrollView(
        slivers: [
          SliverPadding(
            padding: EdgeInsets.fromLTRB(horizontalPad, 20, horizontalPad, 16),
            sliver: SliverList(
              delegate: SliverChildListDelegate([
                Align(
                  alignment: Alignment.centerLeft,
                  child: TextButton.icon(
                    onPressed: () => setState(() => _activeCategory = null),
                    icon: const Icon(Icons.arrow_back_rounded, size: 18),
                    label: const Text('All Categories'),
                  ),
                ),
                const SizedBox(height: 8),
                Text(
                  _activeCategory!,
                  style: AppTextStyles.displayTitle(context)
                      .copyWith(fontSize: 28),
                ),
                const SizedBox(height: 4),
                Text(
                  '${books.length} ${books.length == 1 ? 'book' : 'books'} in this collection',
                  style: AppTextStyles.body(
                    context,
                    color: theme.colorScheme.onSurfaceVariant,
                  ),
                ),
              ]),
            ),
          ),
          SliverPadding(
            padding: EdgeInsets.fromLTRB(horizontalPad, 4, horizontalPad, 28),
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
      ),
      ),
      );
    }

    int catColumns = 1;
    if (width >= 1150) {
      catColumns = 3;
    } else if (width >= 640) {
      catColumns = 2;
    }

    return Align(
      alignment: Alignment.topCenter,
      child: ConstrainedBox(
        constraints: const BoxConstraints(maxWidth: 1320),
        child: CustomScrollView(
      slivers: [
        SliverPadding(
          padding: EdgeInsets.fromLTRB(horizontalPad, 20, horizontalPad, 16),
          sliver: SliverList(
            delegate: SliverChildListDelegate([
              Text(
                'Categories',
                style:
                    AppTextStyles.displayTitle(context).copyWith(fontSize: 28),
              ),
              const SizedBox(height: 4),
              Text(
                'Explore ${bookProvider.categories.length} curated shelves across fiction, technology, science, and craft.',
                style: AppTextStyles.body(
                  context,
                  color: theme.colorScheme.onSurfaceVariant,
                ),
              ),
            ]),
          ),
        ),
        SliverPadding(
          padding: EdgeInsets.fromLTRB(horizontalPad, 4, horizontalPad, 28),
          sliver: SliverGrid(
            gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
              crossAxisCount: catColumns,
              mainAxisSpacing: 14,
              crossAxisSpacing: 14,
              mainAxisExtent: 162,
            ),
            delegate: SliverChildBuilderDelegate(
              (context, index) {
                final category = bookProvider.categories[index];
                final count = bookProvider.bookCountForCategory(category.name);
                return CategoryCard(
                  category: category,
                  bookCount: count,
                  onTap: () => setState(() => _activeCategory = category.name),
                );
              },
              childCount: bookProvider.categories.length,
            ),
          ),
        ),
      ],
    ),
    ),
    );
  }
}
