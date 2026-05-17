import 'package:equatable/equatable.dart';

abstract class CategoryEvent extends Equatable {
  const CategoryEvent();

  @override
  List<Object?> get props => [];
}

class FetchCategories extends CategoryEvent {
  const FetchCategories();
}

class FetchPapersByCategory extends CategoryEvent {
  final String categoryName;

  const FetchPapersByCategory(this.categoryName);

  @override
  List<Object?> get props => [categoryName];
}
