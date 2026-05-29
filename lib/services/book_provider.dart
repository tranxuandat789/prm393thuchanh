import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import '../models/book.dart';
import '../data/dummy_data.dart';

class BookProvider extends ChangeNotifier {
  // Config keys for SharedPreferences
  static const String _keyDarkMode = 'is_dark_mode';
  static const String _keyFontSize = 'reader_font_size';
  static const String _keyBookmarks = 'saved_bookmarks';
  static const String _keyProgress = 'reading_progress';

  // App State variables
  bool _isDarkMode = false;
  double _fontSize = 18.0;
  List<Bookmark> _bookmarks = [];
  Map<String, int> _readingProgress = {}; // bookId: chapterIndex
  final List<Book> _books = DummyData.books;

  // Getters
  bool get isDarkMode => _isDarkMode;
  double get fontSize => _fontSize;
  List<Bookmark> get bookmarks => _bookmarks;
  Map<String, int> get readingProgress => _readingProgress;
  List<Book> get books => _books;

  BookProvider() {
    _loadFromPrefs();
  }

  // Load configuration and data from SharedPreferences
  Future<void> _loadFromPrefs() async {
    try {
      final prefs = await SharedPreferences.getInstance();
      
      // Load dark mode
      _isDarkMode = prefs.getBool(_keyDarkMode) ?? false;
      
      // Load font size
      _fontSize = prefs.getDouble(_keyFontSize) ?? 18.0;
      
      // Load bookmarks
      final bookmarksJson = prefs.getStringList(_keyBookmarks) ?? [];
      _bookmarks = bookmarksJson
          .map((item) => Bookmark.fromJson(jsonDecode(item) as Map<String, dynamic>))
          .toList();
      
      // Load reading progress
      final progressString = prefs.getString(_keyProgress);
      if (progressString != null) {
        final decoded = jsonDecode(progressString) as Map<String, dynamic>;
        _readingProgress = decoded.map((key, value) => MapEntry(key, value as int));
      }
      
      notifyListeners();
    } catch (e) {
      debugPrint('Error loading from SharedPreferences: $e');
    }
  }

  // Toggle Dark/Light Mode
  Future<void> toggleDarkMode() async {
    _isDarkMode = !_isDarkMode;
    notifyListeners();
    final prefs = await SharedPreferences.getInstance();
    await prefs.setBool(_keyDarkMode, _isDarkMode);
  }

  // Change font size
  Future<void> setFontSize(double size) async {
    _fontSize = size;
    notifyListeners();
    final prefs = await SharedPreferences.getInstance();
    await prefs.setDouble(_keyFontSize, _fontSize);
  }

  // Check if a chapter is bookmarked
  bool isBookmarked(String bookId, int chapterIndex) {
    return _bookmarks.any((b) => b.bookId == bookId && b.chapterIndex == chapterIndex);
  }

  // Add a Bookmark
  Future<void> addBookmark(Book book, int chapterIndex, String chapterTitle) async {
    // Check if already exists to avoid duplicate
    if (isBookmarked(book.id, chapterIndex)) return;

    final newBookmark = Bookmark(
      id: '${book.id}_ch_${chapterIndex}_${DateTime.now().millisecondsSinceEpoch}',
      bookId: book.id,
      bookTitle: book.title,
      bookCover: book.coverUrl,
      chapterIndex: chapterIndex,
      chapterTitle: chapterTitle,
      savedAt: DateTime.now(),
    );

    _bookmarks.add(newBookmark);
    notifyListeners();

    final prefs = await SharedPreferences.getInstance();
    final stringList = _bookmarks.map((b) => jsonEncode(b.toJson())).toList();
    await prefs.setStringList(_keyBookmarks, stringList);
  }

  // Remove a Bookmark
  Future<void> removeBookmark(String bookmarkId) async {
    _bookmarks.removeWhere((b) => b.id == bookmarkId);
    notifyListeners();

    final prefs = await SharedPreferences.getInstance();
    final stringList = _bookmarks.map((b) => jsonEncode(b.toJson())).toList();
    await prefs.setStringList(_keyBookmarks, stringList);
  }

  // Remove a Bookmark by Book details (Toggle)
  Future<void> toggleBookmarkByDetails(Book book, int chapterIndex, String chapterTitle) async {
    if (isBookmarked(book.id, chapterIndex)) {
      final existing = _bookmarks.firstWhere((b) => b.bookId == book.id && b.chapterIndex == chapterIndex);
      await removeBookmark(existing.id);
    } else {
      await addBookmark(book, chapterIndex, chapterTitle);
    }
  }

  // Update Reading Progress
  Future<void> updateProgress(String bookId, int chapterIndex) async {
    _readingProgress[bookId] = chapterIndex;
    notifyListeners();

    final prefs = await SharedPreferences.getInstance();
    await prefs.setString(_keyProgress, jsonEncode(_readingProgress));
  }

  // Calculate overall reading progress percentage for a book
  double getProgressPercentage(String bookId, int totalChapters) {
    if (!_readingProgress.containsKey(bookId) || totalChapters == 0) return 0.0;
    // index is 0-based, so progress is (index + 1) / total
    int currentChapter = _readingProgress[bookId]! + 1;
    return currentChapter / totalChapters;
  }
}
