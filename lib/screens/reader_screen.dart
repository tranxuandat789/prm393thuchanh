import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:google_fonts/google_fonts.dart';
import '../models/book.dart';
import '../services/book_provider.dart';
import '../constants.dart';

class ReaderScreen extends StatefulWidget {
  final Book book;
  final int initialChapterIndex;

  const ReaderScreen({
    Key? key,
    required this.book,
    required this.initialChapterIndex,
  }) : super(key: key);

  @override
  State<ReaderScreen> createState() => _ReaderScreenState();
}

class _ReaderScreenState extends State<ReaderScreen> {
  late int _currentChapterIndex;
  final ScrollController _scrollController = ScrollController();

  @override
  void initState() {
    super.initState();
    _currentChapterIndex = widget.initialChapterIndex;

    // Save progress to provider immediately upon opening the chapter
    WidgetsBinding.instance.addPostFrameCallback((_) {
      Provider.of<BookProvider>(context, listen: false)
          .updateProgress(widget.book.id, _currentChapterIndex);
    });
  }

  @override
  void dispose() {
    _scrollController.dispose();
    super.dispose();
  }

  // Scroll smoothly back to top when chapter changes
  void _scrollToTop() {
    if (_scrollController.hasClients) {
      _scrollController.animateTo(
        0,
        duration: const Duration(milliseconds: 300),
        curve: Curves.easeInOut,
      );
    }
  }

  // Change to a new chapter index
  void _changeChapter(int index) {
    if (index >= 0 && index < widget.book.chapters.length) {
      setState(() {
        _currentChapterIndex = index;
      });
      Provider.of<BookProvider>(context, listen: false)
          .updateProgress(widget.book.id, index);
      _scrollToTop();
    }
  }

