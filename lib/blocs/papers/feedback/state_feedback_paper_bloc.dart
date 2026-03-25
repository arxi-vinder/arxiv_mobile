import 'package:equatable/equatable.dart';

class StateFeedbackPaperBloc extends Equatable {
  const StateFeedbackPaperBloc();

  @override
  List<Object?> get props => [];
}

class FeedbackLoadInitial extends StateFeedbackPaperBloc {}

class FeedbackSuccess extends StateFeedbackPaperBloc {
  final String msg;

  const FeedbackSuccess(this.msg);

  @override
  List<Object?> get props => [msg];
}

class FeedbackLoading extends StateFeedbackPaperBloc {}

class FeedbackFailure extends StateFeedbackPaperBloc {
  final String error;

  const FeedbackFailure(this.error);

  @override
  List<Object?> get props => [error];
}
