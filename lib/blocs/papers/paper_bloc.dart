import 'package:arxivinder/blocs/papers/paper_event_bloc.dart';
import 'package:arxivinder/blocs/papers/paper_state_bloc.dart';
import 'package:arxivinder/data/services/papers_api.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class PaperBloc extends Bloc<PaperEventBloc, PaperStateBloc> {
  final PapersApi api;

  PaperBloc({required this.api}) : super(FetchInitial()) {
    on<GetAllPapers>(_getPaperFetched);
    on<GetPapersSortedBy>(_getPapersSortedBy);
    on<GetPapersByDateRange>(_getPapersByDateRange);
  }

  Future<void> _getPaperFetched(
    GetAllPapers event,
    Emitter<PaperStateBloc> emit,
  ) async {
    emit(FetchLoading());

    try {
      final papers = await api.getPapers();
      emit(FetchSuccess(papers));
    } catch (e) {
      emit(FetchFailure(e.toString()));
    }
  }

  Future<void> _getPapersSortedBy(
    GetPapersSortedBy event,
    Emitter<PaperStateBloc> emit,
  ) async {
    emit(FetchLoading());

    try {
      final papers = await api.getPapers(
        sort: event.sort,
        limit: event.limit,
      );
      emit(FetchSuccess(
        papers,
        sortBy: event.sort,
      ));
    } catch (e) {
      emit(FetchFailure(e.toString()));
    }
  }

  Future<void> _getPapersByDateRange(
    GetPapersByDateRange event,
    Emitter<PaperStateBloc> emit,
  ) async {
    emit(FetchLoading());

    try {
      final papers = await api.getPapers(
        startDate: event.startDate,
        endDate: event.endDate,
        sort: event.sort,
        limit: event.limit,
      );
      emit(FetchSuccess(
        papers,
        sortBy: event.sort,
        startDate: event.startDate,
        endDate: event.endDate,
      ));
    } catch (e) {
      emit(FetchFailure(e.toString()));
    }
  }
}
