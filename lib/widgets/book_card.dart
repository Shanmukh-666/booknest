import 'package:material_ui/material_ui.dart';
import 'package:provider/provider.dart';
import '../models/book.dart';
import '../providers/reading_provider.dart';
import '../theme/app_colors.dart';
import '../theme/app_text_styles.dart';
import 'book_cover.dart';

/// Reusable book card with subtle hover animation and quick library badges.
class BookCard extends StatefulWidget {
  final Book book;
  final VoidCallback onTap;
  final double? width;
  final bool showProgress;

  const BookCard({
    super.key,
    required this.book,
    required this.onTap,
    this.width,
    this.showProgress = false,
  });

  @override
  State<BookCard> createState() => _BookCardState();
}

class _BookCardState extends State<BookCard> {
  bool _hovered = false;

  @override
  Widget build(BuildContext context) {
    final reading = context.watch<ReadingProvider>();
    final isFav = reading.isFavourite(widget.book.id);
    final isBookmarked = reading.isBookmarked(widget.book.id);
    final progress = reading.progressFor(widget.book.id);
    final theme = Theme.of(context);

    return MouseRegion(
      onEnter: (_) => setState(() => _hovered = true),
      onExit: (_) => setState(() => _hovered = false),
      child: AnimatedScale(
        scale: _hovered ? 1.02 : 1.0,
        duration: const Duration(milliseconds: 180),
        curve: Curves.easeOutCubic,
        child: SizedBox(
          width: widget.width,
          child: Card(
            clipBehavior: Clip.antiAlias,
            child: InkWell(
              onTap: widget.onTap,
              child: Padding(
                padding: const EdgeInsets.all(12),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Center(
                      child: Stack(
                        children: [
                          BookCover(
                            book: widget.book,
                            width: 122,
                            height: 172,
                            borderRadius: 10,
                          ),
                          if (isFav || isBookmarked)
                            Positioned(
                              top: 6,
                              right: 6,
                              child: Container(
                                padding: const EdgeInsets.all(5),
                                decoration: BoxDecoration(
                                  color: Colors.black.withValues(alpha: 0.62),
                                  borderRadius: BorderRadius.circular(8),
                                ),
                                child: Row(
                                  mainAxisSize: MainAxisSize.min,
                                  children: [
                                    if (isFav)
                                      const Icon(
                                        Icons.favorite_rounded,
                                        color: Color(0xFFFF6B6B),
                                        size: 13,
                                      ),
                                    if (isFav && isBookmarked)
                                      const SizedBox(width: 4),
                                    if (isBookmarked)
                                      const Icon(
                                        Icons.bookmark_rounded,
                                        color: AppColors.accentAmberLight,
                                        size: 13,
                                      ),
                                  ],
                                ),
                              ),
                            ),
                        ],
                      ),
                    ),
                    const SizedBox(height: 12),
                    Text(
                      widget.book.title,
                      maxLines: 2,
                      overflow: TextOverflow.ellipsis,
                      style: AppTextStyles.bookTitle(context, fontSize: 14.5),
                    ),
                    const SizedBox(height: 4),
                    Text(
                      widget.book.author,
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                      style: AppTextStyles.caption(context),
                    ),
                    const Spacer(),
                    const SizedBox(height: 8),
                    Row(
                      children: [
                        const Icon(
                          Icons.star_rounded,
                          size: 16,
                          color: AppColors.ratingStar,
                        ),
                        const SizedBox(width: 4),
                        Text(
                          widget.book.rating.toStringAsFixed(1),
                          style: AppTextStyles.caption(
                            context,
                            color: theme.colorScheme.onSurface,
                          ).copyWith(fontWeight: FontWeight.w700),
                        ),
                        const Spacer(),
                        Container(
                          padding: const EdgeInsets.symmetric(
                            horizontal: 7,
                            vertical: 2,
                          ),
                          decoration: BoxDecoration(
                            color: theme.colorScheme.surfaceContainerHighest,
                            borderRadius: BorderRadius.circular(6),
                          ),
                          child: Text(
                            widget.book.pageCount > 0
                                ? '${widget.book.pageCount}p'
                                : widget.book.source.label,
                            maxLines: 1,
                            overflow: TextOverflow.ellipsis,
                            style: AppTextStyles.caption(context).copyWith(
                              fontSize: 10.5,
                            ),
                          ),
                        ),
                      ],
                    ),
                    if (widget.showProgress && progress != null) ...[
                      const SizedBox(height: 8),
                      ClipRRect(
                        borderRadius: BorderRadius.circular(4),
                        child: LinearProgressIndicator(
                          value: progress.progressFraction.clamp(0.05, 1.0),
                          minHeight: 4,
                          backgroundColor:
                              theme.colorScheme.surfaceContainerHighest,
                        ),
                      ),
                    ],
                  ],
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }
}
