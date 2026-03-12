import 'dart:convert';

import 'package:arxivinder/data/model/paper_response.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:http/http.dart' as http;

class PapersApi {
  final String? baseurl = dotenv.env['BASEURL'];

  Future<List<PaperResponse>> getPapers() async {
    final url = Uri.parse('$baseurl/api/v1/papers');

    try {
      final response = await http.get(
        url,
        headers: {
          'Content-Type': 'application/json',
          'Accept': 'application/json',
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
          errorData['message'] ?? 'Gagal melakukan Fetching data',
        );
      }
    } catch (e) {
      throw Exception('Terjadi kesalahan: $e');
    }
  }
}
