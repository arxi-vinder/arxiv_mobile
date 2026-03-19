import 'package:arxivinder/blocs/papers/detail/detail_paper_bloc.dart';
import 'package:arxivinder/blocs/papers/detail/detail_paper_event.dart';
import 'package:arxivinder/blocs/papers/detail/state_paper_detail_bloc.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class DetailPaperScreen extends StatefulWidget {
  final int id;
  const DetailPaperScreen({super.key, required this.id});

  @override
  State<StatefulWidget> createState() {
    return DetailPaperState();
  }
}

class DetailPaperState extends State<DetailPaperScreen> {
  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      context.read<DetailPaperBloc>().add(GetDetailPaper(widget.id));
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: BlocBuilder<DetailPaperBloc, StatePaperDetailBloc>(
        builder: (context, state) {
          if (state is PaperDetailLoading) {
            return const Center(child: CircularProgressIndicator());
          }

          if (state is PaperDetailError) {
            return Center(child: Text(state.message));
          }

          if (state is PaperDetailLoaded) {
            final paper = state.paper;

            return SingleChildScrollView(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  /// HEADER
                  Container(
                    width: double.infinity,
                    height: 110,
                    padding: const EdgeInsets.symmetric(horizontal: 16),
                    decoration: const BoxDecoration(
                      gradient: LinearGradient(
                        begin: Alignment.topCenter,
                        end: Alignment.bottomCenter,
                        colors: [Color(0xff2f6ea9), Color(0xff4f88c2)],
                      ),
                      borderRadius: BorderRadius.only(
                        bottomLeft: Radius.circular(25),
                        bottomRight: Radius.circular(25),
                      ),
                    ),
                    child: SafeArea(
                      child: Stack(
                        alignment: Alignment.center,
                        children: [
                          Align(
                            alignment: Alignment.centerLeft,
                            child: IconButton(
                              icon: const Icon(
                                Icons.arrow_back,
                                color: Colors.white,
                              ),
                              onPressed: () {
                                Navigator.pop(context);
                              },
                            ),
                          ),
                          const Text(
                            "Detail Karya Ilmiah",
                            style: TextStyle(
                              color: Colors.white,
                              fontSize: 22,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),

                  const SizedBox(height: 24),

                  /// TITLE
                  Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 16),
                    child: Text(
                      paper.title,
                      style: const TextStyle(
                        fontSize: 26,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ),

                  const SizedBox(height: 16),

                  Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 16),
                    child: Text(
                      "Author: ${paper.author}",
                      style: const TextStyle(
                        fontSize: 16,
                        fontWeight: FontWeight.w500,
                      ),
                    ),
                  ),

                  const SizedBox(height: 8),

                  Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 16),
                    child: Text(
                      "Category: ${paper.category}",
                      style: const TextStyle(fontSize: 16),
                    ),
                  ),
                  const SizedBox(height: 8),

                  Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 16),
                    child: Text(
                      "URL: ${paper.url}",
                      style: const TextStyle(fontSize: 16),
                    ),
                  ),
                  const SizedBox(height: 8),

                  Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 16),
                    child: Text(
                      "ID: ${paper.id}",
                      style: const TextStyle(fontSize: 16),
                    ),
                  ),

                  
                  Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 16),
                    child: Text(
                      paper.abstract,
                      style: const TextStyle(fontSize: 18, height: 1.6),
                    ),
                  ),

                  const SizedBox(height: 30),
                ],
              ),
            );
          }

          
          return const Center(child: Text("Memuat data..."));
        },
      ),
    );
  }
}
