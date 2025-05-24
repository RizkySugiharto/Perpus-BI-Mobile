class Loan {
  final int loanId;
  final int bookId;
  final int accountId;
  final DateTime loanDate;
  final DateTime returnDate;
  final bool taken;
  final bool returned;
  final DateTime createdAt;
  final DateTime? deletedAt;
  final int? deletedBy;

  static final none = Loan(
    loanId: 0,
    bookId: 0,
    accountId: 0,
    loanDate: DateTime(0),
    returnDate: DateTime(0),
    taken: false,
    returned: false,
    createdAt: DateTime(0),
    deletedAt: DateTime(0),
    deletedBy: 0,
  );

  Loan({
    required this.loanId,
    required this.bookId,
    required this.accountId,
    required this.loanDate,
    required this.returnDate,
    required this.taken,
    required this.returned,
    required this.createdAt,
    this.deletedAt,
    this.deletedBy,
  });

  factory Loan.fromJson(Map<String, dynamic> json) {
    return Loan(
      loanId: json['loan_id'] as int,
      bookId: json['book_id'] as int,
      accountId: json['account_id'] as int,
      loanDate: DateTime.parse(json['loan_date'] as String),
      returnDate: DateTime.parse(json['return_date'] as String),
      taken: json['taken'] as bool,
      returned: json['returned'] as bool,
      createdAt: DateTime.parse(json['created_at'] as String),
      deletedAt:
          json['deleted_at'] != null
              ? DateTime.parse(json['deleted_at'] as String)
              : null,
      deletedBy: json['deleted_by'] != null ? json['deleted_by'] as int : null,
    );
  }
}
