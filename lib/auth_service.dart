import 'dart:convert';

import 'package:http/http.dart' as http;
import 'package:shared_preferences/shared_preferences.dart';

import 'auth_config.dart';

class AuthService {
  static Future<String?> exchangeCodeForToken({
    required String authorizationCode,
    required String codeVerifier,
  }) async {
    try {
      final response = await http.post(
        Uri.parse(OAuthConfig.tokenEndpoint),
        headers: {'Content-Type': 'application/x-www-form-urlencoded'},
        body: {
          'grant_type': 'authorization_code',
          'client_id': OAuthConfig.clientId,
          'code': authorizationCode,
          'redirect_uri': OAuthConfig.redirectUri,
          'code_verifier': codeVerifier,
        },
      );

      if (response.statusCode == 200) {
        final data = jsonDecode(response.body);
        return data['access_token'];
      } else {
        return null;
      }
    } catch (e) {
      return null;
    }
  }
}

class TokenStorage {
  static const String _tokenKey = 'hackatime_token';
  static const String _verifierKey = 'hackatime_code_verifier';

  static Future<void> saveVerifier(String verifier) async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setString(_verifierKey, verifier);
  }

  static Future<String?> getVerifier() async {
    final prefs = await SharedPreferences.getInstance();
    return prefs.getString(_verifierKey);
  }

  static Future<void> saveToken(String token) async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setString(_tokenKey, token);
  }

  static Future<String?> getToken() async {
    final prefs = await SharedPreferences.getInstance();
    return prefs.getString(_tokenKey);
  }

  static Future<bool> isLoggedIn() async {
    final token = await getToken();
    return token != null && token.isNotEmpty;
  }

  static Future<void> logout() async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.remove(_tokenKey);
    await prefs.remove(_verifierKey);
  }
}
