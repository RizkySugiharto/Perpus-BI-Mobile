import 'package:email_validator/email_validator.dart';
import 'package:flutter/gestures.dart';
import 'package:intl/intl.dart';
import 'package:perpus_bi/data/constants/route_constants.dart';
import 'package:perpus_bi/data/notifiers/alert_notifiers.dart';
import 'package:perpus_bi/data/providers/auth_api.dart';
import 'package:perpus_bi/presentation/utils/alert_banner_utils.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:perpus_bi/presentation/widgets/input_select_widget.dart';
import 'package:perpus_bi/presentation/widgets/input_text_widget.dart';

class RegisterScreen extends StatefulWidget {
  const RegisterScreen({super.key});

  @override
  State<RegisterScreen> createState() => _RegisterScreenState();
}

class _RegisterScreenState extends State<RegisterScreen> {
  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();
  final TextEditingController _NIMController = TextEditingController();
  final TextEditingController _nameController = TextEditingController();
  final TextEditingController _classNameController = TextEditingController();
  final TextEditingController _addressController = TextEditingController();
  final TextEditingController _birthdateController = TextEditingController();
  String? _selectedGender;
  bool isLoading = false;

  @override
  void dispose() {
    _emailController.dispose();
    _passwordController.dispose();
    _NIMController.dispose();
    _nameController.dispose();
    _classNameController.dispose();
    _addressController.dispose();
    _birthdateController.dispose();
    super.dispose();
  }

  bool _isAllFieldFilled() {
    return _emailController.text.isNotEmpty &&
        _passwordController.text.isNotEmpty &&
        _NIMController.text.isNotEmpty &&
        _nameController.text.isNotEmpty &&
        _classNameController.text.isNotEmpty &&
        _addressController.text.isNotEmpty &&
        _birthdateController.text.isNotEmpty &&
        (_selectedGender?.isNotEmpty ?? false);
  }

  void _onRegisterPressed() async {
    if (isLoading) {
      return;
    }

    setState(() {
      isLoading = true;
    });

    if (!_isAllFieldFilled()) {
      AlertBannerUtils.showAlertBanner(
        context,
        message: 'Mohon isi semuanya',
        alertType: AlertBannerType.error,
      );
      setState(() {
        isLoading = false;
      });
      return;
    } else if (!EmailValidator.validate(_emailController.text)) {
      AlertBannerUtils.showAlertBanner(
        context,
        message: 'Email tidak valid. Coba gunakan email lainnya.',
        alertType: AlertBannerType.error,
      );
      setState(() {
        isLoading = false;
      });
      return;
    } else if (_passwordController.text.length < 8) {
      AlertBannerUtils.showAlertBanner(
        context,
        message: 'Password harus terdiri dari 8 huruf atau lebih',
        alertType: AlertBannerType.error,
      );
      setState(() {
        isLoading = false;
      });
      return;
    }

    DateFormat dateParser = DateFormat('yyyy-MM-dd');
    DateTime? birthdate = dateParser.tryParse(_birthdateController.text);

    if (birthdate == null) {
      AlertBannerUtils.showAlertBanner(
        context,
        message: 'Mohon isi tanggal lahir sesuai format',
        alertType: AlertBannerType.error,
      );
      setState(() {
        isLoading = false;
      });
      return;
    }

    bool isSuccess = await AuthApi.register(
      email: _emailController.text,
      password: _passwordController.text,
      NIM: _NIMController.text,
      name: _nameController.text,
      className: _classNameController.text,
      address: _addressController.text,
      birthdate: _birthdateController.text,
      gender: _selectedGender ?? '',
    );

    if (!mounted) {
      return;
    }

    if (!isSuccess) {
      AlertBannerUtils.showAlertBanner(
        context,
        message: 'Gagal. Mohon cek kembali formatnya.',
        alertType: AlertBannerType.error,
      );
      setState(() {
        isLoading = false;
      });
      return;
    }

    AlertBannerUtils.popWithAlertBanner(
      context,
      message: 'Yayy berhasil. Hubungi admin untuk aktivasi akunmu.',
      alertType: AlertBannerType.success,
    );
    Navigator.pushNamed(context, RouteConstants.login);

    setState(() {
      isLoading = false;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: SingleChildScrollView(
          child: Center(
            child: Container(
              width: double.infinity,
              margin: const EdgeInsets.all(16),
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
                      'Registrasi Akun',
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
                        InputTextWidget(
                          label: 'Email',
                          textController: _emailController,
                        ),
                        const SizedBox(height: 24),
                        InputTextWidget(
                          label: 'Password',
                          textController: _passwordController,
                          obscureText: true,
                        ),
                        const SizedBox(height: 24),
                        InputTextWidget(
                          label: 'NIM',
                          textController: _NIMController,
                        ),
                        const SizedBox(height: 24),
                        InputTextWidget(
                          label: 'Nama',
                          textController: _nameController,
                        ),
                        const SizedBox(height: 24),
                        InputTextWidget(
                          label: 'Kelas',
                          textController: _classNameController,
                        ),
                        const SizedBox(height: 24),
                        InputTextWidget(
                          label: 'Alamat',
                          textController: _addressController,
                          multiLine: true,
                        ),
                        const SizedBox(height: 24),
                        InputTextWidget(
                          label: 'Tanggal Lahir (yyyy-mm-dd)',
                          textController: _birthdateController,
                        ),
                        const SizedBox(height: 24),
                        InputSelectWidget(
                          label: 'Jenis Kelamin',
                          options: ['Laki-Laki', 'Perempuan'],
                          value: _selectedGender,
                          onChanged: (value) {
                            setState(() {
                              _selectedGender = value;
                            });
                          },
                        ),
                        const SizedBox(height: 12),
                        Text.rich(
                          TextSpan(
                            children: [
                              TextSpan(text: 'Udah punya akun? '),
                              TextSpan(
                                text: 'login ',
                                style: GoogleFonts.poppins(
                                  fontWeight: FontWeight.w600,
                                  color: Colors.deepOrangeAccent,
                                ),
                                recognizer:
                                    TapGestureRecognizer()
                                      ..onTap = () {
                                        Navigator.pushReplacementNamed(
                                          context,
                                          RouteConstants.login,
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
                      width: 260,
                      child: ElevatedButton(
                        onPressed: _onRegisterPressed,
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
                                  'Register',
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
}
