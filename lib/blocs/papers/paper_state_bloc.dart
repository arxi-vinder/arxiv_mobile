import 'package:arxivinder/data/model/paper_response.dart';
import 'package:equatable/equatable.dart';

class PaperStateBloc extends Equatable {
  const PaperStateBloc();
  @override
  List<Object?> get props => [];
}

class FetchInitial extends PaperStateBloc {}

class FetchLoading extends PaperStateBloc {}

class FetchSuccess extends PaperStateBloc {
  final List<PaperResponse> papers;

  const FetchSuccess(this.papers);

  @override
  List<Object?> get props => [papers];
}

class FetchFailure extends PaperStateBloc {
  final String error;

  const FetchFailure(this.error);

  @override
  List<Object?> get props => [error];
}
