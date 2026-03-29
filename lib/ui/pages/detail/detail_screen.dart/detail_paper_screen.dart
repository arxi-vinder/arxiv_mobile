import 'package:arxivinder/blocs/papers/detail/detail_paper_bloc.dart';
import 'package:arxivinder/blocs/papers/detail/detail_paper_event.dart';
import 'package:arxivinder/blocs/papers/detail/state_paper_detail_bloc.dart';
import 'package:arxivinder/blocs/papers/feedback/feedback_paper_bloc.dart';
import 'package:arxivinder/blocs/papers/feedback/feedback_paper_event.dart';
import 'package:arxivinder/blocs/papers/feedback/state_feedback_paper_bloc.dart';
import 'package:arxivinder/blocs/papers/recommendation/recommender_bloc.dart';
import 'package:arxivinder/blocs/papers/recommendation/recommender_event_bloc.dart';
import 'package:arxivinder/blocs/papers/recommendation/state_recommender_bloc.dart';
import 'package:arxivinder/data/model/feedback_request.dart';
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
      context.read<RecommenderBloc>().add(GetRecommendation(widget.id));
    });
  }

  @override
  Widget build(BuildContext context) {
    return MultiBlocListener(
      listeners: [
        BlocListener<FeedbackPaperBloc, StateFeedbackPaperBloc>(
          listener: (context, state) {
            if (state is FeedbackFailure) {
              ScaffoldMessenger.of(
                context,
              ).showSnackBar(SnackBar(content: Text(state.error)));
            }
          },
        ),
      ],
      child: Scaffold(
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
                        paper.abstract,
                        style: const TextStyle(fontSize: 18, height: 1.6),
                      ),
                    ),

                    const SizedBox(height: 30),

                    Container(
                      width: 438,
                      height: 274,
                      decoration: const BoxDecoration(
                        gradient: LinearGradient(
                          begin: Alignment.topCenter,
                          end: Alignment.bottomCenter,
                          colors: [
                            Color.fromARGB(255, 175, 182, 187),
                            Color.fromARGB(255, 169, 174, 179),
                          ],
                        ),
                      ),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          const Text(
                            "Lebih banyak untuk anda",
                            style: TextStyle(
                              fontSize: 14,
                              fontWeight: FontWeight.w500,
                              fontFamily: "Inter",
                            ),
                          ),

                          BlocBuilder<RecommenderBloc, StateRecommenderBloc>(
                            builder: (context, state) {
                              if (state is InitialLoading) {
                                return const Center(
                                  child: CircularProgressIndicator(),
                                );
                              }

                              if (state is InitialFailure) {
                                return Center(child: Text(state.error));
                              }

                              if (state is InitialSuccess) {
                                return SizedBox(
                                  height: 200,
                                  child: ListView.builder(
                                    scrollDirection: Axis.horizontal,
                                    itemCount: state.papers.length,
                                    itemBuilder: (context, index) {
                                      final recommendation =
                                          state.papers[index];

                                      return Container(
                                        width: 170,
                                        margin: const EdgeInsets.only(
                                          right: 16,
                                        ),
                                        child: Material(
                                          borderRadius: BorderRadius.circular(
                                            12,
                                          ),
                                          elevation: 3,
                                          color: Colors.white,
                                          child: InkWell(
                                            borderRadius: BorderRadius.circular(
                                              12,
                                            ),
                                            onTap: () {},
                                            child: Padding(
                                              padding: const EdgeInsets.all(10),
                                              child: Column(
                                                crossAxisAlignment:
                                                    CrossAxisAlignment.start,
                                                children: [
                                                  Container(
                                                    height: 100,
                                                    decoration: BoxDecoration(
                                                      gradient: LinearGradient(
                                                        colors: [
                                                          Colors.blue.shade100,
                                                          Colors.blue.shade50,
                                                        ],
                                                      ),
                                                      borderRadius:
                                                          BorderRadius.circular(
                                                            10,
                                                          ),
                                                    ),
                                                    child: const Center(
                                                      child: Icon(
                                                        Icons.article_outlined,
                                                        size: 40,
                                                        color: Colors.blue,
                                                      ),
                                                    ),
                                                  ),
                                                  const SizedBox(height: 10),
                                                  Text(
                                                    recommendation.title,
                                                    maxLines: 2,
                                                    overflow:
                                                        TextOverflow.ellipsis,
                                                    style: const TextStyle(
                                                      fontSize: 13,
                                                      fontWeight:
                                                          FontWeight.w600,
                                                    ),
                                                  ),
                                                  const SizedBox(height: 8),
                                                  Container(
                                                    padding:
                                                        const EdgeInsets.symmetric(
                                                          horizontal: 8,
                                                          vertical: 4,
                                                        ),
                                                    decoration: BoxDecoration(
                                                      color: Colors.blue
                                                          .withValues(
                                                            alpha: 0.1,
                                                          ),
                                                      borderRadius:
                                                          BorderRadius.circular(
                                                            6,
                                                          ),
                                                    ),
                                                    child: BlocBuilder<
                                                      FeedbackPaperBloc,
                                                      StateFeedbackPaperBloc
                                                    >(
                                                      builder: (
                                                        context,
                                                        state,
                                                      ) {
                                                        return Row(
                                                          mainAxisSize:
                                                              MainAxisSize.min,
                                                          children: [
                                                            Text(
                                                              'Score ${recommendation.ucbScore.toStringAsFixed(2).replaceAll('.', ',')}',
                                                              style: const TextStyle(
                                                                fontSize: 11,
                                                                fontWeight:
                                                                    FontWeight
                                                                        .w500,
                                                                color:
                                                                    Colors.blue,
                                                              ),
                                                            ),
                                                            const SizedBox(
                                                              width: 25,
                                                            ),
                                                            GestureDetector(
                                                              onTap: () {
                                                                //update like menjadi filled , kasi nilai 1
                                                                context
                                                                    .read<
                                                                      FeedbackPaperBloc
                                                                    >()
                                                                    .add(
                                                                      FeedbackSubmitted(
                                                                        feedbackRequest: FeedbackRequest(
                                                                          paperId:
                                                                              recommendation.id,
                                                                          feedbackValue:
                                                                              1,
                                                                        ),
                                                                      ),
                                                                    );
                                                              },
                                                              child: const Icon(
                                                                Icons
                                                                    .thumb_up_outlined,
                                                                size: 14,
                                                                color:
                                                                    Colors.blue,
                                                              ),
                                                            ),
                                                            const SizedBox(
                                                              width: 8,
                                                            ),
                                                            GestureDetector(
                                                              onTap: () {
                                                                //kasi nilai 0
                                                                context
                                                                    .read<
                                                                      FeedbackPaperBloc
                                                                    >()
                                                                    .add(
                                                                      FeedbackSubmitted(
                                                                        feedbackRequest: FeedbackRequest(
                                                                          paperId:
                                                                              recommendation.id,
                                                                          feedbackValue:
                                                                              0,
                                                                        ),
                                                                      ),
                                                                    );
                                                              },
                                                              child: const Icon(
                                                                Icons
                                                                    .thumb_down_outlined,
                                                                size: 14,
                                                                color:
                                                                    Color.fromARGB(
                                                                      255,
                                                                      255,
                                                                      0,
                                                                      0,
                                                                    ),
                                                              ),
                                                            ),
                                                          ],
                                                        );
                                                      },
                                                    ),
                                                  ),
                                                ],
                                              ),
                                            ),
                                          ),
                                        ),
                                      );
                                    },
                                  ),
                                );
                              }
                              return const SizedBox.shrink();
                            },
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
              );
            }

            return const Center(child: Text("Memuat data..."));
          },
        ),
      ),
    );
  }
}
