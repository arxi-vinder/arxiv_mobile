import 'package:arxivinder/data/model/paper_recommendation_response.dart';
import 'package:equatable/equatable.dart';

class StateRecommenderBloc extends Equatable {
  @override
  List<Object?> get props => [];
}

class InitialFetch extends StateRecommenderBloc {}

class InitialLoading extends StateRecommenderBloc {}

class InitialSuccess extends StateRecommenderBloc {
  final List<PaperRecommendationResponse> papers;

  InitialSuccess(this.papers);

  @override
  List<Object?> get props => [papers];
}

class InitialFailure extends StateRecommenderBloc {
  final String error;

  InitialFailure(this.error);

  @override
  List<Object?> get props => [error];
}
