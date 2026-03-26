import 'package:arxivinder/data/model/feedback_request.dart';
import 'package:equatable/equatable.dart';

abstract class FeedbackPaperEvent extends Equatable {
  const FeedbackPaperEvent();
  @override
  List<Object?> get props => [];
}

class FeedbackSubmitted extends FeedbackPaperEvent {
  final FeedbackRequest feedbackRequest;

  const FeedbackSubmitted({required this.feedbackRequest});

  @override
  List<Object?> get props => [feedbackRequest];
}
