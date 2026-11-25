import 'package:material_ui/material_ui.dart';
import 'package:google_fonts/google_fonts.dart';
import '../models/book.dart';

/// Renders an editorial, print-inspired book cover with optional asset fallback.
class BookCover extends StatelessWidget {
  final Book book;
  final double width;
  final double height;
  final double borderRadius;
  final bool showDetails;

  const BookCover({
    super.key,
    required this.book,
    this.width = 140,
    this.height = 205,
    this.borderRadius = 10,
    this.showDetails = true,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      width: width,
      height: height,
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(borderRadius),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withValues(alpha: 0.16),
            blurRadius: 14,
            offset: const Offset(0, 6),
          ),
        ],
      ),
      child: ClipRRect(
        borderRadius: BorderRadius.circular(borderRadius),
        child: book.coverAssetPath != null
            ? Image.asset(
                book.coverAssetPath!,
                fit: BoxFit.cover,
                errorBuilder: (context, error, stackTrace) =>
                    _buildGeneratedCover(),
              )
            : _buildGeneratedCover(),
      ),
    );
  }

  Widget _buildGeneratedCover() {
    final compact = width < 100;
    return Container(
      color: book.coverColor,
      child: Stack(
        fit: StackFit.expand,
        children: [
          CustomPaint(
            painter: _CoverPatternPainter(
              pattern: book.coverPattern,
              accentColor: book.coverAccentColor,
            ),
          ),
          // Subtle left spine crease
          Positioned(
            left: 0,
            top: 0,
            bottom: 0,
            width: compact ? 6 : 10,
            child: DecoratedBox(
              decoration: BoxDecoration(
                gradient: LinearGradient(
                  colors: [
                    Colors.black.withValues(alpha: 0.35),
                    Colors.white.withValues(alpha: 0.10),
                    Colors.transparent,
                  ],
                ),
              ),
            ),
          ),
          if (showDetails)
            Padding(
              padding: EdgeInsets.fromLTRB(
                compact ? 10 : 14,
                compact ? 10 : 14,
                compact ? 8 : 12,
                compact ? 10 : 14,
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Container(
                    padding: EdgeInsets.symmetric(
                      horizontal: compact ? 5 : 7,
                      vertical: compact ? 2 : 3,
                    ),
                    decoration: BoxDecoration(
                      color: book.coverAccentColor.withValues(alpha: 0.22),
                      borderRadius: BorderRadius.circular(4),
                      border: Border.all(
                        color: book.coverAccentColor.withValues(alpha: 0.55),
                        width: 0.7,
                      ),
                    ),
                    child: Text(
                      book.category.toUpperCase(),
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                      style: GoogleFonts.plusJakartaSans(
                        color: Colors.white.withValues(alpha: 0.92),
                        fontSize: compact ? 6.5 : 8.5,
                        fontWeight: FontWeight.w700,
                        letterSpacing: 0.8,
                      ),
                    ),
                  ),
                  const Spacer(),
                  Text(
                    book.title,
                    maxLines: 3,
                    overflow: TextOverflow.ellipsis,
                    style: GoogleFonts.playfairDisplay(
                      color: Colors.white,
                      fontSize: compact ? 11 : (width > 160 ? 17 : 13.5),
                      fontWeight: FontWeight.w700,
                      height: 1.18,
                    ),
                  ),
                  SizedBox(height: compact ? 4 : 6),
                  Container(
                    width: compact ? 18 : 26,
                    height: 2,
                    color: book.coverAccentColor,
                  ),
                  SizedBox(height: compact ? 4 : 6),
                  Text(
                    book.author,
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                    style: GoogleFonts.plusJakartaSans(
                      color: Colors.white.withValues(alpha: 0.80),
                      fontSize: compact ? 8 : (width > 160 ? 11.5 : 9.5),
                      fontWeight: FontWeight.w500,
                    ),
                  ),
                ],
              ),
            ),
        ],
      ),
    );
  }
}

class _CoverPatternPainter extends CustomPainter {
  final CoverPattern pattern;
  final Color accentColor;

  const _CoverPatternPainter({
    required this.pattern,
    required this.accentColor,
  });

  @override
  void paint(Canvas canvas, Size size) {
    final paint = Paint()
      ..color = accentColor.withValues(alpha: 0.16)
      ..style = PaintingStyle.stroke
      ..strokeWidth = 1.2;

    final fillPaint = Paint()
      ..color = accentColor.withValues(alpha: 0.12)
      ..style = PaintingStyle.fill;

    switch (pattern) {
      case CoverPattern.editorialGrid:
        for (double x = size.width * 0.25; x < size.width; x += size.width * 0.25) {
          canvas.drawLine(Offset(x, 0), Offset(x, size.height), paint);
        }
        for (double y = size.height * 0.25; y < size.height; y += size.height * 0.25) {
          canvas.drawLine(Offset(0, y), Offset(size.width, y), paint);
        }
        canvas.drawCircle(
          Offset(size.width * 0.78, size.height * 0.24),
          size.width * 0.14,
          fillPaint,
        );
      case CoverPattern.horizonBand:
        canvas.drawRect(
          Rect.fromLTWH(0, size.height * 0.34, size.width, size.height * 0.14),
          fillPaint,
        );
        canvas.drawCircle(
          Offset(size.width * 0.72, size.height * 0.26),
          size.width * 0.16,
          fillPaint,
        );
      case CoverPattern.orbitalRings:
        final center = Offset(size.width * 0.75, size.height * 0.28);
        canvas.drawCircle(center, size.width * 0.22, paint);
        canvas.drawCircle(center, size.width * 0.36, paint);
        canvas.drawCircle(center, size.width * 0.08, fillPaint);
      case CoverPattern.archway:
        final rect = Rect.fromLTWH(
          size.width * 0.18,
          size.height * 0.14,
          size.width * 0.64,
          size.height * 0.72,
        );
        canvas.drawRRect(
          RRect.fromRectAndCorners(
            rect,
            topLeft: Radius.circular(size.width * 0.32),
            topRight: Radius.circular(size.width * 0.32),
          ),
          paint,
        );
      case CoverPattern.diagonalSplit:
        final path = Path()
          ..moveTo(0, size.height * 0.48)
          ..lineTo(size.width, size.height * 0.18)
          ..lineTo(size.width, 0)
          ..lineTo(0, 0)
          ..close();
        canvas.drawPath(path, fillPaint);
      case CoverPattern.minimalFrame:
        final inset = size.width * 0.08;
        canvas.drawRect(
          Rect.fromLTWH(
            inset,
            inset,
            size.width - inset * 2,
            size.height - inset * 2,
          ),
          paint,
        );
    }
  }

  @override
  bool shouldRepaint(covariant _CoverPatternPainter oldDelegate) =>
      oldDelegate.pattern != pattern || oldDelegate.accentColor != accentColor;
}
