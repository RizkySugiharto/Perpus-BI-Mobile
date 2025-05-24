import 'package:google_fonts/google_fonts.dart';
import 'package:intl/intl.dart';
import 'package:perpus_bi/data/models/loan_model.dart';
import 'package:perpus_bi/data/notifiers/alert_notifiers.dart';
import 'package:perpus_bi/data/providers/loans_api.dart';
import 'package:perpus_bi/presentation/utils/alert_banner_utils.dart';
import 'package:perpus_bi/presentation/widgets/header_widget.dart';
import 'package:perpus_bi/presentation/widgets/input_text_widget.dart';
import 'package:perpus_bi/presentation/widgets/navbar_widget.dart';
import 'package:perpus_bi/presentation/widgets/screen_label_widget.dart';
import 'package:flutter/material.dart';
import 'package:flutter/scheduler.dart';

class LoanFormScreen extends StatefulWidget {
  const LoanFormScreen({super.key});

  @override
  State<LoanFormScreen> createState() => _LoanFormScreenState();
}

class _LoanFormScreenState extends State<LoanFormScreen> {
  final TextEditingController _loanDateController = TextEditingController();
  final TextEditingController _returnDateController = TextEditingController();
  int _bookId = 0;

  @override
  void initState() {
    super.initState();
    SchedulerBinding.instance.addPostFrameCallback((_) {
      _fecthBookId();
    });
  }

  void _fecthBookId() async {
    _bookId = ModalRoute.of(context)?.settings.arguments as int;
    setState(() {});
  }

  bool _isAllFieldFilled() {
    return _loanDateController.text.isNotEmpty &&
        _returnDateController.text.isNotEmpty;
  }

  Future<void> _onSendRequestPressed() async {
    if (!_isAllFieldFilled()) {
      AlertBannerUtils.showAlertBanner(
        context,
        message: 'Mohon isi semuanya.',
        alertType: AlertBannerType.error,
      );
      return;
    }

    DateFormat dateParser = DateFormat('yyyy-MM-dd');
    DateTime? loanDate = dateParser.tryParse(_loanDateController.text);
    DateTime? returnDate = dateParser.tryParse(_returnDateController.text);

    if (loanDate == null || returnDate == null) {
      AlertBannerUtils.showAlertBanner(
        context,
        message: 'Mohon isi sesuai format.',
        alertType: AlertBannerType.error,
      );
      return;
    }

    Loan newLoan = await LoansApi.post(
      bookId: _bookId,
      loanDate: _loanDateController.text,
      returnDate: _returnDateController.text,
    );

    if (!mounted) {
      return;
    }

    if (newLoan != Loan.none) {
      AlertBannerUtils.popWithAlertBanner(
        context,
        message: 'Permintaan peminjaman buku berhasil dikirim',
        alertType: AlertBannerType.success,
      );
    } else {
      AlertBannerUtils.showAlertBanner(
        context,
        message: 'Gagal meminjam. Coba lagi.',
        alertType: AlertBannerType.error,
      );
    }
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
                  child: SingleChildScrollView(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        ScreenLabelWidget(
                          label: 'Form Peminjaman',
                          canGoBack: true,
                        ),
                        Container(
                          width: double.infinity,
                          decoration: BoxDecoration(
                            color: Colors.white,
                            borderRadius: BorderRadius.circular(8),
                          ),
                          margin: const EdgeInsets.all(16),
                          padding: const EdgeInsets.all(16),
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              InputTextWidget(
                                label: 'ID Buku',
                                textController: TextEditingController(
                                  text: _bookId.toString(),
                                ),
                                readOnly: true,
                              ),
                              const SizedBox(height: 10),
                              InputTextWidget(
                                label: 'Tanggal Peminjaman (yyyy-mm-dd)',
                                textController: _loanDateController,
                                hint: '1999-12-30',
                              ),
                              const SizedBox(height: 10),
                              InputTextWidget(
                                label: 'Tanggal Pengembalian (yyyy-mm-dd)',
                                textController: _returnDateController,
                                hint: '1999-12-30',
                              ),
                            ],
                          ),
                        ),
                        Padding(
                          padding: const EdgeInsets.all(16),
                          child: SizedBox(
                            width: double.infinity,
                            child: ElevatedButton(
                              style: ElevatedButton.styleFrom(
                                padding: const EdgeInsets.all(14),
                                shape: RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(8),
                                ),
                                backgroundColor: Colors.deepOrangeAccent,
                                foregroundColor: Colors.white,
                                overlayColor: Colors.black38,
                              ),
                              onPressed: _onSendRequestPressed,
                              child: Text(
                                'Kirim Request',
                                style: GoogleFonts.poppins(
                                  fontSize: 16,
                                  fontWeight: FontWeight.w600,
                                ),
                              ),
                            ),
                          ),
                        ),
                      ],
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
}
