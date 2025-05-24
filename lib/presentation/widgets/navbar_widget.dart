import 'package:perpus_bi/data/constants/route_constants.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:perpus_bi/data/notifiers/navbar_notifiers.dart';

class NavbarWidget extends StatelessWidget {
  const NavbarWidget({super.key});

  @override
  Widget build(BuildContext context) {
    return BottomAppBar(
      padding: EdgeInsets.symmetric(vertical: 0, horizontal: 0),
      color: Colors.white,
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceAround,
        children: [
          _buildNavItem(
            context,
            icon: Icons.library_books_outlined,
            label: 'Buku',
            navIndex: 0,
            routeName: RouteConstants.books,
          ),
          _buildNavItem(
            context,
            icon: Icons.history_edu_rounded,
            label: 'Peminjaman',
            navIndex: 1,
            routeName: RouteConstants.loans,
          ),
          _buildNavItem(
            context,
            icon: Icons.person_pin_outlined,
            label: 'Profil',
            navIndex: 2,
            routeName: RouteConstants.profile,
          ),
        ],
      ),
    );
  }

  Widget _buildNavItem(
    BuildContext context, {
    required IconData icon,
    required String label,
    required int navIndex,
    required String routeName,
  }) {
    final bool isSelected = navIndexNotifier.value == navIndex;

    return Expanded(
      child: InkWell(
        onTap: () {
          navIndexNotifier.value = navIndex;
          Navigator.pushNamedAndRemoveUntil(
            context,
            routeName,
            ModalRoute.withName('/'),
          );
        },
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(
              icon,
              color: isSelected ? Colors.deepOrangeAccent : Colors.black,
            ),
            const SizedBox(height: 2),
            Text(
              label,
              style: GoogleFonts.poppins(
                fontSize: 12,
                color: isSelected ? Colors.deepOrangeAccent : Colors.black87,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
