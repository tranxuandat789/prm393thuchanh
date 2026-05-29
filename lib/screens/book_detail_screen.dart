import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:flutter_animate/flutter_animate.dart';
import '../models/book.dart';
import '../services/book_provider.dart';
import '../constants.dart';
import '../widgets/custom_button.dart';
import 'reader_screen.dart';

class BookDetailScreen extends StatelessWidget {
  final Book book;

  const BookDetailScreen({
    Key? key,
    required this.book,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final bookProvider = Provider.of<BookProvider>(context);
    final currentChapterIndex = bookProvider.readingProgress[book.id] ?? 0;
    
    // Check if any chapter of this book is bookmarked to display toggle state
    final isAnyBookmarked = book.chapters.asMap().keys.any((index) => bookProvider.isBookmarked(book.id, index));

    return Scaffold(
      body: CustomScrollView(
        physics: const BouncingScrollPhysics(),
        slivers: [
          // Elegant Header with Transparent AppBar and blurred background effect
          SliverAppBar(
            expandedHeight: 340,
            pinned: true,
            stretch: true,
            backgroundColor: Theme.of(context).scaffoldBackgroundColor,
            elevation: 0,
            leading: CircleAvatar(
              backgroundColor: Theme.of(context).scaffoldBackgroundColor.withOpacity(0.8),
              child: IconButton(
                icon: const Icon(Icons.arrow_back_ios_new_rounded, size: 16),
                onPressed: () => Navigator.pop(context),
              ),
            ),
            actions: [
              CircleAvatar(
                backgroundColor: Theme.of(context).scaffoldBackgroundColor.withOpacity(0.8),
                child: IconButton(
                  icon: Icon(
                    isAnyBookmarked ? Icons.bookmark_added_rounded : Icons.bookmark_add_outlined,
                    color: isAnyBookmarked ? AppConstants.primaryColor : null,
                    size: 20,
                  ),
                  onPressed: () {
                    // Toggle bookmark for current or first chapter
                    bookProvider.toggleBookmarkByDetails(
                      book,
                      currentChapterIndex,
                      book.chapters[currentChapterIndex].title,
                    );
                    ScaffoldMessenger.of(context).clearSnackBars();
                    ScaffoldMessenger.of(context).showSnackBar(
                      SnackBar(
                        content: Text(
                          bookProvider.isBookmarked(book.id, currentChapterIndex)
                              ? 'Đã lưu dấu trang Chương ${currentChapterIndex + 1}!'
                              : 'Đã xóa dấu trang Chương ${currentChapterIndex + 1}!',
                        ),
                        behavior: SnackBarBehavior.floating,
                        duration: const Duration(seconds: 2),
                      ),
                    );
                  },
                ),
              ),
              const SizedBox(width: 16),
            ],
            flexibleSpace: FlexibleSpaceBar(
              stretchModes: const [
                StretchMode.zoomBackground,
                StretchMode.blurBackground,
              ],
              background: Stack(
                fit: StackFit.expand,
                children: [
                  // Blurry Cover background
                  Image.network(
                    book.coverUrl,
                    fit: BoxFit.cover,
                  ),
                  Container(
                    color: Theme.of(context).scaffoldBackgroundColor.withOpacity(0.88),
                  ),
                  // Sharp Cover Image
                  Center(
                    child: Container(
                      margin: const EdgeInsets.only(top: 50),
                      width: 140,
                      height: 200,
                      decoration: BoxDecoration(
                        boxShadow: [
                          BoxShadow(
                            color: Colors.black.withOpacity(0.2),
                            blurRadius: 15,
                            offset: const Offset(0, 10),
                          )
                        ],
                      ),
                      child: Hero(
                        tag: 'cover_${book.id}',
                        child: ClipRRect(
                          borderRadius: BorderRadius.circular(AppConstants.radiusMedium),
                          child: Image.network(
                            book.coverUrl,
                            fit: BoxFit.cover,
                          ),
                        ),
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ),
          
          // Book Information details
          SliverToBoxAdapter(
            child: Padding(
              padding: const EdgeInsets.all(AppConstants.paddingMedium),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // Book Title & Author
                  Center(
                    child: Column(
                      children: [
                        Text(
                          book.title,
                          textAlign: TextAlign.center,
                          style: const TextStyle(
                            fontSize: 24,
                            fontWeight: FontWeight.bold,
                            letterSpacing: -0.5,
                          ),
                        ).animate().fadeIn(duration: 400.ms).slideY(begin: 0.1, end: 0),
                        const SizedBox(height: 8),
                        Text(
                          book.author,
                          style: TextStyle(
                            fontSize: 16,
                            color: Theme.of(context).colorScheme.onBackground.withOpacity(0.6),
                            fontWeight: FontWeight.w500,
                          ),
                        ).animate().fadeIn(duration: 400.ms, delay: 100.ms),
                      ],
                    ),
                  ),
                  const SizedBox(height: 20),
                  
                  // Metadata Badges (Rating, Category, Total Chapters)
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                    children: [
                      _buildMetaItem(context, Icons.star_rounded, Colors.amber, book.rating.toString(), 'Đánh giá'),
                      _buildMetaDivider(context),
                      _buildMetaItem(context, Icons.category_rounded, AppConstants.primaryColor, book.category, 'Thể loại'),
                      _buildMetaDivider(context),
                      _buildMetaItem(context, Icons.menu_book_rounded, Colors.blueGrey, '${book.chapters.length} Ch.', 'Mục lục'),
                    ],
                  ).animate().fadeIn(duration: 500.ms, delay: 200.ms),
                  const SizedBox(height: 24),
                  
                  // Action buttons: "Read Now" and Continue reading progress
                  Center(
                    child: CustomButton(
                      text: currentChapterIndex > 0 ? 'Đọc tiếp Chương ${currentChapterIndex + 1}' : 'Đọc Sách Ngay',
                      icon: Icons.play_arrow_rounded,
                      width: double.infinity,
                      onPressed: () {
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (context) => ReaderScreen(
                              book: book,
                              initialChapterIndex: currentChapterIndex,
                            ),
                          ),
                        );
                      },
                    ),
                  ).animate().fadeIn(duration: 500.ms, delay: 250.ms),
                  const SizedBox(height: 24),
                  
                  // Book Description
                  const Text(
                    'Tóm tắt nội dung',
                    style: TextStyle(
                      fontSize: 18,
                      fontWeight: FontWeight.bold,
                      letterSpacing: -0.5,
                    ),
                  ),
                  const SizedBox(height: 8),
                  Text(
                    book.description,
                    style: TextStyle(
                      fontSize: 14,
                      height: 1.6,
                      color: Theme.of(context).colorScheme.onBackground.withOpacity(0.8),
                    ),
                  ),
                  const SizedBox(height: 24),
                  
                  // Chapters Section title
                  const Text(
                    'Mục lục chương',
                    style: TextStyle(
                      fontSize: 18,
                      fontWeight: FontWeight.bold,
                      letterSpacing: -0.5,
                    ),
                  ),
                  const SizedBox(height: 8),
                  
                  // Chapters List ListView
                  ListView.separated(
                    shrinkWrap: true,
                    physics: const NeverScrollableScrollPhysics(),
                    itemCount: book.chapters.length,
                    separatorBuilder: (context, index) => Divider(
                      color: Theme.of(context).colorScheme.onBackground.withOpacity(0.08),
                      height: 1,
                    ),
                    itemBuilder: (context, index) {
                      final chapter = book.chapters[index];
                      final isRead = currentChapterIndex >= index;
                      final isCurrent = currentChapterIndex == index;

                      return ListTile(
                        onTap: () {
                          Navigator.push(
                            context,
                            MaterialPageRoute(
                              builder: (context) => ReaderScreen(
                                book: book,
                                initialChapterIndex: index,
                              ),
                            ),
                          );
                        },
                        contentPadding: const EdgeInsets.symmetric(horizontal: 4, vertical: 4),
                        leading: CircleAvatar(
                          radius: 16,
                          backgroundColor: isCurrent
                              ? AppConstants.primaryColor
                              : (isRead ? AppConstants.primaryColor.withOpacity(0.1) : Colors.transparent),
                          child: Text(
                            '${index + 1}',
                            style: TextStyle(
                              fontSize: 12,
                              fontWeight: FontWeight.bold,
                              color: isCurrent
                                  ? Colors.white
                                  : (isRead ? AppConstants.primaryColor : Theme.of(context).colorScheme.onBackground.withOpacity(0.5)),
                            ),
                          ),
                        ),
                        title: Text(
                          chapter.title,
                          style: TextStyle(
                            fontSize: 15,
                            fontWeight: isCurrent ? FontWeight.bold : FontWeight.w500,
                            color: isCurrent
                                ? AppConstants.primaryColor
                                : Theme.of(context).colorScheme.onBackground.withOpacity(0.8),
                          ),
                        ),
                        trailing: Icon(
                          isCurrent
                              ? Icons.menu_book_rounded
                              : (isRead ? Icons.check_circle_outline_rounded : Icons.arrow_forward_ios_rounded),
                          size: 16,
                          color: isCurrent || isRead ? AppConstants.primaryColor : Colors.grey,
                        ),
                      );
                    },
                  ).animate().fadeIn(duration: 500.ms, delay: 300.ms),
                  const SizedBox(height: 24),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildMetaItem(BuildContext context, IconData icon, Color iconColor, String title, String subtitle) {
    return Column(
      children: [
        Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            Icon(icon, color: iconColor, size: 20),
            const SizedBox(width: 4),
            Text(
              title,
              style: const TextStyle(
                fontWeight: FontWeight.bold,
                fontSize: 16,
              ),
            ),
          ],
        ),
        const SizedBox(height: 4),
        Text(
          subtitle,
          style: TextStyle(
            fontSize: 11,
            color: Theme.of(context).colorScheme.onBackground.withOpacity(0.5),
            fontWeight: FontWeight.w500,
          ),
        ),
      ],
    );
  }

  Widget _buildMetaDivider(BuildContext context) {
    return Container(
      height: 24,
      width: 1,
      color: Theme.of(context).colorScheme.onBackground.withOpacity(0.15),
    );
  }
}
