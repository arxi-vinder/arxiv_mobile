import 'package:arxivinder/blocs/papers/category/category_event.dart';
import 'package:arxivinder/blocs/papers/category/category_state.dart';
import 'package:arxivinder/data/services/category_api.dart';
import 'package:arxivinder/utils/error_handler.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class CategoryBloc extends Bloc<CategoryEvent, CategoryState> {
  final CategoryApi api;

  CategoryBloc({required this.api}) : super(const CategoryInitial()) {
    on<FetchCategories>(_onFetchCategories);
    on<FetchPapersByCategory>(_onFetchPapersByCategory);
  }

  Future<void> _onFetchCategories(
    FetchCategories event,
    Emitter<CategoryState> emit,
  ) async {
    emit(const CategoryLoading());

    try {
      final categories = await api.getCategories();
      emit(CategoryLoaded(categories: categories));
    } catch (e) {
      emit(CategoryError(e.toString(),
          friendlyMessage: ErrorHandler.getErrorMessage(e)));
    }
  }

  Future<void> _onFetchPapersByCategory(
    FetchPapersByCategory event,
    Emitter<CategoryState> emit,
  ) async {
    if (state is CategoryLoaded) {
      final currentState = state as CategoryLoaded;
      emit(currentState.copyWith(isLoadingPapers: true));
    }

    try {
      final papers = await api.getPapersByCategory(event.categoryName);

      if (state is CategoryLoaded) {
        final currentState = state as CategoryLoaded;
        emit(
          currentState.copyWith(
            selectedCategory: event.categoryName,
            papers: papers,
            isLoadingPapers: false,
          ),
        );
      }
    } catch (e) {
      if (state is CategoryLoaded) {
        final currentState = state as CategoryLoaded;
        emit(currentState.copyWith(isLoadingPapers: false));
      }
      emit(CategoryError(e.toString(),
          friendlyMessage: ErrorHandler.getErrorMessage(e)));
    }
  }
}
