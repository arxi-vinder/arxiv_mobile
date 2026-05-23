import 'package:arxivinder/data/model/paper_response.dart';
import 'package:equatable/equatable.dart';

class PaperStateBloc extends Equatable {
  const PaperStateBloc();
  @override
  List<Object?> get props => [];
}

class FetchInitial extends PaperStateBloc {}

class FetchLoading extends PaperStateBloc {}

class FetchSuccess extends PaperStateBloc {
  final List<PaperResponse> papers;
  final String? sortBy; // 'newest', 'oldest', or null
  final DateTime? startDate;
  final DateTime? endDate;

  const FetchSuccess(
    this.papers, {
    this.sortBy,
    this.startDate,
    this.endDate,
  });

  @override
  List<Object?> get props => [papers, sortBy, startDate, endDate];

  FetchSuccess copyWith({
    List<PaperResponse>? papers,
    String? sortBy,
    DateTime? startDate,
    DateTime? endDate,
  }) {
    return FetchSuccess(
      papers ?? this.papers,
      sortBy: sortBy ?? this.sortBy,
      startDate: startDate ?? this.startDate,
      endDate: endDate ?? this.endDate,
    );
  }
}

class FetchFailure extends PaperStateBloc {
  final String error;
  final String? friendlyMessage;

  const FetchFailure(this.error, {this.friendlyMessage});

  @override
  List<Object?> get props => [error, friendlyMessage];
}
