import 'package:equatable/equatable.dart';

class StateFeedbackPaperBloc extends Equatable {
  const StateFeedbackPaperBloc();

  @override
  List<Object?> get props => [];
}

class FeedbackLoadInitial extends StateFeedbackPaperBloc {}

class FeedbackLoading extends StateFeedbackPaperBloc {}

class FeedbackSuccess extends StateFeedbackPaperBloc {
  final String msg;
  final int paperId;

  const FeedbackSuccess(this.msg, {required this.paperId});

  @override
  List<Object?> get props => [msg, paperId];
}

class FeedbackFailure extends StateFeedbackPaperBloc {
  final String error;

  const FeedbackFailure(this.error);

  @override
  List<Object?> get props => [error];
}
