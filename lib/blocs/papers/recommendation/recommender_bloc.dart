import 'package:arxivinder/blocs/papers/recommendation/recommender_event_bloc.dart';
import 'package:arxivinder/blocs/papers/recommendation/state_recommender_bloc.dart';
import 'package:arxivinder/data/services/recomm_api.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class RecommenderBloc extends Bloc<RecommenderEventBloc, StateRecommenderBloc> {
  final RecommApi api;

  RecommenderBloc({required this.api}) : super(InitialFetch()) {
    on<GetRecommendation>(_getRecommendationFetched);
    on<RefreshUCBScores>(_refreshUCBScores);
  }

  Future<void> _getRecommendationFetched(
    GetRecommendation event,
    Emitter<StateRecommenderBloc> emit,
  ) async {
    emit(InitialLoading());

    try {
      final res = await api.getPaperRecommendations(event.id);
      emit(InitialSuccess(res));
    } on UnauthorizedException catch (e) {
      debugPrint('Unauthorized fetching recomm: $e');
      emit(InitialUnauthorized(e.message));
    } catch (e) {
      debugPrint('Error fetching recomm: $e');
      emit(InitialFailure(e.toString()));
    }
  }

  Future<void> _refreshUCBScores(
    RefreshUCBScores event,
    Emitter<StateRecommenderBloc> emit,
  ) async {
    emit(InitialLoading());

    try {
      final res = await api.refreshUCBScores(event.paperId, event.topN);
      emit(InitialSuccess(res));
    } on UnauthorizedException catch (e) {
      debugPrint('Unauthorized refreshing UCB: $e');
      emit(InitialUnauthorized(e.message));
    } catch (e) {
      debugPrint('Error refreshing UCB: $e');
      emit(InitialFailure(e.toString()));
    }
  }
}
