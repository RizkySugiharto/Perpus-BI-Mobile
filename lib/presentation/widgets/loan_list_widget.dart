import 'package:intl/intl.dart';
import 'package:perpus_bi/data/constants/route_constants.dart';
import 'package:perpus_bi/data/models/loan_model.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

class LoanListWidget extends StatefulWidget {
  final List<Loan> loans;
  final void Function(Set<Loan>)? onChanged;

  const LoanListWidget({super.key, required this.loans, this.onChanged});

  @override
  State<LoanListWidget> createState() => _LoanListWidgetState();
}

class _LoanListWidgetState extends State<LoanListWidget> {
  @override
  Widget build(BuildContext context) {
    return ListView.builder(
      physics: const NeverScrollableScrollPhysics(),
      scrollDirection: Axis.vertical,
      shrinkWrap: true,
      padding: const EdgeInsets.all(16),
      itemCount: widget.loans.length,
      itemBuilder: (context, index) {
        final loan = widget.loans[index];
        return Column(
          children: [_buildLoanItem(loan), const SizedBox(height: 16)],
        );
      },
    );
  }

  Widget _buildLoanItem(Loan loan) {
    final DateFormat dateFormatter = DateFormat('yyyy-MM-dd');

    return SizedBox(
      width: double.infinity,
      child: InkWell(
        onTap: () {
          Navigator.pushNamed(
            context,
            RouteConstants.loanDetails,
            arguments: loan.loanId,
          );
        },
        borderRadius: BorderRadius.circular(6),
        child: Ink(
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.circular(6),
            boxShadow: [
              BoxShadow(
                color: Colors.black26,
                blurRadius: 4,
                offset: const Offset(0, 2),
              ),
            ],
          ),
          child: Padding(
            padding: const EdgeInsets.all(16),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: <Widget>[
                Row(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text(
                      loan.loanId.toString(),
                      style: GoogleFonts.poppins(
                        fontSize: 18,
                        fontWeight: FontWeight.w500,
                        color: Colors.black,
                      ),
                    ),
                    Icon(
                      Icons.circle,
                      size: 18,
                      color: _getLoanStatusColor(loan),
                    ),
                  ],
                ),
                const SizedBox(height: 6),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text(
                      dateFormatter.format(loan.loanDate),
                      style: GoogleFonts.poppins(
                        fontSize: 14,
                        color: Colors.grey,
                      ),
                    ),
                    Text(
                      dateFormatter.format(loan.returnDate),
                      style: GoogleFonts.poppins(
                        fontSize: 14,
                        color: Colors.grey,
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Color _getLoanStatusColor(Loan loan) {
    if (loan.taken && loan.returned) {
      return Colors.lightGreen;
    } else if (loan.taken) {
      return Colors.red;
    } else {
      return Colors.blue;
    }
  }
}
