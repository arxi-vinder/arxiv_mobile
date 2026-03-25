import 'package:equatable/equatable.dart';

class FeedbackRequest extends Equatable {
  final int paperId;
  final int feedbackValue;

  const FeedbackRequest({required this.paperId, required this.feedbackValue});

  Map<String, dynamic> toJson() {
    return {'paper_id': paperId, 'response': feedbackValue};
  }

  @override
  List<Object?> get props => [paperId, feedbackValue];
}
