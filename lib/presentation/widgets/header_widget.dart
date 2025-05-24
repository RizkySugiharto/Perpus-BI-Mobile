import 'package:perpus_bi/data/constants/app_constants.dart';
import 'package:perpus_bi/data/constants/route_constants.dart';
import 'package:perpus_bi/data/providers/auth_api.dart';
import 'package:perpus_bi/data/static/account_static.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

class HeaderWidget extends StatelessWidget {
  final bool showScanner;

  const HeaderWidget({super.key, this.showScanner = true});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 20),
      decoration: BoxDecoration(
        color: Colors.white,
        boxShadow: [
          BoxShadow(
            color: Colors.black26,
            blurRadius: 4,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: Row(
        children: [
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                AppConstants.appName,
                style: GoogleFonts.poppins(
                  fontSize: 18,
                  fontWeight: FontWeight.w600,
                ),
              ),
              Text(
                AccountStatic.email,
                style: GoogleFonts.poppins(fontSize: 14, color: Colors.black54),
              ),
            ],
          ),
          Spacer(),
          IconButton(
            onPressed: () {
              AuthApi.logout();
              Navigator.pushNamedAndRemoveUntil(
                context,
                RouteConstants.login,
                ModalRoute.withName(''),
              );
            },
            icon: Icon(Icons.logout_rounded, size: 26),
          ),
        ],
      ),
    );
  }
}
