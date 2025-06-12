import 'package:google_fonts/google_fonts.dart';
import 'package:perpus_bi/data/constants/route_constants.dart';
import 'package:perpus_bi/data/models/book_model.dart';
import 'package:perpus_bi/data/notifiers/alert_notifiers.dart';
import 'package:perpus_bi/data/providers/books_api.dart';
import 'package:perpus_bi/presentation/utils/alert_banner_utils.dart';
import 'package:perpus_bi/presentation/widgets/header_widget.dart';
import 'package:perpus_bi/presentation/widgets/navbar_widget.dart';
import 'package:perpus_bi/presentation/widgets/screen_label_widget.dart';
import 'package:flutter/material.dart';
import 'package:flutter/scheduler.dart';

class BookDetailsScreen extends StatefulWidget {
  const BookDetailsScreen({super.key});

  @override
  State<BookDetailsScreen> createState() => _BookDetailsScreenState();
}

class _BookDetailsScreenState extends State<BookDetailsScreen> {
  Book _book = Book.none;
  bool _isLoading = false;

  @override
  void initState() {
    super.initState();
    SchedulerBinding.instance.addPostFrameCallback((_) {
      _loadBook();
    });
  }

  void _onRequestPressed() {
    Navigator.pushNamed(
      context,
      RouteConstants.loanForm,
      arguments: _book.bookId,
    );
  }

  Future<void> _loadBook() async {
    setState(() {
      _isLoading = true;
    });

    int bookId = ModalRoute.of(context)?.settings.arguments as int;
    _book = await BooksApi.getSingleBook(bookId);

    if (!mounted) {
      return;
    }

    if (_book == Book.none) {
      AlertBannerUtils.popWithAlertBanner(
        context,
        message: "Data buku tidak ditemukan.",
        alertType: AlertBannerType.error,
      );
      return;
    }

    setState(() {
      _isLoading = false;
    });
  }

  Future<void> _onRefresh() async {
    await _loadBook();
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
                            label: 'Detail Buku',
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
                                        Text(
                                          _book.title,
                                          style: GoogleFonts.poppins(
                                            fontSize: 24,
                                            fontWeight: FontWeight.w600,
                                          ),
                                        ),
                                        const SizedBox(height: 12),
                                        Text(
                                          'Pengarang: ${_book.author}',
                                          style: GoogleFonts.poppins(
                                            fontSize: 16,
                                          ),
                                        ),
                                        Text(
                                          'Penerbit: ${_book.publisher}',
                                          style: GoogleFonts.poppins(
                                            fontSize: 16,
                                          ),
                                        ),
                                        Text(
                                          'Tahun Terbit: ${_book.publishedYear}',
                                          style: GoogleFonts.poppins(
                                            fontSize: 16,
                                          ),
                                        ),
                                        const SizedBox(height: 12),
                                        Text(
                                          'Stok: ${_book.stock}',
                                          style: GoogleFonts.poppins(
                                            fontSize: 16,
                                            fontWeight: FontWeight.w600,
                                            color: Colors.deepOrangeAccent,
                                          ),
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
                                  backgroundColor:
                                      !_isLoading && _book.stock > 0
                                          ? Colors.deepOrangeAccent
                                          : Colors.black54,
                                  foregroundColor: Colors.white,
                                  overlayColor: Colors.black38,
                                ),
                                onPressed:
                                    !_isLoading && _book.stock > 0
                                        ? _onRequestPressed
                                        : () {},
                                child: Text(
                                  'Request Peminjaman',
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
