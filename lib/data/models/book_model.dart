class Book {
  final int bookId;
  final String title;
  final String author;
  final String publisher;
  final int publishedYear;
  final int stock;
  final DateTime createdAt;

  static final none = Book(
    author: '',
    publisher: '',
    publishedYear: 0,
    stock: 0,
    createdAt: DateTime(0),
    bookId: 0,
    title: '',
  );

  Book({
    required this.author,
    required this.publisher,
    required this.publishedYear,
    required this.stock,
    required this.createdAt,
    required this.bookId,
    required this.title,
  });

  factory Book.fromJson(Map<String, dynamic> json) {
    return Book(
      bookId: json['book_id'] as int,
      title: json['title'] as String,
      author: json['author'] as String,
      publisher: json['publisher'] as String,
      publishedYear: json['published_year'] as int,
      stock: json['stock'] as int,
      createdAt: DateTime.parse(json['created_at'] as String),
    );
  }
}
