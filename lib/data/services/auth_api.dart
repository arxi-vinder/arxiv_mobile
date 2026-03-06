import 'dart:convert';
import 'package:arxivinder/data/model/auth_request.dart';
import 'package:http/http.dart' as http;
import 'package:arxivinder/data/model/auth_response.dart';

class AuthApi {
  final String baseurl = "https://c178-157-85-211-134.ngrok-free.app";

  Future<AuthResponse> register(AuthRequest request) async {
    final url = Uri.parse('$baseurl/api/v1/auth/register');

    try {
      final response = await http.post(
        url,
        headers: {
          'Content-Type': 'application/json',
          'Accept': 'application/json',
        },
        body: jsonEncode(request.toJson()),
      );

      if (response.statusCode >= 200 && response.statusCode < 300) {
        final Map<String, dynamic> data = jsonDecode(response.body);
        return AuthResponse.fromJson(data);
      } else {
        final Map<String, dynamic> errorData = jsonDecode(response.body);
        throw Exception(errorData['message'] ?? 'Gagal melakukan registrasi');
      }
    } catch (e) {
      throw Exception('Terjadi kesalahan: $e');
    }
  }

  Future<AuthResponse> login(AuthRequest request) async {
    final url = Uri.parse('$baseurl/api/v1/auth/login');

    try {
      final response = await http.post(
        url,
        headers: {
          'Content-Type': 'application/json',
          'Accept': 'application/json',
        },
        body: jsonEncode(request.toJson()),
      );

      if (response.statusCode >= 200 && response.statusCode < 300) {
        final Map<String, dynamic> data = jsonDecode(response.body);
        return AuthResponse.fromJson(data);
      } else {
        final Map<String, dynamic> errorData = jsonDecode(response.body);
        throw Exception(errorData['message'] ?? 'Gagal melakukan login');
      }
    } catch (e) {
      throw Exception('Terjadi kesalahan: $e');
    }
  }
}
