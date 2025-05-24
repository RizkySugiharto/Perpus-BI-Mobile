import 'package:perpus_bi/data/models/account_model.dart';

class AccountStatic {
  static String email = '';

  static void setByAccount(Account account) {
    AccountStatic.email = account.email;
  }
}
