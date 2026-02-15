import 'package:arxivinder/data/model/paper.dart';
import 'package:arxivinder/ui/pages/recommendation/recommender_screen.dart';
import 'package:arxivinder/ui/utils/custom_list_tile.dart';
import 'package:arxivinder/ui/utils/dummy.dart';
import 'package:flutter/material.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<StatefulWidget> createState() {
    return HomeState();
  }
}

class HomeState extends State<HomeScreen> {
  @override
  Widget build(BuildContext context) {
    final List<Paper> papers = dummyPapers;
    final screenWidth = MediaQuery.of(context).size.width;
    return Scaffold(
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
                Text(
                  "Emmanuel Dito",
                  style: TextStyle(
                    color: Colors.white,
                    fontSize: 20,
                    fontFamily: 'Poppins',
                    fontWeight: FontWeight.w400,
                  ),
                ),
              ],
            ),
          ),
          SizedBox(height: 40),
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 17, vertical: 200),
            child: Container(
              decoration: ShapeDecoration(
                shape: RoundedRectangleBorder(
                  side: BorderSide(width: 1, color: const Color(0xFFCAB6B6)),
                  borderRadius: BorderRadius.circular(8),
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
                    child: ListView.builder(
                      itemBuilder: (ctx, index) {
                        final item = papers[index];
                        return GestureDetector(
                          onTap:
                              () => {
                                Navigator.push(
                                  context,
                                  MaterialPageRoute(
                                    builder: (context) => RecommenderScreen(),
                                  ),
                                ),
                              },

                          child: CustomListTile(
                            title: item.category,
                            subTitle: item.title,
                            description: item.abstract,
                          ),
                        );
                      },

                      itemCount: papers.length,
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
