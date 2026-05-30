import 'package:equatable/equatable.dart';

class CategoryResponse extends Equatable {
  final String name;

  const CategoryResponse({required this.name});

  factory CategoryResponse.fromJson(dynamic json) {
    if (json is String) {
      final decodedName = _decodeName(json);
      return CategoryResponse(name: decodedName);
    }
    final nameValue = json['name'] ?? '';
    final decodedName = _decodeName(nameValue);
    return CategoryResponse(name: decodedName);
  }

  static String _decodeName(String name) {
    try {
      return Uri.decodeComponent(name).replaceAll('%20', ' ').replaceAll('%28', '(').replaceAll('%29', ')');
    } catch (_) {
      return name;
    }
  }

  @override
  List<Object?> get props => [name];
}
