import 'package:equatable/equatable.dart';

abstract class PaperEventBloc extends Equatable {
  const PaperEventBloc();

  @override
  List<Object?> get props => [];
}

class GetAllPapers extends PaperEventBloc {
  const GetAllPapers();
}

class GetPapersSortedBy extends PaperEventBloc {
  final String sort; // 'newest' or 'oldest'
  final int? limit;

  const GetPapersSortedBy({
    required this.sort,
    this.limit,
  });

  @override
  List<Object?> get props => [sort, limit];
}

class GetPapersByDateRange extends PaperEventBloc {
  final DateTime startDate;
  final DateTime endDate;
  final String? sort;
  final int? limit;

  const GetPapersByDateRange({
    required this.startDate,
    required this.endDate,
    this.sort,
    this.limit,
  });

  @override
  List<Object?> get props => [startDate, endDate, sort, limit];
}
