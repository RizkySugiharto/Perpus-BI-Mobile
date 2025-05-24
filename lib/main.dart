import 'dart:io';

import 'package:perpus_bi/data/constants/route_constants.dart';
import 'package:perpus_bi/data/notifiers/alert_notifiers.dart';
import 'package:perpus_bi/data/utils/api_utils.dart';
import 'package:perpus_bi/presentation/screens/book_details_screen.dart';
import 'package:perpus_bi/presentation/screens/loan_details_screen.dart';
import 'package:perpus_bi/presentation/screens/loan_form_screen.dart';
import 'package:perpus_bi/presentation/screens/loans_screen.dart';
import 'package:perpus_bi/presentation/screens/login_screen.dart';
import 'package:perpus_bi/presentation/screens/books_screen.dart';
import 'package:perpus_bi/presentation/screens/profile_screen.dart';
import 'package:perpus_bi/presentation/screens/register_screen.dart';
import 'package:perpus_bi/presentation/utils/alert_banner_utils.dart';
import 'package:flutter/material.dart';
import 'package:perpus_bi/data/constants/app_constants.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:observe_internet_connectivity/observe_internet_connectivity.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:rest_api_client/rest_api_client.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';

extension FileNameExtension on FileSystemEntity {
  String? get name {
    return path.split(Platform.pathSeparator).last;
  }
}

Future main() async {
  WidgetsFlutterBinding.ensureInitialized();

  await dotenv.load(fileName: ".env");
  await RestApiClient.initFlutter();
  await ApiUtils.init();

  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  static bool isFirstInternetValidation = true;

  const MyApp({super.key});

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    Permission.manageExternalStorage.request().then((status) {
      if (status.isDenied || status.isPermanentlyDenied) {
        if (!context.mounted) {
          return;
        }

        AlertBannerUtils.showAlertBanner(
          context,
          message: 'Please allow the permission to continue the app :(',
          alertType: AlertBannerType.error,
        );
      }
    });

    return MaterialApp(
      title: AppConstants.appName,
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(seedColor: Colors.deepOrangeAccent),
        highlightColor: Colors.deepOrangeAccent,
        splashColor: Colors.deepOrangeAccent.withValues(alpha: 0.2),
        iconButtonTheme: IconButtonThemeData(
          style: ButtonStyle(
            overlayColor: WidgetStateProperty.all<Color>(
              Colors.deepOrangeAccent.withValues(alpha: 0.2),
            ),
          ),
        ),
        elevatedButtonTheme: ElevatedButtonThemeData(
          style: ElevatedButton.styleFrom(
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(8),
            ),
            backgroundColor: Colors.white,
            overlayColor: Colors.deepOrangeAccent.withValues(alpha: 0.2),
          ),
        ),
        inputDecorationTheme: InputDecorationTheme(
          focusColor: Colors.deepOrangeAccent,
          hoverColor: Colors.deepOrangeAccent,
          hintStyle: GoogleFonts.poppins(
            fontSize: 16,
            color: Colors.black.withValues(alpha: 0.35),
          ),
          filled: true,
          fillColor: Colors.black12,
          border: OutlineInputBorder(
            borderRadius: BorderRadius.circular(6),
            borderSide: BorderSide(color: Colors.black, width: 1.5),
          ),
          contentPadding: const EdgeInsets.symmetric(
            horizontal: 16,
            vertical: 10,
          ),
        ),
        tabBarTheme: TabBarThemeData(
          dividerHeight: 2,
          dividerColor: Colors.grey,
          indicatorColor: Colors.deepOrangeAccent,
          labelColor: Colors.deepOrangeAccent,
          overlayColor: WidgetStatePropertyAll(
            Colors.deepOrangeAccent.withValues(alpha: 0.2),
          ),
        ),
        primaryColor: Colors.deepOrangeAccent,
        hoverColor: Colors.deepOrangeAccent,
        focusColor: Colors.deepOrangeAccent,
        shadowColor: Colors.black.withValues(alpha: 0.05),
        iconTheme: IconThemeData(color: Colors.black),
        scaffoldBackgroundColor: Colors.grey.shade300,
      ),
      initialRoute: RouteConstants.login,
      routes: {
        RouteConstants.login: (context) => LoginScreen(),
        RouteConstants.register: (context) => RegisterScreen(),
        RouteConstants.books: (context) => BooksScreen(),
        RouteConstants.bookDetails: (context) => BookDetailsScreen(),
        RouteConstants.loanForm: (context) => LoanFormScreen(),
        RouteConstants.loans: (context) => LoansScreen(),
        RouteConstants.loanDetails: (context) => LoanDetailsScreen(),
        RouteConstants.profile: (context) => ProfileScreen(),
      },
      debugShowCheckedModeBanner: false,
      builder: (context, child) {
        return Overlay(
          initialEntries: [
            OverlayEntry(
              builder: (context) {
                return InternetConnectivityListener(
                  connectivityListener: (context, hasInternetAccess) {
                    if (!context.mounted) {
                      return;
                    }

                    if (isFirstInternetValidation) {
                      isFirstInternetValidation = false;
                      return;
                    }

                    if (hasInternetAccess) {
                      AlertBannerUtils.showAlertBanner(
                        context,
                        message: 'Welcome, you now have an internet :)',
                        alertType: AlertBannerType.success,
                      );
                    } else {
                      AlertBannerUtils.showAlertBanner(
                        context,
                        message: 'You don\'t have an internet connection :(',
                        alertType: AlertBannerType.error,
                      );
                    }
                  },
                  child: child ?? Scaffold(),
                );
              },
            ),
          ],
        );
      },
    );
  }
}
