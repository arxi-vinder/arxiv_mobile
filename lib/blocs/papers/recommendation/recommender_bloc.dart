import 'package:arxivinder/blocs/papers/recommendation/recommender_event_bloc.dart';
import 'package:arxivinder/blocs/papers/recommendation/state_recommender_bloc.dart';
import 'package:arxivinder/data/services/recomm_api.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class RecommenderBloc extends Bloc<RecommenderEventBloc, StateRecommenderBloc> {
  final RecommApi api;

  RecommenderBloc({required this.api}) : super(InitialFetch()) {
    on<GetRecommendation>(_getRecommendationFetched);
  }

  Future<void> _getRecommendationFetched(
    GetRecommendation event,
    Emitter<StateRecommenderBloc> emit,
  ) async {
    emit(InitialLoading());

    try {
      final res = await api.getPaperRecommendations(event.id);
      emit(InitialSuccess(res));
    } catch (e) {
      debugPrint('Error fetching recomm: $e');
      emit(InitialFailure(e.toString()));
    }
  }
}
