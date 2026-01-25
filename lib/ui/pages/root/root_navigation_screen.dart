import 'package:arxivinder/blocs/bottom_nav_bar_bloc.dart';
import 'package:arxivinder/data/events/bottom_navigation_event.dart';
import 'package:arxivinder/ui/pages/home/home_screen.dart';
import 'package:arxivinder/ui/pages/recommendation/recommender_screen.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class RootNavigationScreen extends StatefulWidget {
  const RootNavigationScreen({super.key});

  @override
  State<StatefulWidget> createState() {
    return RootNavigationState();
  }
}

class RootNavigationState extends State<RootNavigationScreen> {
  @override
  Widget build(BuildContext context) {
    final BottomNavBarBloc navBarBloc = BottomNavBarBloc();

    return Scaffold(
      body: BlocBuilder<BottomNavBarBloc, int>(
        builder: (context, currIdx) {
          switch (currIdx) {
            case 0:
              return HomeScreen();
            case 1:
              return RecommenderScreen();
            default:
              return Container();
          }
        },
      ),
      bottomNavigationBar: BlocBuilder<BottomNavBarBloc, int>(
        builder: (context, index) {
          return BottomNavigationBar(
            currentIndex: index,
            onTap: (selectedIndex) {
              navBarBloc.add(BottomNavigationEvent.values[index]);
            },
            items: const [
              BottomNavigationBarItem(
                icon: Icon(Icons.home),
                label: 'Home',
              ),
              BottomNavigationBarItem(
                icon: Icon(Icons.search),
                label: 'Recommender',
              ),
            ],
          );
        },
      ),
    );
  }
}
