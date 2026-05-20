import 'dart:convert';

import 'package:arxivinder/data/model/paper_response.dart';
import 'package:arxivinder/data/services/secure_storage_service.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:http/http.dart' as http;

class PapersApi {
  final String? baseurl = dotenv.env['BASEURL'];

  Future<List<PaperResponse>> getPapers({
    String? sort,
    int? limit,
    DateTime? startDate,
    DateTime? endDate,
  }) async {
    final queryParams = <String, String>{};

    if (sort != null) queryParams['sort'] = sort;
    if (limit != null) queryParams['limit'] = limit.toString();
    if (startDate != null) {
      queryParams['start_date'] = startDate.toIso8601String();
    }
    if (endDate != null) {
      queryParams['end_date'] = endDate.toIso8601String();
    }

    final uri = Uri.parse(
      '$baseurl/api/v1/papers',
    ).replace(queryParameters: queryParams.isNotEmpty ? queryParams : null);

    try {
      debugPrint('Fetching papers from: $uri');
      final response = await http
          .get(
            uri,
            headers: {
              'Content-Type': 'application/json',
              'Accept': 'application/json',
            },
          )
          .timeout(
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
            .map(
              (item) =>
                  PaperResponse.fromJson({'data': item, 'status': 'success'}),
            )
            .toList();
      } else {
        final Map<String, dynamic> errorData = jsonDecode(response.body);
        throw Exception(errorData['message'] ?? 'Failed to fetch papers');
      }
    } catch (e) {
      debugPrint('Error fetching papers: $e');
      throw Exception('An error occurred: $e');
    }
  }

  Future<List<PaperResponse>> searchPaperByName(String name) async {
    final token = await SecureStorageService.getAccessToken();
    final queryParams = <String, String>{'name': name};

    final uri = Uri.parse(
      '$baseurl/api/v1/papers/search',
    ).replace(queryParameters: queryParams);

    try {
      debugPrint('Searching papers: $uri');
      final response = await http
          .get(
            uri,
            headers: {
              'Content-Type': 'application/json',
              'Accept': 'application/json',
              'Authorization': 'Bearer $token',
            },
          )
          .timeout(
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
            .map(
              (item) =>
                  PaperResponse.fromJson({'data': item, 'status': 'success'}),
            )
            .toList();
      } else {
        final Map<String, dynamic> errorData = jsonDecode(response.body);
        throw Exception(errorData['message'] ?? 'Failed to search papers');
      }
    } catch (e) {
      debugPrint('Error searching papers: $e');
      throw Exception('An error occurred: $e');
    }
  }
}
