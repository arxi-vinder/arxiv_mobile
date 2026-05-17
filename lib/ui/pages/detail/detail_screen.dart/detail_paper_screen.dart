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
import 'package:url_launcher/url_launcher.dart';

const _primaryBlue = Color.fromARGB(255, 0, 55, 117);

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

  Future<void> _openPaperUrl(String url) async {
    if (url.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text("URL paper tidak tersedia")),
      );
      return;
    }
    final uri = Uri.tryParse(url);
    if (uri == null) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text("URL paper tidak valid")),
      );
      return;
    }
    final launched = await launchUrl(uri, mode: LaunchMode.externalApplication);
    if (!launched && mounted) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text("Tidak dapat membuka URL")),
      );
    }
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
        backgroundColor: Colors.white,
        body: BlocBuilder<DetailPaperBloc, StatePaperDetailBloc>(
          builder: (context, state) {
            if (state is PaperDetailLoading) {
              return _buildLoading();
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
                    _buildHeader(),
                    const SizedBox(height: 24),
                    _buildPaperInfo(
                      title: paper.title,
                      author: paper.author,
                      category: paper.category,
                    ),
                    const SizedBox(height: 20),
                    _buildLearnMore(paper.url),
                    const SizedBox(height: 24),
                    _buildDivider(),
                    const SizedBox(height: 20),
                    _buildAbstractSection(paper.abstract),
                    const SizedBox(height: 28),
                    _buildDivider(),
                    const SizedBox(height: 20),
                    _buildRecommendationSection(),
                    const SizedBox(height: 24),
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

  Widget _buildLoading() {
    return Center(
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 40.0),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            const Icon(
              Icons.auto_awesome_rounded,
              color: _primaryBlue,
              size: 32,
            ),
            const SizedBox(height: 24),
            const Text(
              "Menyiapkan rekomendasi untuk Anda",
              textAlign: TextAlign.center,
              style: TextStyle(
                fontSize: 15,
                fontWeight: FontWeight.w500,
                fontFamily: "Inter",
                color: _primaryBlue,
              ),
            ),
            const SizedBox(height: 16),
            SizedBox(
              width: 140,
              child: ClipRRect(
                borderRadius: BorderRadius.circular(2),
                child: const LinearProgressIndicator(
                  minHeight: 3,
                  valueColor: AlwaysStoppedAnimation<Color>(_primaryBlue),
                  backgroundColor: Color(0x26000000),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildHeader() {
    return Container(
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
                icon: const Icon(Icons.arrow_back, color: Colors.white),
                onPressed: () => Navigator.pop(context),
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
    );
  }

  Widget _buildPaperInfo({
    required String title,
    required String author,
    required String category,
  }) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            title,
            style: const TextStyle(
              fontSize: 24,
              fontWeight: FontWeight.bold,
              height: 1.3,
            ),
          ),
          if (category.isNotEmpty) ...[
            const SizedBox(height: 12),
            Container(
              padding: const EdgeInsets.symmetric(
                horizontal: 10,
                vertical: 5,
              ),
              decoration: BoxDecoration(
                color: _primaryBlue.withValues(alpha: 0.08),
                borderRadius: BorderRadius.circular(6),
              ),
              child: Text(
                category,
                style: const TextStyle(
                  fontSize: 12,
                  fontWeight: FontWeight.w600,
                  color: _primaryBlue,
                ),
              ),
            ),
          ],
          const SizedBox(height: 12),
          Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const Icon(
                Icons.person_outline,
                size: 16,
                color: Colors.black54,
              ),
              const SizedBox(width: 6),
              Expanded(
                child: Text(
                  author.isEmpty ? "Tidak diketahui" : author,
                  style: const TextStyle(
                    fontSize: 14,
                    fontWeight: FontWeight.w500,
                    color: Colors.black54,
                  ),
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildLearnMore(String url) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16),
      child: SizedBox(
        width: double.infinity,
        child: ElevatedButton.icon(
          onPressed: () => _openPaperUrl(url),
          icon: const Icon(Icons.open_in_new, size: 18),
          label: const Text(
            "Learn more",
            style: TextStyle(
              fontSize: 14,
              fontWeight: FontWeight.w600,
            ),
          ),
          style: ElevatedButton.styleFrom(
            backgroundColor: _primaryBlue,
            foregroundColor: Colors.white,
            padding: const EdgeInsets.symmetric(vertical: 12),
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(10),
            ),
            elevation: 0,
          ),
        ),
      ),
    );
  }

  Widget _buildDivider() {
    return const Padding(
      padding: EdgeInsets.symmetric(horizontal: 16),
      child: Divider(height: 1, color: Color(0x14000000)),
    );
  }

  Widget _buildAbstractSection(String abstract) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Text(
            "Abstrak",
            style: TextStyle(
              fontSize: 16,
              fontWeight: FontWeight.w700,
              color: _primaryBlue,
            ),
          ),
          const SizedBox(height: 10),
          Text(
            abstract,
            style: const TextStyle(
              fontSize: 15,
              height: 1.6,
              color: Colors.black87,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildRecommendationSection() {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              const Text(
                "Lebih banyak untuk Anda",
                style: TextStyle(
                  fontSize: 16,
                  fontWeight: FontWeight.w700,
                  fontFamily: "Inter",
                  color: _primaryBlue,
                ),
              ),
              BlocBuilder<FeedbackPaperBloc, StateFeedbackPaperBloc>(
                builder: (context, feedbackState) {
                  final hasFeedback = context
                      .read<FeedbackPaperBloc>()
                      .feedbackMap
                      .isNotEmpty;
                  final color = hasFeedback ? _primaryBlue : Colors.black38;
                  return InkWell(
                    borderRadius: BorderRadius.circular(6),
                    onTap: hasFeedback
                        ? () => context
                            .read<FeedbackPaperBloc>()
                            .add(const FeedbackReset())
                        : null,
                    child: Padding(
                      padding: const EdgeInsets.symmetric(
                        horizontal: 6,
                        vertical: 4,
                      ),
                      child: Row(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          Icon(Icons.refresh, size: 16, color: color),
                          const SizedBox(width: 4),
                          Text(
                            "Reset",
                            style: TextStyle(fontSize: 12, color: color),
                          ),
                        ],
                      ),
                    ),
                  );
                },
              ),
            ],
          ),
          const SizedBox(height: 14),
          BlocBuilder<RecommenderBloc, StateRecommenderBloc>(
            builder: (context, recommState) {
              if (recommState is InitialLoading) {
                return const SizedBox(
                  height: 200,
                  child: Center(child: CircularProgressIndicator()),
                );
              }

              if (recommState is InitialFailure) {
                return SizedBox(
                  height: 100,
                  child: Center(child: Text(recommState.error)),
                );
              }

              if (recommState is InitialSuccess) {
                if (recommState.papers.isEmpty) {
                  return const SizedBox(
                    height: 80,
                    child: Center(
                      child: Text(
                        "Belum ada rekomendasi",
                        style: TextStyle(color: Colors.black54),
                      ),
                    ),
                  );
                }
                return SizedBox(
                  height: 210,
                  child: ListView.builder(
                    scrollDirection: Axis.horizontal,
                    itemCount: recommState.papers.length,
                    itemBuilder: (context, index) {
                      final recommendation = recommState.papers[index];
                      return _RecommendationCard(
                        title: recommendation.title,
                        ucbScore: recommendation.ucbScore,
                        paperId: recommendation.id,
                        onTap: () {
                          Navigator.push(
                            context,
                            MaterialPageRoute(
                              builder: (_) => DetailPaperScreen(
                                id: recommendation.id,
                              ),
                            ),
                          );
                        },
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
    );
  }
}

class _RecommendationCard extends StatelessWidget {
  final String title;
  final double ucbScore;
  final int paperId;
  final VoidCallback onTap;

  const _RecommendationCard({
    required this.title,
    required this.ucbScore,
    required this.paperId,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      width: 170,
      margin: const EdgeInsets.only(right: 12),
      child: Material(
        borderRadius: BorderRadius.circular(12),
        elevation: 2,
        color: Colors.white,
        child: InkWell(
          borderRadius: BorderRadius.circular(12),
          onTap: onTap,
          child: Padding(
            padding: const EdgeInsets.all(10),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Container(
                  height: 90,
                  width: double.infinity,
                  decoration: BoxDecoration(
                    gradient: LinearGradient(
                      colors: [Colors.blue.shade100, Colors.blue.shade50],
                    ),
                    borderRadius: BorderRadius.circular(10),
                  ),
                  child: const Center(
                    child: Icon(
                      Icons.article_outlined,
                      size: 36,
                      color: Colors.blue,
                    ),
                  ),
                ),
                const SizedBox(height: 10),
                Text(
                  title,
                  maxLines: 2,
                  overflow: TextOverflow.ellipsis,
                  style: const TextStyle(
                    fontSize: 13,
                    fontWeight: FontWeight.w600,
                    height: 1.3,
                  ),
                ),
                const SizedBox(height: 6),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Container(
                      padding: const EdgeInsets.symmetric(
                        horizontal: 6,
                        vertical: 3,
                      ),
                      decoration: BoxDecoration(
                        color: Colors.blue.withValues(alpha: 0.1),
                        borderRadius: BorderRadius.circular(5),
                      ),
                      child: Text(
                        ucbScore.toStringAsFixed(2).replaceAll('.', ','),
                        style: const TextStyle(
                          fontSize: 11,
                          fontWeight: FontWeight.w600,
                          color: Colors.blue,
                        ),
                      ),
                    ),
                    BlocBuilder<FeedbackPaperBloc, StateFeedbackPaperBloc>(
                      builder: (context, feedbackState) {
                        final feedbackValue = context
                            .read<FeedbackPaperBloc>()
                            .feedbackMap[paperId];
                        final isLiked = feedbackValue == 1;
                        final isDisliked = feedbackValue == 0;

                        return Row(
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            GestureDetector(
                              onTap: () {
                                context.read<FeedbackPaperBloc>().add(
                                  FeedbackSubmitted(
                                    feedbackRequest: FeedbackRequest(
                                      paperId: paperId,
                                      feedbackValue: 1,
                                    ),
                                  ),
                                );
                              },
                              child: Icon(
                                isLiked
                                    ? Icons.thumb_up
                                    : Icons.thumb_up_outlined,
                                size: 14,
                                color:
                                    isLiked ? Colors.blue : Colors.grey,
                              ),
                            ),
                            const SizedBox(width: 8),
                            GestureDetector(
                              onTap: () {
                                context.read<FeedbackPaperBloc>().add(
                                  FeedbackSubmitted(
                                    feedbackRequest: FeedbackRequest(
                                      paperId: paperId,
                                      feedbackValue: 0,
                                    ),
                                  ),
                                );
                              },
                              child: Icon(
                                isDisliked
                                    ? Icons.thumb_down
                                    : Icons.thumb_down_outlined,
                                size: 14,
                                color:
                                    isDisliked ? Colors.red : Colors.grey,
                              ),
                            ),
                          ],
                        );
                      },
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
}
