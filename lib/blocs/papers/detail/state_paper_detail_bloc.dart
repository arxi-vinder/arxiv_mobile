import 'package:arxivinder/data/model/paper_detail_response.dart';
import 'package:equatable/equatable.dart';

abstract class StatePaperDetailBloc extends Equatable {
  const StatePaperDetailBloc();

  @override
  List<Object?> get props => [];
}

class PaperDetailInitial extends StatePaperDetailBloc {}

class PaperDetailLoading extends StatePaperDetailBloc {}

class PaperDetailLoaded extends StatePaperDetailBloc {
  final PaperDetailResponse paper;

  const PaperDetailLoaded(this.paper);

  @override
  List<Object?> get props => [paper];
}

class PaperDetailError extends StatePaperDetailBloc {
  final String message;
  final String? friendlyMessage;

  const PaperDetailError(this.message, {this.friendlyMessage});

  @override
  List<Object?> get props => [message, friendlyMessage];
}
