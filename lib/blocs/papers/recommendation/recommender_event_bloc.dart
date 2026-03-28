import 'package:equatable/equatable.dart';

abstract class RecommenderEventBloc extends Equatable {
  const RecommenderEventBloc();
  @override
  List<Object?> get props => [];
}

class GetRecommendation extends RecommenderEventBloc {
  final int id;

  const GetRecommendation(this.id);

  @override
  List<Object?> get props => [id];
}
