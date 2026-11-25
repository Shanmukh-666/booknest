import 'package:material_ui/material_ui.dart';
import '../models/category.dart';
import '../theme/app_text_styles.dart';

/// Category tile with custom icon, accent badge, and book count.
class CategoryCard extends StatelessWidget {
  final BookCategory category;
  final int bookCount;
  final VoidCallback onTap;

  const CategoryCard({
    super.key,
    required this.category,
    required this.bookCount,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    return Card(
      clipBehavior: Clip.antiAlias,
      child: InkWell(
        onTap: onTap,
        child: Padding(
          padding: const EdgeInsets.all(16),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                children: [
                  Container(
                    width: 42,
                    height: 42,
                    decoration: BoxDecoration(
                      color: category.color.withValues(alpha: 0.14),
                      borderRadius: BorderRadius.circular(12),
                    ),
                    child: Icon(
                      category.icon,
                      color: theme.brightness == Brightness.dark
                          ? category.accentColor
                          : category.color,
                      size: 22,
                    ),
                  ),
                  const Spacer(),
                  Container(
                    padding:
                        const EdgeInsets.symmetric(horizontal: 9, vertical: 4),
                    decoration: BoxDecoration(
                      color: theme.colorScheme.surfaceContainerHighest,
                      borderRadius: BorderRadius.circular(12),
                    ),
                    child: Text(
                      '$bookCount ${bookCount == 1 ? 'book' : 'books'}',
                      style: AppTextStyles.caption(context).copyWith(
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 14),
              Text(
                category.name,
                maxLines: 1,
                overflow: TextOverflow.ellipsis,
                style: AppTextStyles.bookTitle(context, fontSize: 16),
              ),
              const SizedBox(height: 6),
              Text(
                category.description,
                maxLines: 2,
                overflow: TextOverflow.ellipsis,
                style: AppTextStyles.caption(context),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
