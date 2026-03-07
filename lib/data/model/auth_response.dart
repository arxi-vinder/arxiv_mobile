import 'package:equatable/equatable.dart';

class AuthResponse extends Equatable {
  final String status;
  final String message;
  final String accessToken;
  final String username;
  final dynamic id;
  final String tokenType;

  const AuthResponse({
    required this.status,
    required this.message,
    required this.accessToken,
    required this.username,
    required this.id,
    required this.tokenType,
  });

  factory AuthResponse.fromJson(Map<String, dynamic> json) {
    final data = json['data'] ?? {};

    return AuthResponse(
      status: json['status'] ?? '',
      message: json['message'] ?? '',
      accessToken: data['access_token'] ?? '',
      username: data['username'] ?? '',
      id: data['id'],
      tokenType: data['token_type'] ?? '',
    );
  }

  @override
  List<Object?> get props => [
    status,
    message,
    accessToken,
    username,
    id,
    tokenType,
  ];
}
