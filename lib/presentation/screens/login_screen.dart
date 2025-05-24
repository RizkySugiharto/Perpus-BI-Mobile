import 'package:flutter/gestures.dart';
import 'package:perpus_bi/data/constants/app_constants.dart';
import 'package:perpus_bi/data/constants/route_constants.dart';
import 'package:perpus_bi/data/models/account_model.dart';
import 'package:perpus_bi/data/notifiers/alert_notifiers.dart';
import 'package:perpus_bi/data/notifiers/navbar_notifiers.dart';
import 'package:perpus_bi/data/providers/auth_api.dart';
import 'package:perpus_bi/data/static/account_static.dart';
import 'package:perpus_bi/data/utils/api_utils.dart';
import 'package:perpus_bi/presentation/utils/alert_banner_utils.dart';
import 'package:flutter/material.dart';

import 'package:flutter/scheduler.dart';
import 'package:google_fonts/google_fonts.dart';

class LoginScreen extends StatefulWidget {
  const LoginScreen({super.key});

  @override
  State<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();
  bool isLoading = false;

  @override
  void dispose() {
    _emailController.dispose();
    _passwordController.dispose();
    super.dispose();
  }

  @override
  void initState() {
    super.initState();
    SchedulerBinding.instance.addPostFrameCallback((_) async {
      setState(() {
        isLoading = true;
      });

      await ApiUtils.loadClientToken();

      if (!mounted) {
        return;
      }

      if (!ApiUtils.isLoggedIn()) {
        setState(() {
          isLoading = false;
        });
        return;
      }

      final account = await AuthApi.getMe();
      if (account == Account.none) {
        AuthApi.logout();
        setState(() {
          isLoading = false;
        });
        return;
      }

      if (!mounted) {
        return;
      }

      AccountStatic.setByAccount(account);

      Navigator.pushReplacementNamed(context, RouteConstants.books);
      navIndexNotifier.value = 0;
    });
  }

  void _onLoginPressed() async {
    if (!context.mounted || isLoading) {
      return;
    }

    setState(() {
      isLoading = true;
    });

    if (_emailController.text.isEmpty) {
      AlertBannerUtils.showAlertBanner(
        context,
        message: 'Email can\'t be empty',
        alertType: AlertBannerType.error,
      );
      setState(() {
        isLoading = false;
      });
      return;
    }
    if (_passwordController.text.isEmpty) {
      AlertBannerUtils.showAlertBanner(
        context,
        message: 'Password can\'t be empty',
        alertType: AlertBannerType.error,
      );
      setState(() {
        isLoading = false;
      });
      return;
    }

    bool isLoggedIn = await AuthApi.login(
      _emailController.text,
      _passwordController.text,
    );

    if (!mounted) {
      return;
    }

    if (!isLoggedIn) {
      AlertBannerUtils.showAlertBanner(
        context,
        message: 'Email or password isn\'t valid',
        alertType: AlertBannerType.error,
      );
      setState(() {
        isLoading = false;
      });
      return;
    }

    final account = await AuthApi.getMe();
    AccountStatic.setByAccount(account);

    if (!mounted) {
      return;
    }

    Navigator.pushReplacementNamed(context, RouteConstants.books);
    navIndexNotifier.value = 0;

    setState(() {
      isLoading = false;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 16.0),
          child: Center(
            child: Container(
              width: double.infinity,
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(12),
                boxShadow: [
                  BoxShadow(
                    color: Colors.black45,
                    offset: Offset(0, 1),
                    blurRadius: 2,
                  ),
                ],
              ),
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Padding(
                    padding: const EdgeInsets.all(16.0),
                    child: Text(
                      'Login ke \n${AppConstants.appName}',
                      style: GoogleFonts.poppins(
                        fontSize: 24,
                        fontWeight: FontWeight.w600,
                        color: Colors.black,
                      ),
                      textAlign: TextAlign.center,
                    ),
                  ),
                  Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 16.0),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.end,
                      children: [
                        _buildInputField(
                          label: 'Email',
                          controller: _emailController,
                          isPassword: false,
                        ),
                        const SizedBox(height: 24),
                        _buildInputField(
                          label: 'Password',
                          controller: _passwordController,
                          isPassword: true,
                        ),
                        const SizedBox(height: 12),
                        Text.rich(
                          TextSpan(
                            children: [
                              TextSpan(text: 'Belum punya akun? '),
                              TextSpan(
                                text: 'register ',
                                style: GoogleFonts.poppins(
                                  fontWeight: FontWeight.w600,
                                  color: Colors.deepOrangeAccent,
                                ),
                                recognizer:
                                    TapGestureRecognizer()
                                      ..onTap = () {
                                        Navigator.pushReplacementNamed(
                                          context,
                                          RouteConstants.register,
                                        );
                                      },
                              ),
                              TextSpan(text: 'aja!'),
                            ],
                            style: GoogleFonts.poppins(
                              fontSize: 14,
                              fontWeight: FontWeight.w500,
                              color: Colors.black,
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                  Padding(
                    padding: const EdgeInsets.all(35.0),
                    child: SizedBox(
                      width: 200,
                      child: ElevatedButton(
                        onPressed: _onLoginPressed,
                        style: ElevatedButton.styleFrom(
                          backgroundColor: Colors.deepOrangeAccent,
                          padding: const EdgeInsets.symmetric(
                            vertical: 10,
                            horizontal: 60,
                          ),
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(8),
                          ),
                        ),
                        child:
                            isLoading
                                ? Center(
                                  child: CircularProgressIndicator(
                                    color: Colors.white,
                                  ),
                                )
                                : Text(
                                  'Login',
                                  style: GoogleFonts.poppins(
                                    fontSize: 20,
                                    fontWeight: FontWeight.w600,
                                    color: Colors.white,
                                  ),
                                ),
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildInputField({
    required String label,
    required TextEditingController controller,
    required bool isPassword,
  }) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          label,
          style: GoogleFonts.poppins(
            fontSize: 16,
            fontWeight: FontWeight.w400,
            color: Colors.black,
          ),
        ),
        const SizedBox(height: 8),
        TextField(
          controller: controller,
          obscureText: isPassword,
          decoration: InputDecoration(
            enabledBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(8),
              borderSide: BorderSide(color: Colors.black, width: 1.5),
            ),
            focusedBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(8),
              borderSide: BorderSide(
                color: Colors.deepOrangeAccent,
                width: 1.5,
              ),
            ),
            fillColor: Colors.black12,
            contentPadding: const EdgeInsets.symmetric(
              horizontal: 16,
              vertical: 20,
            ),
          ),
        ),
      ],
    );
  }
}
