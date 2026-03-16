import 'package:equatable/equatable.dart';

class PaperDetailResponse extends Equatable {
  final String title;
  final String abstract;
  final String category;
  final int id;
  final String url;
  final String author;

  const PaperDetailResponse({
    required this.title,
    required this.abstract,
    required this.category,
    required this.id,
    required this.url,
    required this.author,
  });

  factory PaperDetailResponse.fromJson(Map<String, dynamic> json) {
    final data = json['detail'] ?? json;
    return PaperDetailResponse(
      title: data['title'] ?? '',
      abstract: data['abstract'] ?? '',
      category: data['category'] ?? '',
      id: data['id'] ?? 0,
      url: data['url'] ?? '',
      author: data['author'] ?? '',
    );
  }

  @override
  List<Object?> get props => [title, abstract, category, id, url, author];
}
