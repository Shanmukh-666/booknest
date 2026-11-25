import 'package:material_ui/material_ui.dart';
import 'package:provider/provider.dart';
import '../../models/book.dart';
import '../../providers/reading_provider.dart';
import '../../providers/theme_provider.dart';
import '../../theme/app_colors.dart';
import '../../theme/app_text_styles.dart';

/// Screen 4: Distraction-free Sample Book Reader.
class ReaderScreen extends StatefulWidget {
  final Book book;
  final int initialChapterIndex;

  const ReaderScreen({
    super.key,
    required this.book,
    this.initialChapterIndex = 0,
  });

  @override
  State<ReaderScreen> createState() => _ReaderScreenState();
}

class _ReaderScreenState extends State<ReaderScreen> {
  late int _chapterIndex;
  final ScrollController _scrollController = ScrollController();

  @override
  void initState() {
    super.initState();
    final maxIndex = (widget.book.chapters.length - 1).clamp(0, 999);
    _chapterIndex = widget.initialChapterIndex.clamp(0, maxIndex);
    WidgetsBinding.instance.addPostFrameCallback((_) {
      _saveProgress();
    });
  }

  @override
  void dispose() {
    _scrollController.dispose();
    super.dispose();
  }

  void _saveProgress({bool? markCompleted}) {
    if (!mounted) return;
    context.read<ReadingProvider>().updateProgress(
          bookId: widget.book.id,
          chapterIndex: _chapterIndex,
          totalChapters: widget.book.chapters.length,
          markCompleted: markCompleted,
        );
  }

  void _goToChapter(int index) {
    setState(() => _chapterIndex = index);
    _saveProgress();
    if (_scrollController.hasClients) {
      _scrollController.animateTo(
        0,
        duration: const Duration(milliseconds: 260),
        curve: Curves.easeOut,
      );
    }
  }

