class Account {
  final int accountId;
  final String email;
  final String role;
  static final none = Account(accountId: 0, email: '', role: '');

  Account({required this.accountId, required this.email, required this.role});

  factory Account.fromJson(Map<String, dynamic> json) {
    return Account(
      accountId: json['account_id'] as int,
      email: json['email'] as String,
      role: json['role'] as String,
    );
  }
}
