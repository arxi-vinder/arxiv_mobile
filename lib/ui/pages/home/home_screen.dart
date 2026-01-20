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
    final screenWidth = MediaQuery.of(context).size.width;
    return Scaffold(
      body: Stack(
        children: [
          Container(
            width: screenWidth,
            height: 298,
            decoration: ShapeDecoration(
              gradient: LinearGradient(
                begin: Alignment(0.50, 0.18),
                end: Alignment(0.50, 1.00),
                colors: [const Color(0xFF00FFCC), const Color(0xFF00FFCC)],
              ),
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.only(
                  bottomLeft: Radius.circular(32),
                  bottomRight: Radius.circular(32),
                ),
              ),
            ),
          ),
          Column(
            children: [
              SizedBox(height: 100),
              Container(
                margin: EdgeInsets.only(
                  left: 21
                ),
                child: Row(
                  children: [
                    Text("a"), 
                    Text("b")
                  ]
                )
            ),
              Text("abb"),
            ],
          ),
        ],
      ),
    );
  }
}
