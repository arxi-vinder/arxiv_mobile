import 'package:equatable/equatable.dart';

abstract class PaperEventBloc extends Equatable {
  const PaperEventBloc();

  @override
  List<Object?> get props => [];
}

class GetAllPapers extends PaperEventBloc {
  const GetAllPapers();
}
