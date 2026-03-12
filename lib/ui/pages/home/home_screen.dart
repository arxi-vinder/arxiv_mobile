import 'package:arxivinder/blocs/papers/paper_bloc.dart';
import 'package:arxivinder/blocs/papers/paper_event_bloc.dart';
import 'package:arxivinder/blocs/papers/paper_state_bloc.dart';
import 'package:arxivinder/data/services/secure_storage_service.dart';
import 'package:arxivinder/ui/pages/auth/login/login_page_screen.dart';
import 'package:arxivinder/ui/pages/detail/detail_screen.dart/detail_paper_screen.dart';
// import 'package:arxivinder/ui/pages/recommendation/recommender_screen.dart';
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

  @override
  void initState() {
    super.initState();
    _userFuture = SecureStorageService.getUserData();
    _isLoggedIn = SecureStorageService.isLoggedIn();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      context.read<PaperBloc>().add(const GetAllPapers());
  });
  }

  @override
  Widget build(BuildContext context) {
    final screenWidth = MediaQuery.of(context).size.width;
    return Scaffold(
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
          Container(
            width: screenWidth,
            height: 188,
            decoration: ShapeDecoration(
              color: const Color(0xFF3674B5),
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.only(
                  bottomLeft: Radius.circular(32),
                  bottomRight: Radius.circular(32),
                ),
              ),
            ),
          ),
          Container(
            height: 188,
            padding: EdgeInsets.only(left: 17),
            alignment: Alignment.centerLeft,
            child: Column(
              mainAxisSize: MainAxisSize.min,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  children: [
                    Text(
                      "Halo,",
                      style: TextStyle(
                        color: Colors.white,
                        fontSize: 32,
                        fontFamily: 'Poppins',
                        fontWeight: FontWeight.w400,
                      ),
                    ),
                    SizedBox(width: 8),
                    Text(
                      "Selamat Datang",
                      style: TextStyle(
                        color: Colors.white,
                        fontSize: 32,
                        fontFamily: 'Poppins',
                        fontWeight: FontWeight.w400,
                      ),
                    ),
                  ],
                ),
                SizedBox(height: 4),
                FutureBuilder<Map<String, String?>>(
                  future: _userFuture,
                  builder: (context, snapshot) {
                    if (snapshot.connectionState == ConnectionState.waiting) {
                      return const CircularProgressIndicator(
                        valueColor: AlwaysStoppedAnimation<Color>(Colors.white),
                      );
                    }

                    if (snapshot.hasError) {
                      debugPrint('Failed to load user data: ${snapshot.error}');
                    }

                    if (snapshot.hasData) {
                      debugPrint('Snapshot data: ${snapshot.data}');
                    }

                    final data = snapshot.data;
                    String username;
                    if (data == null ||
                        data['username'] == null ||
                        data['username']!.isEmpty) {
                      username = "Guest";
                    } else {
                      username = data['username']!;
                    }
                    return Text(
                      username,
                      style: const TextStyle(
                        color: Colors.white,
                        fontSize: 20,
                        fontFamily: 'Poppins',
                        fontWeight: FontWeight.w400,
                      ),
                    );
                  },
                ),
              ],
            ),
          ),
          SizedBox(height: 40),
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 17, vertical: 200),
            child: Container(
              width: double.infinity,
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(8),
                border: Border.all(
                  color: const Color.fromARGB(255, 198, 160, 160),
                  width: 1,
                ),
              ),
              margin: EdgeInsets.only(left: 2),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const Text(
                    "Rekomendasi Untuk Anda",
                    style: TextStyle(
                      fontSize: 16,
                      fontWeight: FontWeight.bold,
                      fontFamily: 'Poppins',
                    ),
                  ),
                  const SizedBox(height: 16),
                  Expanded(
                    child: FutureBuilder<bool>(
                      future: _isLoggedIn,
                      builder: (context, snapshot) {
                        if (snapshot.connectionState == ConnectionState.waiting) {
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
                                  child: Text('Tidak ada paper tersedia'),
                                );
                              }
                              return ListView.builder(
                                itemCount: papers.length,
                                itemBuilder: (ctx, index) {
                                  final item = papers[index];

                                  return GestureDetector(
                                    onTap: () {
                                      if (isLoggedIn) {
                                        Navigator.push(
                                          context,
                                          MaterialPageRoute(
                                            builder:
                                                (context) =>
                                                    const DetailPaperScreen(),
                                          ),
                                        );
                                      } else {
                                        Navigator.push(
                                          context,
                                          MaterialPageRoute(
                                            builder:
                                                (context) => const LoginPageScreen(),
                                          ),
                                        );
                                      }
                                    },
                                    child: CustomListTile(
                                      title: item.category,
                                      subTitle: item.title,
                                      description: item.abstract,
                                    ),
                                  );
                                },
                              );
                            } else if (state is FetchFailure) {
                              return Center(
                                child: Text('Error: ${state.error}'),
                              );
                            }
                            return const Center(
                              child: Text('Tidak ada data'),
                            );
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
