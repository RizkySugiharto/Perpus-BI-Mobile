import 'package:perpus_bi/data/models/loan_model.dart';
import 'package:perpus_bi/data/providers/loans_api.dart';
import 'package:perpus_bi/presentation/widgets/header_widget.dart';
import 'package:perpus_bi/presentation/widgets/loan_list_widget.dart';
import 'package:perpus_bi/presentation/widgets/navbar_widget.dart';
import 'package:perpus_bi/presentation/widgets/screen_label_widget.dart';
import 'package:flutter/material.dart';
import 'package:flutter/scheduler.dart';

class LoansScreen extends StatefulWidget {
  const LoansScreen({super.key});

  @override
  State<LoansScreen> createState() => _LoansScreenState();
}

class _LoansScreenState extends State<LoansScreen> {
  List<Loan> _loans = [];
  bool isLoading = true;

  @override
  void initState() {
    super.initState();
    SchedulerBinding.instance.addPostFrameCallback((_) {
      _loadAllLoans();
    });
  }

  Future<void> _loadAllLoans() async {
    setState(() {
      isLoading = true;
    });

    _loans = await LoansApi.getAllLoans();

    if (!mounted) {
      return;
    }
    setState(() {
      isLoading = false;
    });
  }

  Future<void> _onRefresh() async {
    await _loadAllLoans();
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
                          ScreenLabelWidget(label: 'Histori Peminjaman'),
                          isLoading
                              ? Padding(
                                padding: const EdgeInsets.all(32.0),
                                child: Center(
                                  child: CircularProgressIndicator(),
                                ),
                              )
                              : LoanListWidget(loans: _loans),
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
}
