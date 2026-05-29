import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:flutter_animate/flutter_animate.dart';
import '../services/book_provider.dart';
import '../constants.dart';
import 'reader_screen.dart';

class BookmarkScreen extends StatelessWidget {
  const BookmarkScreen({Key? key}) : super(key: key);

  // Helper method to format DateTime to relative/simple text
  String _formatDateTime(DateTime dt) {
    final now = DateTime.now();
    final diff = now.difference(dt);

    if (diff.inMinutes < 1) {
      return 'Vừa xong';
    } else if (diff.inMinutes < 60) {
      return '${diff.inMinutes} phút trước';
    } else if (diff.inHours < 24) {
      return '${diff.inHours} giờ trước';
    } else {
      return '${dt.day}/${dt.month}/${dt.year}';
    }
  }

  @override
  Widget build(BuildContext context) {
    final bookProvider = Provider.of<BookProvider>(context);
    final bookmarks = bookProvider.bookmarks;

    return Scaffold(
      appBar: AppBar(
        title: const Text('Dấu trang của tôi'),
        leading: IconButton(
          icon: const Icon(Icons.arrow_back_ios_new_rounded, size: 18),
          onPressed: () => Navigator.pop(context),
        ),
      ),
      body: SafeArea(
        child: bookmarks.isEmpty
            ? Center(
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Icon(
                      Icons.bookmark_outline_rounded,
                      size: 80,
                      color: Theme.of(context).colorScheme.onBackground.withOpacity(0.15),
                    ),
                    const SizedBox(height: 16),
                    Text(
                      'Chưa có dấu trang nào được lưu',
                      style: TextStyle(
                        fontSize: 16,
                        color: Theme.of(context).colorScheme.onBackground.withOpacity(0.5),
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                    const SizedBox(height: 8),
                    Text(
                      'Hãy nhấn nút Bookmark khi đọc để lưu lại',
                      style: TextStyle(
                        fontSize: 13,
                        color: Theme.of(context).colorScheme.onBackground.withOpacity(0.4),
                      ),
                    ),
                  ],
                ),
              )
            : ListView.builder(
                itemCount: bookmarks.length,
                physics: const BouncingScrollPhysics(),
                padding: const EdgeInsets.all(AppConstants.paddingMedium),
                itemBuilder: (context, index) {
                  final bookmark = bookmarks[index];
                  // Find the corresponding book details
                  final originalBook = bookProvider.books.firstWhere(
                    (b) => b.id == bookmark.bookId,
                    orElse: () => bookProvider.books.first,
                  );

                  return Dismissible(
                    key: Key(bookmark.id),
                    direction: DismissDirection.endToStart,
                    background: Container(
                      alignment: Alignment.centerRight,
                      padding: const EdgeInsets.only(right: 20),
                      margin: const EdgeInsets.only(bottom: 12),
                      decoration: BoxDecoration(
                        color: Colors.redAccent.withOpacity(0.9),
                        borderRadius: BorderRadius.circular(AppConstants.radiusMedium),
                      ),
                      child: const Icon(Icons.delete_rounded, color: Colors.white),
                    ),
                    onDismissed: (direction) {
                      bookProvider.removeBookmark(bookmark.id);
                      ScaffoldMessenger.of(context).clearSnackBars();
                      ScaffoldMessenger.of(context).showSnackBar(
                        const SnackBar(
                          content: Text('Đã gỡ bỏ dấu trang!'),
                          behavior: SnackBarBehavior.floating,
                          duration: Duration(seconds: 1),
                        ),
                      );
                    },
                    child: Container(
                      margin: const EdgeInsets.only(bottom: 12),
                      decoration: BoxDecoration(
                        color: Theme.of(context).cardTheme.color,
                        borderRadius: BorderRadius.circular(AppConstants.radiusMedium),
                        boxShadow: [
                          BoxShadow(
                            color: Colors.black.withOpacity(0.02),
                            blurRadius: 8,
                            offset: const Offset(0, 4),
                          )
                        ],
                      ),
                      child: ListTile(
                        contentPadding: const EdgeInsets.all(10),
                        onTap: () {
                          // Route to the specific book and chapter index
                          Navigator.push(
                            context,
                            MaterialPageRoute(
                              builder: (context) => ReaderScreen(
                                book: originalBook,
                                initialChapterIndex: bookmark.chapterIndex,
                              ),
                            ),
                          );
                        },
                        leading: ClipRRect(
                          borderRadius: BorderRadius.circular(8),
                          child: Image.network(
                            bookmark.bookCover,
                            width: 50,
                            height: 70,
                            fit: BoxFit.cover,
                            errorBuilder: (context, error, stackTrace) => Container(
                              width: 50,
                              height: 70,
                              color: AppConstants.primaryColor.withOpacity(0.2),
                              child: const Icon(Icons.book, size: 24, color: AppConstants.primaryColor),
                            ),
                          ),
                        ),
                        title: Text(
                          bookmark.bookTitle,
                          maxLines: 1,
                          overflow: TextOverflow.ellipsis,
                          style: const TextStyle(
                            fontWeight: FontWeight.bold,
                            fontSize: 15,
                          ),
                        ),
                        subtitle: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            const SizedBox(height: 4),
                            Text(
                              bookmark.chapterTitle,
                              maxLines: 1,
                              overflow: TextOverflow.ellipsis,
                              style: TextStyle(
                                fontSize: 13,
                                fontWeight: FontWeight.w600,
                                color: Theme.of(context).colorScheme.primary,
                              ),
                            ),
                            const SizedBox(height: 6),
                            Row(
                              children: [
                                Icon(
                                  Icons.access_time_rounded,
                                  size: 12,
                                  color: Theme.of(context).colorScheme.onBackground.withOpacity(0.4),
                                ),
                                const SizedBox(width: 4),
                                Text(
                                  _formatDateTime(bookmark.savedAt),
                                  style: TextStyle(
                                    fontSize: 11,
                                    color: Theme.of(context).colorScheme.onBackground.withOpacity(0.4),
                                  ),
                                ),
                              ],
                            ),
                          ],
                        ),
                        trailing: const Icon(Icons.arrow_forward_ios_rounded, size: 14),
                      ),
                    ),
                  ).animate().fadeIn(delay: (index * 50).ms, duration: 350.ms);
                },
              ),
      ),
    );
  }
}
