import 'package:flutter/widgets.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';

class SecureStorageService {
  static const _storage = FlutterSecureStorage();

  static const String _accessTokenKey = 'access_token';
  static const String _usernameKey = 'username';
  static const String _userIdKey = 'user_id';

  static Future<void> saveUserData(
    String accessToken,
    String username,
    String userId,
  ) async {
    
    debugPrint(
      'Saving user data: token=$accessToken, username=$username, userId=$userId',
    );
    await _storage.write(key: _accessTokenKey, value: accessToken);
    await _storage.write(key: _usernameKey, value: username);
    await _storage.write(key: _userIdKey, value: userId);
  }

  static Future<String?> getAccessToken() async {
    return await _storage.read(key: _accessTokenKey);
  }

  static Future<String?> getUsername() async {
    return await _storage.read(key: _usernameKey);
  }

  static Future<String?> getUserId() async {
    return await _storage.read(key: _userIdKey);
  }

  static Future<Map<String, String?>> getUserData() async {
    final accessToken = await getAccessToken();
    final username = await getUsername();
    final userId = await getUserId();
    return {'accessToken': accessToken, 'username': username, 'userId': userId};
  }

  
  static Future<void> clearUserData() async {
    await _storage.delete(key: _accessTokenKey);
    await _storage.delete(key: _usernameKey);
    await _storage.delete(key: _userIdKey);
  }

  
  static Future<bool> isLoggedIn() async {
    final token = await getAccessToken();
    final username = await getUsername();
    return token != null &&
        token.isNotEmpty &&
        username != null &&
        username.isNotEmpty;
  }
}
