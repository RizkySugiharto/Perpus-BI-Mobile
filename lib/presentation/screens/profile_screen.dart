import 'package:email_validator/email_validator.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:perpus_bi/data/models/account_model.dart';
import 'package:perpus_bi/data/notifiers/alert_notifiers.dart';
import 'package:perpus_bi/data/providers/auth_api.dart';
import 'package:perpus_bi/data/static/account_static.dart';
import 'package:perpus_bi/presentation/utils/alert_banner_utils.dart';
import 'package:perpus_bi/presentation/widgets/header_widget.dart';
import 'package:perpus_bi/presentation/widgets/input_text_widget.dart';
import 'package:perpus_bi/presentation/widgets/navbar_widget.dart';
import 'package:perpus_bi/presentation/widgets/screen_label_widget.dart';
import 'package:flutter/material.dart';
import 'package:flutter/scheduler.dart';

class ProfileScreen extends StatefulWidget {
  const ProfileScreen({super.key});

  @override
  State<ProfileScreen> createState() => _ProfileScreenState();
}

class _ProfileScreenState extends State<ProfileScreen> {
  final TextEditingController _emailController = TextEditingController();
  Account _account = Account.none;
  bool _isSaving = false;
  bool _isLoading = false;

  @override
  void initState() {
    super.initState();
    SchedulerBinding.instance.addPostFrameCallback((_) {
      _loadProfile();
    });
  }

  Future<void> _onSaveButtonPressed() async {
    if (_emailController.text.isEmpty) {
      return AlertBannerUtils.showAlertBanner(
        context,
        message: 'Field email tidak boleh kosong.',
        alertType: AlertBannerType.error,
      );
    } else if (!EmailValidator.validate(_emailController.text)) {
      return AlertBannerUtils.showAlertBanner(
        context,
        message: 'Email tidak valid. Coba gunakan email lainnya.',
        alertType: AlertBannerType.error,
      );
    }

    setState(() {
      _isSaving = true;
    });

    _account = await AuthApi.patchMe(email: _emailController.text);

    if (!mounted) {
      return;
    }

    if (_account == Account.none) {
      AlertBannerUtils.showAlertBanner(
        context,
        message: 'Gagal menyimpan data. Coba Lagi.',
        alertType: AlertBannerType.error,
      );
    } else {
      _emailController.text = _account.email;
      AccountStatic.setByAccount(_account);

      AlertBannerUtils.showAlertBanner(
        context,
        message: 'Berhasil menyimpan data profil',
        alertType: AlertBannerType.success,
      );
    }

    _emailController.text = _account.email;
    AccountStatic.setByAccount(_account);

    setState(() {
      _isSaving = false;
    });
  }

  Future<void> _loadProfile() async {
    setState(() {
      _isLoading = true;
    });

    _account = await AuthApi.getMe();

    if (!mounted) {
      return;
    }

    if (_account == Account.none) {
      AlertBannerUtils.showAlertBanner(
        context,
        message: 'Gagal mengambil data. Coba Lagi.',
        alertType: AlertBannerType.error,
      );
    } else {
      _emailController.text = _account.email;
      AccountStatic.setByAccount(_account);
    }

    setState(() {
      _isLoading = false;
    });
  }

  Future<void> _onRefresh() async {
    await _loadProfile();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: Stack(
          alignment: Alignment.bottomCenter,
          children: [
            Column(
              children: [
                HeaderWidget(),
                Expanded(
                  child: RefreshIndicator(
                    onRefresh: _onRefresh,
                    child: SingleChildScrollView(
                      physics: AlwaysScrollableScrollPhysics(),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          ScreenLabelWidget(label: 'Profil Saya'),
                          Container(
                            width: double.infinity,
                            decoration: BoxDecoration(
                              color: Colors.white,
                              borderRadius: BorderRadius.circular(8),
                            ),
                            margin: const EdgeInsets.all(16),
                            padding: const EdgeInsets.all(16),
                            child:
                                _isLoading
                                    ? Padding(
                                      padding: const EdgeInsets.all(32.0),
                                      child: Center(
                                        child: CircularProgressIndicator(),
                                      ),
                                    )
                                    : Column(
                                      crossAxisAlignment:
                                          CrossAxisAlignment.start,
                                      children: [
                                        InputTextWidget(
                                          label: 'ID Akun',
                                          textController: TextEditingController(
                                            text: _account.accountId.toString(),
                                          ),
                                          readOnly: true,
                                        ),
                                        const SizedBox(height: 12),
                                        InputTextWidget(
                                          label: 'Email',
                                          textController: _emailController,
                                        ),
                                        const SizedBox(height: 12),
                                        InputTextWidget(
                                          label: 'Role',
                                          textController: TextEditingController(
                                            text: _account.role,
                                          ),
                                          readOnly: true,
                                        ),
                                        const SizedBox(height: 22),
                                        _buildSaveButton(),
                                      ],
                                    ),
                          ),
                        ],
                      ),
                    ),
                  ),
                ),
                NavbarWidget(),
              ],
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildSaveButton() {
    return Align(
      alignment: Alignment.bottomRight,
      child: ElevatedButton.icon(
        onPressed: _isSaving || _isLoading ? null : _onSaveButtonPressed,
        icon: Icon(
          _isSaving ? Icons.hourglass_empty_outlined : Icons.save_outlined,
          size: 28,
          color: Colors.black,
        ),
        label: Text(
          _isSaving ? 'Menyimpan...' : 'Simpan',
          style: GoogleFonts.poppins(color: Colors.black, fontSize: 16),
        ),
        style: ElevatedButton.styleFrom(
          padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 6),
          backgroundColor: _isLoading ? Colors.grey : Colors.white,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(8),
            side: BorderSide(color: Colors.black, width: 1.5),
          ),
        ),
      ),
    );
  }
}
