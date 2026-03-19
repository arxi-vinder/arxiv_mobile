import 'package:arxivinder/blocs/bottom_nav_bar_bloc.dart';
import 'package:arxivinder/blocs/papers/detail/detail_paper_bloc.dart';
import 'package:arxivinder/blocs/papers/paper_bloc.dart';
import 'package:arxivinder/data/services/detail_paper_api.dart';
import 'package:arxivinder/data/services/papers_api.dart';
import 'package:arxivinder/ui/pages/root/root_navigation_screen.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';

Future<void> main() async {
  await dotenv.load(fileName: ".env");
  runApp(const MainApp());
}

class MainApp extends StatelessWidget {
  const MainApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MultiBlocProvider(
      providers: [
        BlocProvider(create: (_) => BottomNavBarBloc()),
        BlocProvider(create: (_) => PaperBloc(api: PapersApi())),
        BlocProvider(create: (_) => DetailPaperBloc(api: DetailPaperApi())),
      ],
      child: MaterialApp(
        debugShowCheckedModeBanner: false,
        home: const RootNavigationScreen(),
      ),
    );
  }
}
