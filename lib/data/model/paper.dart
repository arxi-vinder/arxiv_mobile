import 'package:equatable/equatable.dart';

class Paper extends Equatable {
  final int id;
  final String title;
  final String abstract;
  final DateTime publishedDate;
  final String url;
  final String doi;
  final String category;
  final DateTime createdAt;

  const Paper({
    required this.id,
    required this.category,
    required this.title,
    required this.abstract,
    required this.publishedDate,
    required this.url,
    required this.doi,
    required this.createdAt,
  });

  @override
  List<Object?> get props => [
    id,
    title,
    abstract,
    category,
    publishedDate,
    url,
    doi,
    createdAt,
  ];
}
