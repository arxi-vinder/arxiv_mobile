import 'package:equatable/equatable.dart';

class CategoryResponse extends Equatable {
  final String name;

  const CategoryResponse({required this.name});

  factory CategoryResponse.fromJson(dynamic json) {
    if (json is String) {
      return CategoryResponse(name: json);
    }
    return CategoryResponse(name: json['name'] ?? '');
  }

  @override
  List<Object?> get props => [name];
}