  void _showReaderSettings(BuildContext context) {
    showModalBottomSheet<void>(
      context: context,
      showDragHandle: true,
      builder: (ctx) {
        return Consumer<ThemeProvider>(
          builder: (context, themeProvider, _) {
            return Padding(
              padding: const EdgeInsets.fromLTRB(24, 8, 24, 28),
              child: Column(
                mainAxisSize: MainAxisSize.min,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    'Reading Preferences',
                    style: AppTextStyles.sectionTitle(context),
                  ),
                  const SizedBox(height: 18),
                  Row(
                    children: [
                      const Text('Font Size'),
                      const Spacer(),
                      Text(
                        '${themeProvider.readerFontSize.round()} pt',
                        style: const TextStyle(fontWeight: FontWeight.w700),
                      ),
                    ],
                  ),
                  Slider(
                    min: 14,
                    max: 26,
                    divisions: 6,
                    value: themeProvider.readerFontSize,
                    onChanged: themeProvider.setReaderFontSize,
                  ),
                  const SizedBox(height: 8),
                  SwitchListTile(
                    contentPadding: EdgeInsets.zero,
                    title: const Text('Dark Reading Theme'),
                    subtitle: const Text(
                      'Low-glare background for evening reading',
                    ),
                    value: themeProvider.isReaderDark,
                    onChanged: themeProvider.setReaderDark,
                  ),
                ],
              ),
            );
          },
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    final themeProvider = context.watch<ThemeProvider>();
    final readingProvider = context.watch<ReadingProvider>();
    final chapters = widget.book.chapters;
    final chapter = chapters[_chapterIndex];
    final isReaderDark = themeProvider.isReaderDark;
    final progress = (_chapterIndex + 1) / chapters.length;
    final isCompleted =
        readingProvider.progressFor(widget.book.id)?.isCompleted ?? false;

    final bgColor =
        isReaderDark ? const Color(0xFF12161E) : const Color(0xFFFBF8F1);
    final textColor =
        isReaderDark ? const Color(0xFFE7E4DC) : const Color(0xFF22262E);
    final mutedColor =
        isReaderDark ? const Color(0xFF9AA3B2) : const Color(0xFF666E7A);

    return Scaffold(
      backgroundColor: bgColor,
      appBar: AppBar(
        backgroundColor: bgColor,
        foregroundColor: textColor,
        title: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              widget.book.title,
              maxLines: 1,
              overflow: TextOverflow.ellipsis,
              style: TextStyle(
                fontSize: 15,
                fontWeight: FontWeight.w700,
                color: textColor,
              ),
            ),
            Text(
              'Chapter ${_chapterIndex + 1} of ${chapters.length}',
              style: TextStyle(fontSize: 12, color: mutedColor),
            ),
          ],
        ),
        actions: [
          IconButton(
            tooltip: isCompleted ? 'Completed' : 'Mark as Completed',
            icon: Icon(
              isCompleted
                  ? Icons.check_circle_rounded
                  : Icons.check_circle_outline_rounded,
              color: isCompleted ? AppColors.success : textColor,
            ),
            onPressed: () {
              readingProvider.toggleCompleted(
                widget.book.id,
                chapters.length,
              );
            },
          ),
          IconButton(
            tooltip: isReaderDark ? 'Light Reader' : 'Dark Reader',
            icon: Icon(
              isReaderDark
                  ? Icons.light_mode_rounded
                  : Icons.dark_mode_rounded,
              color: textColor,
            ),
            onPressed: () => themeProvider.setReaderDark(!isReaderDark),
          ),
          IconButton(
            tooltip: 'Typography Settings',
            icon: Icon(Icons.text_fields_rounded, color: textColor),
            onPressed: () => _showReaderSettings(context),
          ),
        ],
        bottom: PreferredSize(
          preferredSize: const Size.fromHeight(4),
          child: LinearProgressIndicator(
            value: progress,
            minHeight: 4,
            backgroundColor: mutedColor.withValues(alpha: 0.2),
            valueColor: const AlwaysStoppedAnimation<Color>(
              AppColors.accentAmber,
            ),
          ),
        ),
      ),
      body: Column(
        children: [
          Expanded(
            child: SingleChildScrollView(
              controller: _scrollController,
              padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 32),
              child: Center(
                child: ConstrainedBox(
                  constraints: const BoxConstraints(maxWidth: 680),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        chapter.title,
                        style: AppTextStyles.readerHeading(color: textColor),
                      ),
                      const SizedBox(height: 8),
                      Text(
                        '${widget.book.author} • Sample Edition',
                        style: TextStyle(
                          color: mutedColor,
                          fontSize: 13,
                          fontWeight: FontWeight.w500,
                        ),
                      ),
                      const SizedBox(height: 24),
                      Text(
                        chapter.content,
                        style: AppTextStyles.readerBody(
                          fontSize: themeProvider.readerFontSize,
                          color: textColor,
                        ),
                      ),
                      const SizedBox(height: 40),
                    ],
                  ),
                ),
              ),
            ),
          ),
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 14),
            decoration: BoxDecoration(
              color: bgColor,
              border: Border(
                top: BorderSide(color: mutedColor.withValues(alpha: 0.22)),
              ),
            ),
            child: SafeArea(
              top: false,
              child: Center(
                child: ConstrainedBox(
                  constraints: const BoxConstraints(maxWidth: 680),
                  child: Row(
                    children: [
                      OutlinedButton.icon(
                        onPressed: _chapterIndex > 0
                            ? () => _goToChapter(_chapterIndex - 1)
                            : null,
                        icon: const Icon(Icons.arrow_back_rounded, size: 18),
                        label: const Text('Previous'),
                      ),
                      const Spacer(),
                      Text(
                        '${(progress * 100).round()}%',
                        style: TextStyle(
                          color: mutedColor,
                          fontWeight: FontWeight.w700,
                        ),
                      ),
                      const Spacer(),
                      if (_chapterIndex < chapters.length - 1)
                        FilledButton.icon(
                          onPressed: () => _goToChapter(_chapterIndex + 1),
                          style: FilledButton.styleFrom(
                            backgroundColor: AppColors.accentAmber,
                            foregroundColor: Colors.white,
                          ),
                          icon: const Icon(Icons.arrow_forward_rounded, size: 18),
                          label: const Text('Next Chapter'),
                        )
                      else
                        FilledButton.icon(
                          onPressed: () {
                            _saveProgress(markCompleted: true);
                            Navigator.of(context).pop();
                          },
                          style: FilledButton.styleFrom(
                            backgroundColor: AppColors.success,
                            foregroundColor: Colors.white,
                          ),
                          icon: const Icon(Icons.check_rounded, size: 18),
                          label: const Text('Finish Sample'),
                        ),
                    ],
                  ),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
