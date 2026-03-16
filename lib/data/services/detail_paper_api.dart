import 'dart:convert';

import 'package:arxivinder/data/model/paper_detail_response.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:http/http.dart' as http;

class DetailPaperApi {
  final String? baseurl = dotenv.env['BASEURL'];

  Future<PaperDetailResponse> getPaper(int id) async {
    final url = Uri.parse('$baseurl/api/v1/paper/$id');
    debugPrint('URL: $url');

    try {
      final response = await http.get(url).timeout(
        const Duration(seconds: 10),
        onTimeout: () {
          debugPrint('ERROR: Request timeout');
          throw Exception('Request timeout');
        },
      );

      debugPrint('Status Code: ${response.statusCode}');
      debugPrint('Response body: ${response.body}');
      
      if (response.statusCode == 200) {
        final data = jsonDecode(response.body);
        debugPrint('Decoded data: $data');
        return PaperDetailResponse.fromJson(data);
      } else {
        debugPrint('ERROR: Status code ${response.statusCode}');
        throw Exception('Gagal mengambil detail paper: ${response.statusCode}');
      }
    } catch (e) {
      debugPrint('Error: $e');
      throw Exception('Terjadi kesalahan: $e');
    }
  }
}