  // Show bottom sheet to easily customize Font Size
  void _showSettingsBottomSheet(BuildContext context) {
    showModalBottomSheet(
      context: context,
      backgroundColor: Theme.of(context).cardTheme.color,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(
            top: Radius.circular(AppConstants.radiusLarge)),
      ),
      builder: (context) {
        return Consumer<BookProvider>(
          builder: (context, provider, child) {
            return Padding(
              padding: const EdgeInsets.symmetric(
                horizontal: AppConstants.paddingLarge,
                vertical: AppConstants.paddingMedium,
              ),
              child: Column(
                mainAxisSize: MainAxisSize.min,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Center(
                    child: Container(
                      width: 40,
                      height: 4,
                      decoration: BoxDecoration(
                        color: Theme.of(context)
                            .colorScheme
                            .onBackground
                            .withOpacity(0.2),
                        borderRadius: BorderRadius.circular(2),
                      ),
                    ),
                  ),
                  const SizedBox(height: 20),
                  const Text(
                    'Cài đặt trình đọc',
                    style: TextStyle(
                      fontSize: 18,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  const SizedBox(height: 24),
                  Row(
                    children: [
                      const Text(
                        'Cỡ chữ',
                        style: TextStyle(
                            fontSize: 15, fontWeight: FontWeight.w600),
                      ),
                      const Spacer(),
                      Text(
                        '${provider.fontSize.toInt()}sp',
                        style: const TextStyle(
                          fontSize: 15,
                          fontWeight: FontWeight.bold,
                          color: AppConstants.primaryColor,
                        ),
                      ),
                    ],
                  ),
                  Row(
                    children: [
                      const Icon(Icons.format_size_rounded, size: 16),
                      Expanded(
                        child: Slider(
                          value: provider.fontSize,
                          min: 14.0,
                          max: 30.0,
                          divisions: 8,
                          activeColor: AppConstants.primaryColor,
                          inactiveColor:
                              AppConstants.primaryColor.withOpacity(0.15),
                          onChanged: (value) => provider.setFontSize(value),
                        ),
                      ),
                      const Icon(Icons.format_size_rounded, size: 24),
                    ],
                  ),
                  const SizedBox(height: 16),
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
    final bookProvider = Provider.of<BookProvider>(context);
    final currentChapter = widget.book.chapters[_currentChapterIndex];
    final isBookmarked =
        bookProvider.isBookmarked(widget.book.id, _currentChapterIndex);

    // Dynamic background and text colors according to Dark Mode
    final backgroundColor =
        bookProvider.isDarkMode ? AppConstants.darkBg : AppConstants.lightBg;
    final textColor = bookProvider.isDarkMode
        ? AppConstants.darkText
        : AppConstants.lightText;

    return Scaffold(
      backgroundColor: backgroundColor,
      appBar: AppBar(
        backgroundColor: backgroundColor,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back_ios_new_rounded, size: 18),
          onPressed: () => Navigator.pop(context),
        ),
        title: Text(
          widget.book.title,
          style: const TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
        ),
        actions: [
          // Bookmark Toggle Icon
          IconButton(
            icon: Icon(
              isBookmarked
                  ? Icons.bookmark_rounded
                  : Icons.bookmark_border_rounded,
              color: isBookmarked ? AppConstants.primaryColor : null,
            ),
            onPressed: () {
              bookProvider.toggleBookmarkByDetails(
                widget.book,
                _currentChapterIndex,
                currentChapter.title,
              );
              ScaffoldMessenger.of(context).clearSnackBars();
              ScaffoldMessenger.of(context).showSnackBar(
                SnackBar(
                  content: Text(
                    isBookmarked
                        ? 'Đã gỡ dấu trang!'
                        : 'Đã lưu dấu trang Chương ${_currentChapterIndex + 1}!',
                  ),
                  behavior: SnackBarBehavior.floating,
                  duration: const Duration(seconds: 2),
                ),
              );
            },
          ),
          // Dark Mode quick toggle
          IconButton(
            icon: Icon(
              bookProvider.isDarkMode
                  ? Icons.wb_sunny_rounded
                  : Icons.nightlight_round,
              size: 20,
            ),
            onPressed: () => bookProvider.toggleDarkMode(),
          ),
          // Text customization settings sheet opener
          IconButton(
            icon: const Icon(Icons.tune_rounded, size: 20),
            onPressed: () => _showSettingsBottomSheet(context),
          ),
          const SizedBox(width: 8),
        ],
      ),
      body: SafeArea(
        child: Scrollbar(
          controller: _scrollController,
          child: SingleChildScrollView(
            controller: _scrollController,
            physics: const BouncingScrollPhysics(),
            padding: const EdgeInsets.symmetric(
              horizontal: AppConstants.paddingLarge,
              vertical: AppConstants.paddingMedium,
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // Chapter Header Label
                Text(
                  'CHƯƠNG ${_currentChapterIndex + 1}',
                  style: const TextStyle(
                    fontSize: 12,
                    fontWeight: FontWeight.bold,
                    color: AppConstants.primaryColor,
                    letterSpacing: 2.0,
                  ),
                ),
                const SizedBox(height: 8),
                // Chapter Title Text
                Text(
                  currentChapter.title,
                  style: TextStyle(
                    fontFamily: 'Outfit',
                    fontSize: 22,
                    fontWeight: FontWeight.bold,
                    color: textColor,
                    letterSpacing: -0.5,
                  ),
                ),
                const SizedBox(height: 24),
                // Chapter Content - Stylized Serif for optimum comfort
                Text(
                  currentChapter.content,
                  style: GoogleFonts.merriweather(
                    fontSize: bookProvider.fontSize,
                    height: 1.8,
                    color: textColor.withOpacity(0.85),
                  ),
                ),
                const SizedBox(height: 60),
              ],
            ),
          ),
        ),
      ),
      // Navigation bottom bar to switch chapters easily
      bottomNavigationBar: Container(
        padding: const EdgeInsets.symmetric(
            horizontal: AppConstants.paddingMedium, vertical: 12),
        decoration: BoxDecoration(
          color: bookProvider.isDarkMode
              ? AppConstants.darkCardBg.withOpacity(0.9)
              : Colors.white.withOpacity(0.9),
          border: Border(
            top: BorderSide(
              color:
                  Theme.of(context).colorScheme.onBackground.withOpacity(0.08),
              width: 1,
            ),
          ),
        ),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            // Previous Chapter Button
            TextButton.icon(
              onPressed: _currentChapterIndex > 0
                  ? () => _changeChapter(_currentChapterIndex - 1)
                  : null,
              icon: const Icon(Icons.arrow_back_rounded, size: 18),
              label: const Text('Chương trước'),
              style: TextButton.styleFrom(
                foregroundColor: AppConstants.primaryColor,
                disabledForegroundColor: Colors.grey.withOpacity(0.4),
              ),
            ),
            // Current Progress text indicator
            Text(
              '${_currentChapterIndex + 1}/${widget.book.chapters.length}',
              style: TextStyle(
                fontWeight: FontWeight.bold,
                fontSize: 14,
                color: textColor.withOpacity(0.6),
              ),
            ),
            // Next Chapter Button
            TextButton(
              onPressed: _currentChapterIndex < widget.book.chapters.length - 1
                  ? () => _changeChapter(_currentChapterIndex + 1)
                  : null,
              child: Row(
                mainAxisSize: MainAxisSize.min,
                children: [
                  const Text('Chương tiếp'),
                  const SizedBox(width: 4),
                  const Icon(Icons.arrow_forward_rounded, size: 18),
                ],
              ),
              style: TextButton.styleFrom(
                foregroundColor: AppConstants.primaryColor,
                disabledForegroundColor: Colors.grey.withOpacity(0.4),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
