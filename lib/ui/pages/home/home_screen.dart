import 'dart:async';

import 'package:arxivinder/blocs/papers/paper_bloc.dart';
import 'package:arxivinder/blocs/papers/paper_event_bloc.dart';
import 'package:arxivinder/blocs/papers/paper_state_bloc.dart';
import 'package:arxivinder/data/services/secure_storage_service.dart';
import 'package:arxivinder/ui/pages/auth/login/login_page_screen.dart';
import 'package:arxivinder/ui/pages/detail/detail_screen.dart/detail_paper_screen.dart';
import 'package:arxivinder/ui/utils/custom_list_tile.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<StatefulWidget> createState() {
    return HomeState();
  }
}

class HomeState extends State<HomeScreen> {
  late Future<Map<String, String?>> _userFuture;
  late Future<bool> _isLoggedIn;
  String? _selectedSort;
  DateTime? _startDate;
  DateTime? _endDate;
  late TextEditingController _searchController;
  Timer? _searchDebounce;

  @override
  void initState() {
    super.initState();
    _userFuture = SecureStorageService.getUserData();
    _isLoggedIn = SecureStorageService.isLoggedIn();
    _searchController = TextEditingController();
    _searchController.addListener(() {
      setState(() {});
    });
    WidgetsBinding.instance.addPostFrameCallback((_) {
      context.read<PaperBloc>().add(const GetAllPapers());
    });
  }

  @override
  void dispose() {
    _searchController.dispose();
    _searchDebounce?.cancel();
    super.dispose();
  }

  Future<void> _selectDateRange() async {
    final picked = await showDateRangePicker(
      context: context,
      firstDate: DateTime(2020),
      lastDate: DateTime.now(),
      initialDateRange:
          _startDate != null && _endDate != null
              ? DateTimeRange(start: _startDate!, end: _endDate!)
              : null,
    );

    if (picked != null) {
      setState(() {
        _startDate = picked.start;
        _endDate = picked.end;
        _selectedSort = null;
      });

      if (mounted) {
        context.read<PaperBloc>().add(
          GetPapersByDateRange(startDate: picked.start, endDate: picked.end),
        );
      }
    }
  }

  void _applySortFilter(String sort) {
    setState(() {
      _selectedSort = sort;
      _startDate = null; // Reset date filter when using sort
      _endDate = null;
    });

    context.read<PaperBloc>().add(GetPapersSortedBy(sort: sort, limit: 50));
  }

  void _clearFilters() {
    setState(() {
      _selectedSort = null;
      _startDate = null;
      _endDate = null;
      _searchController.clear();
    });

    context.read<PaperBloc>().add(const GetAllPapers());
  }

