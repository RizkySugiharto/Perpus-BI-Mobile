import 'package:google_fonts/google_fonts.dart';
import 'package:intl/intl.dart';
import 'package:perpus_bi/data/models/loan_model.dart';
import 'package:perpus_bi/data/providers/loans_api.dart';
import 'package:perpus_bi/presentation/widgets/header_widget.dart';
import 'package:perpus_bi/presentation/widgets/navbar_widget.dart';
import 'package:perpus_bi/presentation/widgets/screen_label_widget.dart';
import 'package:flutter/material.dart';
import 'package:flutter/scheduler.dart';

class LoanDetailsScreen extends StatefulWidget {
  const LoanDetailsScreen({super.key});

  @override
  State<LoanDetailsScreen> createState() => _LoanDetailsScreenState();
}

class _LoanDetailsScreenState extends State<LoanDetailsScreen> {
  final dateFormatter = DateFormat('yyyy-MM-dd');
  Loan _loan = Loan.none;

  @override
  void initState() {
    super.initState();
    SchedulerBinding.instance.addPostFrameCallback((_) {
      _loadLoan();
    });
  }

  Future<void> _loadLoan() async {
    int loanId = ModalRoute.of(context)?.settings.arguments as int;
    _loan = await LoansApi.getSingleLoan(loanId);

    if (!mounted) {
      return;
    }
    setState(() {});
  }

  Future<void> _onRefresh() async {
    await _loadLoan();
  }

  String _getLoanStatus() {
    if (_loan.taken && _loan.returned) {
      return 'Dikembalian';
    } else if (_loan.taken) {
      return 'Dipinjamkan';
    } else {
      return 'Menunggu';
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
                  child: RefreshIndicator(
                    onRefresh: _onRefresh,
                    child: SingleChildScrollView(
                      physics: AlwaysScrollableScrollPhysics(),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          ScreenLabelWidget(
                            label: 'Detail Peminjaman',
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
                              spacing: 16,
                              children: [
                                _buildItemData(
                                  'ID Peminjaman',
                                  _loan.loanId.toString(),
                                ),
                                _buildItemData(
                                  'ID Buku',
                                  _loan.bookId.toString(),
                                ),
                                _buildItemData(
                                  'Tanggal Peminjaman',
                                  dateFormatter.format(_loan.loanDate),
                                ),
                                _buildItemData(
                                  'Tanggal Pengembalian',
                                  dateFormatter.format(_loan.returnDate),
                                ),
                                _buildItemData('Status', _getLoanStatus()),
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

  Widget _buildItemData(String label, String value) {
    return SizedBox(
      width: double.infinity,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            label,
            style: GoogleFonts.poppins(
              fontSize: 16,
              fontWeight: FontWeight.w600,
            ),
          ),
          const SizedBox(height: 4),
          Container(
            width: double.infinity,
            decoration: BoxDecoration(
              color: Colors.black12,
              borderRadius: BorderRadius.circular(6),
              border: Border.all(color: Colors.black, width: 1),
            ),
            padding: const EdgeInsets.symmetric(vertical: 6, horizontal: 12),
            child: Text(value, style: GoogleFonts.poppins(fontSize: 16)),
          ),
        ],
      ),
    );
  }
}
