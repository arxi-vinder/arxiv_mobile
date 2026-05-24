import 'package:arxivinder/blocs/papers/category/category_bloc.dart';
import 'package:arxivinder/blocs/papers/category/category_event.dart';
import 'package:arxivinder/blocs/papers/category/category_state.dart';
import 'package:arxivinder/data/services/secure_storage_service.dart';
import 'package:arxivinder/ui/pages/auth/login/login_page_screen.dart';
import 'package:arxivinder/ui/pages/detail/detail_screen.dart/detail_paper_screen.dart';
import 'package:arxivinder/ui/utils/custom_list_tile.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

const _primaryBlue = Color(0xFF3674B5);
const _lightGray = Color(0xFFF5F5F5);

class RecommenderScreen extends StatefulWidget {
  const RecommenderScreen({super.key});

  @override
  State<RecommenderScreen> createState() => _RecommenderScreenState();
}

class _RecommenderScreenState extends State<RecommenderScreen> {
  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      context.read<CategoryBloc>().add(const FetchCategories());
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: _buildAppBar(),
      body: BlocBuilder<CategoryBloc, CategoryState>(
        builder: (context, state) {
          if (state is CategoryLoading) {
            return _buildLoadingState();
          }

          if (state is CategoryError) {
            return _buildErrorState(state.message,
                friendlyMessage: state.friendlyMessage);
          }

          if (state is CategoryLoaded) {
            return SingleChildScrollView(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const SizedBox(height: 12),
                  _buildCategorySection(state),
                  const SizedBox(height: 24),
                  if (state.selectedCategory != null)
                    _buildPapersSection(state),
                  if (state.selectedCategory == null) _buildEmptyState(),
                  const SizedBox(height: 20),
                ],
              ),
            );
          }