  void _onSearchChanged(String query) async {
    _searchDebounce?.cancel();

    if (query.isEmpty) {
      context.read<PaperBloc>().add(const GetAllPapers());
      return;
    }

    final isLoggedIn = await SecureStorageService.isLoggedIn();
    if (!isLoggedIn && mounted) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Anda harus login terlebih dahulu untuk melakukan pencarian'),
        ),
      );
      _searchController.clear();
      return;
    }

    _searchDebounce = Timer(const Duration(milliseconds: 500), () {
      context.read<PaperBloc>().add(SearchPaperByName(name: query));
    });
  }

  @override
  Widget build(BuildContext context) {
    final screenWidth = MediaQuery.of(context).size.width;
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        backgroundColor: const Color(0xFF3674B5),
        elevation: 0,
        actions: [
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 16),
            child: FutureBuilder<Map<String, String?>>(
              future: _userFuture,
              builder: (context, snapshot) {
                String username = 'Guest';
                if (snapshot.hasData) {
                  final data = snapshot.data;
                  if (data?['username'] != null &&
                      data!['username']!.isNotEmpty) {
                    username = data['username']!;
                  }
                }
                return Center(
                  child: Text(
                    username,
                    style: const TextStyle(
                      color: Colors.white,
                      fontSize: 14,
                      fontWeight: FontWeight.w500,
                    ),
                    overflow: TextOverflow.ellipsis,
                  ),
                );
              },
            ),
          ),
          IconButton(
            icon: const Icon(Icons.logout, color: Colors.white),
            onPressed: () async {
              final navigator = Navigator.of(context);
              await SecureStorageService.clearUserData();
              if (!mounted) return;
              navigator.pushAndRemoveUntil(
                MaterialPageRoute(
                  builder: (context) => const LoginPageScreen(),
                ),
                (Route<dynamic> route) => false,
              );
            },
          ),
        ],
      ),
      body: Stack(
        children: [
          // Background Biru di Atas
          Container(
            width: screenWidth,
            height: 180,
            decoration: const ShapeDecoration(
              color: Color(0xFF3674B5),
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.only(
                  bottomLeft: Radius.circular(32),
                  bottomRight: Radius.circular(32),
                ),
              ),
            ),
          ),

          Positioned(
            top: 20,
            left: 20,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const Text(
                  "Hello, Welcome",
                  style: TextStyle(
                    color: Colors.white,
                    fontSize: 28,
                    fontFamily: 'Poppins',
                    fontWeight: FontWeight.w500,
                  ),
                ),
                const SizedBox(height: 4),
                FutureBuilder<Map<String, String?>>(
                  future: _userFuture,
                  builder: (context, snapshot) {
                    if (snapshot.connectionState == ConnectionState.waiting) {
                      return const SizedBox(
                        height: 20,
                        width: 20,
                        child: CircularProgressIndicator(
                          strokeWidth: 2,
                          valueColor: AlwaysStoppedAnimation<Color>(
                            Colors.white,
                          ),
                        ),
                      );
                    }
                    final data = snapshot.data;
                    String username =
                        (data == null ||
                                data['username'] == null ||
                                data['username']!.isEmpty)
                            ? "Guest"
                            : data['username']!;
                    return Text(
                      username,
                      style: const TextStyle(
                        color: Colors.white70,
                        fontSize: 18,
                        fontFamily: 'Poppins',
                      ),
                    );
                  },
                ),
              ],
            ),
          ),
          Padding(
            padding: const EdgeInsets.only(
              top: 100,
              left: 16,
              right: 16,
              bottom: 20,
            ),
            child: Container(
              width: double.infinity,
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(12),
                border: Border.all(
                  color: const Color.fromARGB(255, 230, 230, 230),
                  width: 1,
                ),
                boxShadow: [
                  BoxShadow(
                    // ignore: deprecated_member_use
                    color: Colors.black.withOpacity(0.05),
                    blurRadius: 10,
                    offset: const Offset(0, 5),
                  ),
                ],
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Padding(
                    padding: const EdgeInsets.fromLTRB(18, 18, 18, 14),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            const Text(
                              "Scientific Papers For You",
                              style: TextStyle(
                                fontSize: 18,
                                fontWeight: FontWeight.bold,
                                fontFamily: 'Poppins',
                                color: Color(0xFF3674B5),
                              ),
                            ),
                            if (_selectedSort != null ||
                                _startDate != null ||
                                _searchController.text.isNotEmpty)
                              GestureDetector(
                                onTap: _clearFilters,
                                child: const Icon(
                                  Icons.clear,
                                  size: 20,
                                  color: Color(0xFF3674B5),
                                ),
                              ),
                          ],
                        ),
                        const SizedBox(height: 12),
                        TextField(
                          controller: _searchController,
                          onChanged: _onSearchChanged,
                          decoration: InputDecoration(
                            hintText: 'Search papers...',
                            hintStyle: TextStyle(
                              color: Colors.grey.shade400,
                              fontSize: 14,
                            ),
                            prefixIcon: const Icon(
                              Icons.search,
                              color: Color(0xFF3674B5),
                              size: 20,
                            ),
                            suffixIcon:
                                _searchController.text.isNotEmpty
                                    ? GestureDetector(
                                      onTap: () {
                                        _searchController.clear();
                                        _onSearchChanged('');
                                      },
                                      child: const Icon(
                                        Icons.close,
                                        color: Color(0xFF3674B5),
                                        size: 18,
                                      ),
                                    )
                                    : null,
                            filled: true,
                            fillColor: Colors.grey.shade50,
                            contentPadding: const EdgeInsets.symmetric(
                              vertical: 12,
                              horizontal: 12,
                            ),
                            border: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(10),
                              borderSide: BorderSide(
                                color: Colors.grey.shade300,
                                width: 1,
                              ),
                            ),
                            enabledBorder: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(10),
                              borderSide: BorderSide(
                                color: Colors.grey.shade300,
                                width: 1,
                              ),
                            ),
                            focusedBorder: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(10),
                              borderSide: const BorderSide(
                                color: Color(0xFF3674B5),
                                width: 2,
                              ),
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                  Padding(
                    padding: const EdgeInsets.symmetric(
                      horizontal: 12,
                      vertical: 10,
                    ),
                    child: SingleChildScrollView(
                      scrollDirection: Axis.horizontal,
                      child: Row(
                        children: [
                          _FilterButton(
                            label: 'Newest',
                            isActive: _selectedSort == 'newest',
                            onTap: () => _applySortFilter('newest'),
                          ),
                          const SizedBox(width: 8),
                          _FilterButton(
                            label: 'Oldest',
                            isActive: _selectedSort == 'oldest',
                            onTap: () => _applySortFilter('oldest'),
                          ),
                          const SizedBox(width: 8),
                          _FilterButton(
                            label:
                                _startDate != null && _endDate != null
                                    ? '📅 ${_startDate!.day}/${_startDate!.month} - ${_endDate!.day}/${_endDate!.month}'
                                    : 'Date Range',
                            isActive: _startDate != null,
                            onTap: _selectDateRange,
                          ),
                        ],
                      ),
                    ),
                  ),
                  Expanded(
                    child: FutureBuilder<bool>(
                      future: _isLoggedIn,
                      builder: (context, snapshot) {
                        if (snapshot.connectionState ==
                            ConnectionState.waiting) {
                          return const Center(
                            child: CircularProgressIndicator(),
                          );
                        }
                        final bool isLoggedIn = snapshot.data ?? false;

                        return BlocBuilder<PaperBloc, PaperStateBloc>(
                          builder: (context, state) {
                            if (state is FetchLoading) {
                              return const Center(
                                child: CircularProgressIndicator(),
                              );
                            } else if (state is FetchSuccess) {
                              final papers = state.papers;
                              if (papers.isEmpty) {
                                return const Center(
                                  child: Text('No papers available'),
                                );
                              }
                              return ListView.separated(
                                padding: const EdgeInsets.symmetric(
                                  horizontal: 12,
                                  vertical: 8,
                                ),
                                itemCount: papers.length,
                                separatorBuilder:
                                    (_, __) => const SizedBox(height: 10),
                                itemBuilder: (ctx, index) {
                                  final item = papers[index];
                                  return RepaintBoundary(
                                    child: _PaperTile(
                                      item: item,
                                      isLoggedIn: isLoggedIn,
                                    ),
                                  );
                                },
                              );
                            } else if (state is FetchFailure) {
                              return Center(
                                child: Padding(
                                  padding: const EdgeInsets.all(24),
                                  child: Column(
                                    mainAxisAlignment: MainAxisAlignment.center,
                                    crossAxisAlignment: CrossAxisAlignment.center,
                                    children: [
                                      const Icon(
                                        Icons.error_outline,
                                        size: 48,
                                        color: Color(0xFF3674B5),
                                      ),
                                      const SizedBox(height: 16),
                                      Text(
                                        'Oops, Terjadi Kesalahan',
                                        style: const TextStyle(
                                          fontSize: 18,
                                          fontWeight: FontWeight.bold,
                                          color: Color(0xFF3674B5),
                                        ),
                                        textAlign: TextAlign.center,
                                      ),
                                      const SizedBox(height: 12),
                                      Text(
                                        state.friendlyMessage ??
                                            'Terjadi kesalahan saat mengambil data. Silakan coba lagi.',
                                        style: const TextStyle(
                                          fontSize: 14,
                                          color: Colors.black87,
                                          height: 1.5,
                                        ),
                                        textAlign: TextAlign.center,
                                      ),
                                      const SizedBox(height: 24),
                                      ElevatedButton.icon(
                                        onPressed: () {
                                          if (_selectedSort != null) {
                                            context.read<PaperBloc>().add(
                                              GetPapersSortedBy(
                                                sort: _selectedSort!,
                                                limit: 50,
                                              ),
                                            );
                                          } else if (_startDate != null &&
                                              _endDate != null) {
                                            context.read<PaperBloc>().add(
                                              GetPapersByDateRange(
                                                startDate: _startDate!,
                                                endDate: _endDate!,
                                              ),
                                            );
                                          } else if (_searchController
                                              .text.isNotEmpty) {
                                            context.read<PaperBloc>().add(
                                              SearchPaperByName(
                                                name: _searchController.text,
                                              ),
                                            );
                                          } else {
                                            context.read<PaperBloc>().add(
                                              const GetAllPapers(),
                                            );
                                          }
                                        },
                                        icon: const Icon(Icons.refresh),
                                        label: const Text('Coba Lagi'),
                                        style: ElevatedButton.styleFrom(
                                          backgroundColor:
                                              const Color(0xFF3674B5),
                                          foregroundColor: Colors.white,
                                          padding: const EdgeInsets.symmetric(
                                            horizontal: 32,
                                            vertical: 12,
                                          ),
                                          shape: RoundedRectangleBorder(
                                            borderRadius:
                                                BorderRadius.circular(8),
                                          ),
                                        ),
                                      ),
                                    ],
                                  ),
                                ),
                              );
                            }
                            return const Center(child: Text('No data'));
                          },
                        );
                      },
                    ),
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}

class _FilterButton extends StatelessWidget {
  final String label;
  final bool isActive;
  final VoidCallback onTap;

  const _FilterButton({
    required this.label,
    required this.isActive,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
        decoration: BoxDecoration(
          color: isActive ? const Color(0xFF3674B5) : Colors.grey.shade100,
          borderRadius: BorderRadius.circular(16),
          border: Border.all(
            color: isActive ? const Color(0xFF3674B5) : Colors.grey.shade300,
            width: 1,
          ),
        ),
        child: Text(
          label,
          style: TextStyle(
            fontSize: 12,
            fontWeight: isActive ? FontWeight.w600 : FontWeight.w500,
            color: isActive ? Colors.white : Colors.black87,
          ),
        ),
      ),
    );
  }
}

class _PaperTile extends StatelessWidget {
  final dynamic item;
  final bool isLoggedIn;

  const _PaperTile({required this.item, required this.isLoggedIn});

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () {
        if (isLoggedIn) {
          if (item.id != 0) {
            Navigator.push(
              context,
              MaterialPageRoute(
                builder: (context) => DetailPaperScreen(id: item.id),
              ),
            );
          }
        } else {
          Navigator.push(
            context,
            MaterialPageRoute(builder: (context) => const LoginPageScreen()),
          );
        }
      },
      child: CustomListTile(
        title: item.title,
        subTitle: item.category,
        description: item.abstract,
      ),
    );
  }
}
