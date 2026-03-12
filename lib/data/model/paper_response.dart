import 'package:equatable/equatable.dart';

class PaperResponse extends Equatable {
  final String status;
  final int id;
  final String title;
  final String abstract;
  final String category;

  const PaperResponse({
    required this.status,
    required this.id,
    required this.category,
    required this.title,
    required this.abstract,
  });

  @override
  List<Object?> get props => [id, title, abstract, category];

  factory PaperResponse.fromJson(Map<String, dynamic> json) {
    final data = json['data'] ?? {};
    return PaperResponse(
      status: json['status'],
      id: data['id'],
      category: data['category'],
      title: data['title'],
      abstract: data['abstract'],
    );
  }
}
