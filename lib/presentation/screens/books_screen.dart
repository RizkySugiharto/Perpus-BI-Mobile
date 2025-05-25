import 'package:perpus_bi/data/models/book_model.dart';
import 'package:perpus_bi/data/providers/books_api.dart';
import 'package:perpus_bi/presentation/widgets/header_widget.dart';
import 'package:perpus_bi/presentation/widgets/navbar_widget.dart';
import 'package:perpus_bi/presentation/widgets/book_list_widget.dart';
import 'package:perpus_bi/presentation/widgets/screen_label_widget.dart';
import 'package:flutter/material.dart';
import 'package:flutter/scheduler.dart';
import 'package:perpus_bi/presentation/widgets/search_bar_widget.dart';

class BooksScreen extends StatefulWidget {
  const BooksScreen({super.key});

  @override
  State<BooksScreen> createState() => _BooksScreenState();
}

class _BooksScreenState extends State<BooksScreen> {
  final TextEditingController _searchController = TextEditingController();
  List<Book> _books = [];
  bool isLoading = true;

  @override
  void initState() {
    super.initState();
    SchedulerBinding.instance.addPostFrameCallback((_) {
      _loadAllBooks();
    });
  }

  @override
  void dispose() {
    _searchController.dispose();
    super.dispose();
  }

  Future<void> _loadAllBooks() async {
    setState(() {
      isLoading = true;
    });

    _books = await BooksApi.getAllBooks(search: _searchController.text);

    if (!mounted) {
      return;
    }
    setState(() {
      isLoading = false;
    });
  }

  Future<void> _onRefresh() async {
    await _loadAllBooks();
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
                          ScreenLabelWidget(label: 'Daftar Buku'),
                          SearchBarWidget(
                            searchController: _searchController,
                            hintText: 'Cari buku....',
                            onSubmitted: (submitted) {
                              _loadAllBooks();
                            },
                          ),
                          isLoading
                              ? Padding(
                                padding: const EdgeInsets.all(32.0),
                                child: Center(
                                  child: CircularProgressIndicator(),
                                ),
                              )
                              : BookListWidget(books: _books),
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
