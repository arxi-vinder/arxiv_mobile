import 'package:arxivinder/blocs/papers/detail/detail_paper_event.dart';
import 'package:arxivinder/blocs/papers/detail/state_paper_detail_bloc.dart';
import 'package:arxivinder/data/services/detail_paper_api.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class DetailPaperBloc extends Bloc<DetailPaperEvent, StatePaperDetailBloc> {
  final DetailPaperApi api;

  DetailPaperBloc({required this.api}) : super(PaperDetailInitial()) {
    on<GetDetailPaper>(_getDetailPaper);
  }

  Future<void> _getDetailPaper(
    GetDetailPaper event,
    Emitter<StatePaperDetailBloc> emit,
  ) async {
    emit(PaperDetailLoading());

    try {
      debugPrint('Fetching detail for id: ${event.id}');
      final result = await api.getPaper(event.id);
      debugPrint('Fetched paper: ${result.title}, id: ${result.id}');
      emit(PaperDetailLoaded(result));
    } catch (e) {
      debugPrint('Error fetching detail: $e');
      emit(PaperDetailError(e.toString()));
    }
  }
}
