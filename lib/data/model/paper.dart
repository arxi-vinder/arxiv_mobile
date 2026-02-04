import 'package:equatable/equatable.dart';

class Paper extends Equatable {
  final int id;
  final String title;
  final String abstract;
  final DateTime publishedDate;
  final String url;
  final String doi;
  final DateTime createdAt;

  const Paper({
    required this.id,
    required this.title,
    required this.abstract,
    required this.publishedDate,
    required this.url,
    required this.doi,
    required this.createdAt,
  });

  @override
  List<Object?> get props => [];
}