          return const Center(child: Text("No data"));
        },
      ),
    );
  }

  PreferredSizeWidget _buildAppBar() {
    return AppBar(
      backgroundColor: _primaryBlue,
      elevation: 0,
      centerTitle: true,
      title: const Text(
        "Explore Categories",
        style: TextStyle(
          color: Colors.white,
          fontSize: 20,
          fontWeight: FontWeight.bold,
          fontFamily: 'Poppins',
        ),
      ),
    );
  }

  Widget _buildLoadingState() {
    return const Center(child: CircularProgressIndicator(color: _primaryBlue));
  }

  Widget _buildErrorState(String message, {String? friendlyMessage}) {
    return Center(
      child: Padding(
        padding: const EdgeInsets.all(24),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            const Icon(Icons.error_outline, size: 48, color: _primaryBlue),
            const SizedBox(height: 16),
            const Text(
              'Oops, Terjadi Kesalahan',
              style: TextStyle(
                fontSize: 18,
                fontWeight: FontWeight.bold,
                color: _primaryBlue,
              ),
              textAlign: TextAlign.center,
            ),
            const SizedBox(height: 12),
            Text(
              friendlyMessage ?? 'Terjadi kesalahan saat mengambil data kategori.',
              textAlign: TextAlign.center,
              style: const TextStyle(
                fontSize: 14,
                color: Colors.black87,
                height: 1.5,
              ),
            ),
            const SizedBox(height: 24),
            ElevatedButton.icon(
              onPressed: () {
                context.read<CategoryBloc>().add(const FetchCategories());
              },
              icon: const Icon(Icons.refresh),
              label: const Text('Coba Lagi'),
              style: ElevatedButton.styleFrom(
                backgroundColor: _primaryBlue,
                foregroundColor: Colors.white,
                padding: const EdgeInsets.symmetric(
                  horizontal: 32,
                  vertical: 12,
                ),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(8),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildEmptyState() {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 60),
      child: Column(
        children: [
          Icon(Icons.category_outlined, size: 80, color: Colors.grey.shade300),
          const SizedBox(height: 24),
          Text(
            "Select Category",
            style: TextStyle(
              fontSize: 18,
              fontWeight: FontWeight.w600,
              color: Colors.grey.shade600,
            ),
          ),
          const SizedBox(height: 8),
          Text(
            "Tap one of the categories above to see available papers",
            textAlign: TextAlign.center,
            style: TextStyle(fontSize: 14, color: Colors.grey.shade500),
          ),
        ],
      ),
    );
  }

  void _showLoginDialog(BuildContext context) {
    showDialog(
      context: context,
      builder: (BuildContext dialogContext) {
        return AlertDialog(
          title: const Text("Login Required"),
          content: const Text("You must login first to access papers."),
          actions: [
            TextButton(
              onPressed: () {
                Navigator.pop(dialogContext);
              },
              child: const Text("Later"),
            ),
            ElevatedButton(
              onPressed: () {
                Navigator.pop(dialogContext);
                Navigator.push(
                  context,
                  MaterialPageRoute(builder: (_) => const LoginPageScreen()),
                );
              },
              style: ElevatedButton.styleFrom(backgroundColor: _primaryBlue),
              child: const Text("Login", style: TextStyle(color: Colors.white)),
            ),
          ],
        );
      },
    );
  }

  Widget _buildCategorySection(CategoryLoaded state) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Padding(
          padding: EdgeInsets.symmetric(horizontal: 16),
          child: Text(
            "Categories",
            style: TextStyle(
              fontSize: 16,
              fontWeight: FontWeight.w700,
              color: _primaryBlue,
            ),
          ),
        ),
        const SizedBox(height: 12),
        SizedBox(
          height: 50,
          child: ListView.builder(
            padding: const EdgeInsets.symmetric(horizontal: 12),
            scrollDirection: Axis.horizontal,
            itemCount: state.categories.length,
            itemBuilder: (context, index) {
              final category = state.categories[index];
              final isSelected = state.selectedCategory == category.name;

              return Padding(
                padding: const EdgeInsets.symmetric(horizontal: 4),
                child: _CategoryChip(
                  label: category.name,
                  isSelected: isSelected,
                  onTap: () async {
                    final isLoggedIn = await SecureStorageService.isLoggedIn();
                    if (!context.mounted) return;

                    if (isLoggedIn) {
                      context.read<CategoryBloc>().add(
                        FetchPapersByCategory(category.name),
                      );
                    } else {
                      _showLoginDialog(context);
                    }
                  },
                ),
              );
            },
          ),
        ),
      ],
    );
  }

  Widget _buildPapersSection(CategoryLoaded state) {
    if (state.isLoadingPapers) {
      return const Padding(
        padding: EdgeInsets.symmetric(vertical: 24),
        child: Center(child: CircularProgressIndicator(color: _primaryBlue)),
      );
    }

    if (state.papers == null || state.papers!.isEmpty) {
      return Padding(
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 32),
        child: Center(
          child: Text(
            "No papers for this category",
            style: TextStyle(color: Colors.grey.shade600),
          ),
        ),
      );
    }

    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                "Papers (${state.papers!.length})",
                style: const TextStyle(
                  fontSize: 16,
                  fontWeight: FontWeight.w700,
                  color: _primaryBlue,
                ),
              ),
              Container(
                padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                decoration: BoxDecoration(
                  color: _primaryBlue.withValues(alpha: 0.1),
                  borderRadius: BorderRadius.circular(6),
                ),
                child: Text(
                  state.selectedCategory?.split('(').first.trim() ?? '',
                  style: const TextStyle(
                    fontSize: 11,
                    fontWeight: FontWeight.w600,
                    color: _primaryBlue,
                  ),
                ),
              ),
            ],
          ),
          const SizedBox(height: 12),
          ListView.separated(
            shrinkWrap: true,
            physics: const NeverScrollableScrollPhysics(),
            itemCount: state.papers!.length,
            separatorBuilder: (_, __) => const SizedBox(height: 10),
            itemBuilder: (context, index) {
              final paper = state.papers![index];
              return GestureDetector(
                onTap: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (_) => DetailPaperScreen(id: paper.id),
                    ),
                  );
                },
                child: CustomListTile(
                  title: paper.category,
                  subTitle: paper.title,
                  description: paper.abstract,
                ),
              );
            },
          ),
        ],
      ),
    );
  }
}

class _CategoryChip extends StatelessWidget {
  final String label;
  final bool isSelected;
  final VoidCallback onTap;

  const _CategoryChip({
    required this.label,
    required this.isSelected,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return AnimatedContainer(
      duration: const Duration(milliseconds: 300),
      curve: Curves.easeInOut,
      decoration: BoxDecoration(
        color: isSelected ? _primaryBlue : _lightGray,
        borderRadius: BorderRadius.circular(20),
        border: Border.all(
          color: isSelected ? _primaryBlue : Colors.transparent,
          width: 1.5,
        ),
      ),
      child: Material(
        color: Colors.transparent,
        child: InkWell(
          onTap: onTap,
          borderRadius: BorderRadius.circular(20),
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
            child: Center(
              child: Text(
                label,
                maxLines: 1,
                overflow: TextOverflow.ellipsis,
                style: TextStyle(
                  fontSize: 12,
                  fontWeight: isSelected ? FontWeight.w600 : FontWeight.w500,
                  color: isSelected ? Colors.white : Colors.black87,
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }
}
