import 'package:equatable/equatable.dart';

abstract class DetailPaperEvent extends Equatable {
  const DetailPaperEvent();

  @override
  List<Object?> get props => [];
}

class GetDetailPaper extends DetailPaperEvent {
  final int id;

  const GetDetailPaper(this.id);

  @override
  List<Object?> get props => [id];
}
