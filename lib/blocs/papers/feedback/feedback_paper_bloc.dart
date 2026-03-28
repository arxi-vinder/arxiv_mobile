import 'package:arxivinder/blocs/papers/feedback/feedback_paper_event.dart';
import 'package:arxivinder/blocs/papers/feedback/state_feedback_paper_bloc.dart';
import 'package:arxivinder/data/services/feedback_api.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class FeedbackPaperBloc
    extends Bloc<FeedbackPaperEvent, StateFeedbackPaperBloc> {
  final FeedbackApi feedbackApi;

  FeedbackPaperBloc({required this.feedbackApi})
    : super(FeedbackLoadInitial()) {
    on<FeedbackSubmitted>(_onFeedbackSubmitted);
  }

  Future<void> _onFeedbackSubmitted(
    FeedbackSubmitted event,
    Emitter<StateFeedbackPaperBloc> emit,
  ) async {
    emit(FeedbackLoading());

    try {
      final response = await feedbackApi.sendFeedback(event.feedbackRequest);
      if (response.status == 'success' || response.status == '200') {
        emit(FeedbackSuccess(response.status));
      } else {
        emit(FeedbackFailure(response.status));
      }
    } catch (e) {
      emit(FeedbackFailure(e.toString()));
    }
  }
}
