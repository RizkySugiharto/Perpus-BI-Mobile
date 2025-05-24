import 'dart:io';

import 'package:perpus_bi/data/models/book_model.dart';
import 'package:perpus_bi/data/utils/api_utils.dart';

class BooksApi {
  static Future<List<Book>> getAllBooks() async {
    final result = await ApiUtils.getClient().get('/books');

    if (result.response?.data.length < 1) {
      return [];
    }

    if (result.response?.statusCode != HttpStatus.ok) {
      return [Book.none];
    }

    final resData = result.response?.data as List<dynamic>;
    final data = resData.map((item) => Book.fromJson(item)).toList();

    return data;
  }

  static Future<Book> getSingleBook(int bookId) async {
    final result = await ApiUtils.getClient().get('/books/$bookId');

    if (result.response?.statusCode != HttpStatus.ok) {
      return Book.none;
    }

    final resData = result.response?.data as Map<String, dynamic>;
    final data = Book.fromJson(resData);

    return data;
  }
}
