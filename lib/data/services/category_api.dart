import 'dart:convert';

import 'package:arxivinder/data/model/category_response.dart';
import 'package:arxivinder/data/model/paper_response.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:http/http.dart' as http;

class CategoryApi {
  final String? baseurl = dotenv.env['BASEURL'];

  Future<List<CategoryResponse>> getCategories() async {
    final url = Uri.parse('$baseurl/api/v1/categories');

    try {
      final response = await http.get(
        url,
        headers: {
          'Content-Type': 'application/json',
          'Accept': 'application/json',
        },
      ).timeout(
        const Duration(seconds: 10),
        onTimeout: () {
          debugPrint('ERROR: Request timeout');
          throw Exception('Request timeout');
        },
      );

      if (response.statusCode >= 200 && response.statusCode < 300) {
        final Map<String, dynamic> datas = jsonDecode(response.body);
        final List<dynamic> dataList = datas['data'] ?? [];
        return dataList.map((item) => CategoryResponse.fromJson(item)).toList();
      } else {
        final Map<String, dynamic> errorData = jsonDecode(response.body);
        throw Exception(
          errorData['message'] ?? 'Gagal mengambil kategori',
        );
      }
    } catch (e) {
      debugPrint('Error: $e');
      throw Exception('Terjadi kesalahan: $e');
    }
  }

  Future<List<PaperResponse>> getPapersByCategory(String categoryName) async {
    final encodedCategory = Uri.encodeComponent(categoryName);
    final url = Uri.parse('$baseurl/api/v1/papers/category/$encodedCategory');

    try {
      final response = await http.get(
        url,
        headers: {
          'Content-Type': 'application/json',
          'Accept': 'application/json',
        },
      ).timeout(
        const Duration(seconds: 10),
        onTimeout: () {
          debugPrint('ERROR: Request timeout');
          throw Exception('Request timeout');
        },
      );

      if (response.statusCode >= 200 && response.statusCode < 300) {
        final Map<String, dynamic> datas = jsonDecode(response.body);
        final List<dynamic> dataList = datas['data'] ?? [];
        return dataList
            .map((item) => PaperResponse.fromJson({'data': item, 'status': 'success'}))
            .toList();
      } else {
        final Map<String, dynamic> errorData = jsonDecode(response.body);
        throw Exception(
          errorData['message'] ?? 'Gagal mengambil paper kategori',
        );
      }
    } catch (e) {
      debugPrint('Error: $e');
      throw Exception('Terjadi kesalahan: $e');
    }
  }
}
