import 'package:arxivinder/blocs/papers/feedback/feedback_paper_event.dart';
import 'package:arxivinder/blocs/papers/feedback/state_feedback_paper_bloc.dart';
import 'package:arxivinder/data/services/feedback_api.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class FeedbackPaperBloc
    extends Bloc<FeedbackPaperEvent, StateFeedbackPaperBloc> {
  final FeedbackApi feedbackApi;
  final Map<int, int> _feedbackMap = {};
  Map<int, int> get feedbackMap => Map.unmodifiable(_feedbackMap);

  FeedbackPaperBloc({required this.feedbackApi})
      : super(FeedbackLoadInitial()) {
    on<FeedbackSubmitted>(_onFeedbackSubmitted);
    on<FeedbackReset>(_onFeedbackReset);
  }

  Future<void> _onFeedbackSubmitted(
    FeedbackSubmitted event,
    Emitter<StateFeedbackPaperBloc> emit,
  ) async {
    emit(FeedbackLoading());

    try {
      final response = await feedbackApi.sendFeedback(event.feedbackRequest);
      if (response.status == 'success' || response.status == '200') {
        _feedbackMap[event.feedbackRequest.paperId] =
            event.feedbackRequest.feedbackValue;
        emit(FeedbackSuccess(
          response.status,
          paperId: event.feedbackRequest.paperId,
        ));
      } else {
        emit(FeedbackFailure(response.status));
      }
    } catch (e) {
      emit(FeedbackFailure(e.toString()));
    }
  }

  void _onFeedbackReset(
    FeedbackReset event,
    Emitter<StateFeedbackPaperBloc> emit,
  ) {
    _feedbackMap.clear();
    emit(FeedbackLoadInitial());
  }
}
