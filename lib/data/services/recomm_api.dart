import 'dart:convert';

import 'package:arxivinder/data/model/paper_recommendation_response.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:http/http.dart' as http;

class RecommApi {
  final String? baseurl = dotenv.env['BASEURL'];

  Future<List<PaperRecommendationResponse>> getPaperRecommendations(
    int id,
  ) async {
    final url = Uri.parse("$baseurl/api/v1/recommend/$id");

    try {
      final response = await http
          .get(url)
          .timeout(
            const Duration(seconds: 10),
            onTimeout: () {
              debugPrint('ERROR: Request timeout');
              throw Exception('Request timeout');
            },
          );

      if (response.statusCode == 200) {
        final Map<String, dynamic> datas = jsonDecode(response.body);
        final List<dynamic> items = datas['data']['recommendations'];

        debugPrint("Items: $items");
        return items
            .map((item) => PaperRecommendationResponse.fromJson(item))
            .toList()
          ..sort((a, b) => b.ucbScore.compareTo(a.ucbScore));
      } else {
        debugPrint('ERROR: Status code ${response.statusCode}');
        throw Exception(
          'Gagal mengambil rekomendasi paper: ${response.statusCode}',
        );
      }
    } catch (e) {
      debugPrint('Error: $e');
      throw Exception('Terjadi kesalahan: $e');
    }
  }
}
