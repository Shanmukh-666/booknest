import 'package:material_ui/material_ui.dart';
import '../models/book.dart';
import '../theme/app_colors.dart';
import '../theme/app_text_styles.dart';
import 'book_cover.dart';

/// Editorial hero showcase for the featured book on the Home screen.
class FeaturedBookBanner extends StatelessWidget {
  final Book book;
  final VoidCallback onReadNow;
  final VoidCallback onViewDetails;

  const FeaturedBookBanner({
    super.key,
    required this.book,
    required this.onReadNow,
    required this.onViewDetails,
  });

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final isDark = theme.brightness == Brightness.dark;
    final isWide = MediaQuery.sizeOf(context).width >= 720;

    return Container(
      padding: EdgeInsets.all(isWide ? 28 : 20),
      decoration: BoxDecoration(
        color: isDark ? AppColors.darkSurface : AppColors.primaryNavy,
        borderRadius: BorderRadius.circular(22),
        border: Border.all(
          color: isDark ? AppColors.darkBorder : AppColors.primaryNavyLight,
        ),
      ),
      child: isWide
          ? Row(
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                BookCover(
                  book: book,
                  width: 158,
                  height: 230,
                  borderRadius: 12,
                ),
                const SizedBox(width: 28),
                Expanded(child: _buildTextContent(context)),
              ],
            )
          : Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Center(
                  child: BookCover(
                    book: book,
                    width: 145,
                    height: 210,
                    borderRadius: 12,
                  ),
                ),
                const SizedBox(height: 20),
                _buildTextContent(context),
              ],
            ),
    );
  }

  Widget _buildTextContent(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Container(
          padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
          decoration: BoxDecoration(
            color: AppColors.accentAmber.withValues(alpha: 0.22),
            borderRadius: BorderRadius.circular(20),
            border: Border.all(
              color: AppColors.accentAmber.withValues(alpha: 0.6),
            ),
          ),
          child: Text(
            'FEATURED PICK • ${book.category.toUpperCase()}',
            style: const TextStyle(
              color: Color(0xFFFAD7A0),
              fontSize: 11,
              fontWeight: FontWeight.w700,
              letterSpacing: 0.8,
            ),
          ),
        ),
        const SizedBox(height: 14),
        Text(
          book.title,
          style: AppTextStyles.displayTitle(
            context,
            color: Colors.white,
          ).copyWith(fontSize: 26),
        ),
        const SizedBox(height: 6),
        Text(
          'by ${book.author}  •  ${book.publicationYear}  •  ★ ${book.rating}',
          style: TextStyle(
            color: Colors.white.withValues(alpha: 0.78),
            fontSize: 13.5,
            fontWeight: FontWeight.w500,
          ),
        ),
        const SizedBox(height: 12),
        Text(
          book.description,
          maxLines: 3,
          overflow: TextOverflow.ellipsis,
          style: TextStyle(
            color: Colors.white.withValues(alpha: 0.88),
            fontSize: 14.5,
            height: 1.55,
          ),
        ),
        const SizedBox(height: 20),
        Wrap(
          spacing: 12,
          runSpacing: 10,
          children: [
            FilledButton.icon(
              onPressed: onReadNow,
              style: FilledButton.styleFrom(
                backgroundColor: AppColors.accentAmber,
                foregroundColor: Colors.white,
                padding:
                    const EdgeInsets.symmetric(horizontal: 20, vertical: 14),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(12),
                ),
              ),
              icon: const Icon(Icons.menu_book_rounded, size: 18),
              label: const Text(
                'Read Now',
                style: TextStyle(fontWeight: FontWeight.w700),
              ),
            ),
            OutlinedButton.icon(
              onPressed: onViewDetails,
              style: OutlinedButton.styleFrom(
                foregroundColor: Colors.white,
                side: BorderSide(color: Colors.white.withValues(alpha: 0.35)),
                padding:
                    const EdgeInsets.symmetric(horizontal: 18, vertical: 14),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(12),
                ),
              ),
              icon: const Icon(Icons.info_outline_rounded, size: 18),
              label: const Text('Book Details'),
            ),
          ],
        ),
      ],
    );
  }
}
