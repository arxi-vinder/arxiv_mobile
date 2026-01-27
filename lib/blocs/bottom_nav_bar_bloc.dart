import 'package:arxivinder/data/events/bottom_navigation_event.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class BottomNavBarBloc extends Bloc<BottomNavigationEvent, int> {
  BottomNavBarBloc() : super(0) {
    on<BottomNavigationEvent>((event, emit) {
      switch (event) {
        case BottomNavigationEvent.home:
          emit(0);
        case BottomNavigationEvent.profile:
          emit(1);
      }
    });
  }
}
