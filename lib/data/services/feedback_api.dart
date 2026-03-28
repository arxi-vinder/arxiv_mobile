import 'dart:convert';

import 'package:arxivinder/data/model/feedback_request.dart';
import 'package:arxivinder/data/model/paper_recommendation_response.dart';
import 'package:arxivinder/data/services/secure_storage_service.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:http/http.dart' as http;

class FeedbackApi {
  final String? baseurl = dotenv.env['BASEURL'];

  Future<PaperRecommendationResponse> sendFeedback(
    FeedbackRequest request,
  ) async {
    final token = await SecureStorageService.getAccessToken();
    final url = Uri.parse('$baseurl/api/v1/feedback');
    try {
      final response = await http.post(
        url,
        headers: {
          'Content-Type': 'application/json',
          'Accept': 'application/json',
          'Authorization': 'Bearer $token',
        },
        body: jsonEncode(request.toJson()),
      );

      if (response.statusCode >= 200 && response.statusCode < 300) {
        final Map<String, dynamic> data = jsonDecode(response.body);
        return PaperRecommendationResponse.fromJson(data);
      } else {
        try {
          final Map<String, dynamic> errorData = jsonDecode(response.body);
          throw Exception(
            'Gagal melakukan update ucb - Status ${response.statusCode}: ${errorData['message'] ?? response.body}',
          );
        } catch (parseError) {
          throw Exception(
            'Gagal melakukan update ucb - Status ${response.statusCode}: ${response.body}',
          );
        }
      }
    } on Exception {
      rethrow;
    } catch (e) {
      throw Exception('Terjadi kesalahan: $e');
    }
  }
}
