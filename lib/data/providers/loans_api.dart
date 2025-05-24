import 'dart:io';

import 'package:perpus_bi/data/models/loan_model.dart';
import 'package:perpus_bi/data/utils/api_utils.dart';

class LoansApi {
  static Future<List<Loan>> getAllLoans() async {
    final result = await ApiUtils.getClient().get('/loans');

    if (result.response?.data.length < 1) {
      return [];
    }

    if (result.response?.statusCode != HttpStatus.ok) {
      return [Loan.none];
    }

    final resData = result.response?.data as List<dynamic>;
    final data = resData.map((item) => Loan.fromJson(item)).toList();

    return data;
  }

  static Future<Loan> getSingleLoan(int loanId) async {
    final result = await ApiUtils.getClient().get('/loans/$loanId');

    if (result.response?.statusCode != HttpStatus.ok) {
      return Loan.none;
    }

    final resData = result.response?.data as Map<String, dynamic>;
    final data = Loan.fromJson(resData);

    return data;
  }

  static Future<Loan> post({
    required int bookId,
    required String loanDate,
    required String returnDate,
  }) async {
    final result = await ApiUtils.getClient().post(
      '/loans',
      data: {
        'book_id': bookId,
        'loan_date': loanDate,
        'return_date': returnDate,
      },
    );

    if (result.response?.statusCode == HttpStatus.created) {
      final resData = result.response?.data as Map<String, dynamic>;
      return Loan.fromJson(resData);
    } else {
      return Loan.none;
    }
  }
}
