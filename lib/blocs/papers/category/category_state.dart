import 'package:arxivinder/data/model/category_response.dart';
import 'package:arxivinder/data/model/paper_response.dart';
import 'package:equatable/equatable.dart';

abstract class CategoryState extends Equatable {
  const CategoryState();

  @override
  List<Object?> get props => [];
}

class CategoryInitial extends CategoryState {
  const CategoryInitial();
}

class CategoryLoading extends CategoryState {
  const CategoryLoading();
}

class CategoryLoaded extends CategoryState {
  final List<CategoryResponse> categories;
  final String? selectedCategory;
  final List<PaperResponse>? papers;
  final bool isLoadingPapers;

  const CategoryLoaded({
    required this.categories,
    this.selectedCategory,
    this.papers,
    this.isLoadingPapers = false,
  });

  @override
  List<Object?> get props => [categories, selectedCategory, papers, isLoadingPapers];

  CategoryLoaded copyWith({
    List<CategoryResponse>? categories,
    String? selectedCategory,
    List<PaperResponse>? papers,
    bool? isLoadingPapers,
  }) {
    return CategoryLoaded(
      categories: categories ?? this.categories,
      selectedCategory: selectedCategory ?? this.selectedCategory,
      papers: papers ?? this.papers,
      isLoadingPapers: isLoadingPapers ?? this.isLoadingPapers,
    );
  }
}

class CategoryError extends CategoryState {
  final String message;
  final String? friendlyMessage;

  const CategoryError(this.message, {this.friendlyMessage});

  @override
  List<Object?> get props => [message, friendlyMessage];
}
