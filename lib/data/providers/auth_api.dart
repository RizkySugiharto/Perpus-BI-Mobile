import 'dart:io';

import 'package:perpus_bi/data/models/account_model.dart';
import 'package:perpus_bi/data/utils/api_utils.dart';
import 'package:path_provider/path_provider.dart';

class AuthApi {
  static void saveTokenToFile(String token) async {
    final Directory appDocumentsDir = await getApplicationDocumentsDirectory();
    final File tokenFile = File('${appDocumentsDir.path}/tn');

    if (!await tokenFile.exists()) {
      await tokenFile.create();
    }
    await tokenFile.writeAsString(token);
  }

  static Future<bool> login(String email, String password) async {
    final result = await ApiUtils.getClient().post(
      '/auth/login',
      data: {
        'data': {'email': email, 'password': password},
      },
    );

    if (result.response?.statusCode == HttpStatus.ok) {
      final token = result.response?.data['token'];
      ApiUtils.setClientToken(token);
      saveTokenToFile(token);

      return true;
    } else {
      return false;
    }
  }

  static Future<bool> register({
    required String email,
    required String password,
    required String NIM,
    required String name,
    required String className,
    required String address,
    required String birthdate,
    required String gender,
  }) async {
    final result = await ApiUtils.getClient().post(
      '/auth/register',
      data: {
        'data': {
          'email': email,
          'password': password,
          'NIM': NIM,
          'name': name,
          'class_name': className,
          'address': address,
          'birthdate': birthdate,
          'gender': gender,
        },
      },
    );

    if (result.response?.statusCode == HttpStatus.created) {
      return true;
    } else {
      return false;
    }
  }

  static void logout() async {
    ApiUtils.setClientToken('');
    saveTokenToFile('');
  }

  static Future<Account> getMe() async {
    final result = await ApiUtils.getClient().get('/auth/me');

    if (result.response?.statusCode == HttpStatus.ok) {
      final resData = result.response?.data;
      return Account.fromJson(resData);
    } else {
      return Account.none;
    }
  }

  static Future<Account> patchMe({required String email}) async {
    final result = await ApiUtils.getClient().patch(
      '/auth/me',
      data: {
        'data': {'email': email},
      },
    );

    if (result.response?.statusCode == HttpStatus.ok) {
      final resData = result.response?.data as Map<String, dynamic>;
      return Account.fromJson(resData);
    } else {
      return Account.none;
    }
  }
}
