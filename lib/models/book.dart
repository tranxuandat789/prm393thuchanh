class Chapter {
  final String id;
  final String title;
  final String content;

  Chapter({
    required this.id,
    required this.title,
    required this.content,
  });

  Map<String, dynamic> toJson() => {
        'id': id,
        'title': title,
        'content': content,
      };

  factory Chapter.fromJson(Map<String, dynamic> json) => Chapter(
        id: json['id'] as String,
        title: json['title'] as String,
        content: json['content'] as String,
      );
}

class Book {
  final String id;
  final String title;
  final String author;
  final String coverUrl;
  final double rating;
  final String category;
  final String description;
  final List<Chapter> chapters;

  Book({
    required this.id,
    required this.title,
    required this.author,
    required this.coverUrl,
    required this.rating,
    required this.category,
    required this.description,
    required this.chapters,
  });
}

class Bookmark {
  final String id;
  final String bookId;
  final String bookTitle;
  final String bookCover;
  final int chapterIndex;
  final String chapterTitle;
  final DateTime savedAt;

  Bookmark({
    required this.id,
    required this.bookId,
    required this.bookTitle,
    required this.bookCover,
    required this.chapterIndex,
    required this.chapterTitle,
    required this.savedAt,
  });

  Map<String, dynamic> toJson() => {
        'id': id,
        'bookId': bookId,
        'bookTitle': bookTitle,
        'bookCover': bookCover,
        'chapterIndex': chapterIndex,
        'chapterTitle': chapterTitle,
        'savedAt': savedAt.toIso8601String(),
      };

  factory Bookmark.fromJson(Map<String, dynamic> json) => Bookmark(
        id: json['id'] as String,
        bookId: json['bookId'] as String,
        bookTitle: json['bookTitle'] as String,
        bookCover: json['bookCover'] as String,
        chapterIndex: json['chapterIndex'] as int,
        chapterTitle: json['chapterTitle'] as String,
        savedAt: DateTime.parse(json['savedAt'] as String),
      );
}
