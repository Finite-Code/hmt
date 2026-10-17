import 'dart:convert';

import 'package:http/http.dart' as http;

import 'auth_service.dart';

class WebClerk {
  static const apiBase = 'https://hackatime.hackclub.com';
  static String? _cachedToken;

  static Future<Map<String, String>> _headers() async {
    _cachedToken ??= await TokenStorage.getToken();
    return {
      'Authorization': 'Bearer ${_cachedToken ?? ''}',
      'Accept': 'application/json',
    };
  }

  // call this on logout so old token doesn't linger in memory
  static void invalidateTokenCache() {
    _cachedToken = null;
  }

  static Future<Map<String, dynamic>> me() async {
    final r = await http.get(
      Uri.parse('$apiBase/api/v1/authenticated/me'),
      headers: await _headers(),
    );
    return jsonDecode(r.body);
  }

  static Future<double> loggedHours() async {
    final r = await http.get(
      Uri.parse('$apiBase/api/v1/authenticated/hours'),
      headers: await _headers(),
    );
    final body = jsonDecode(r.body);
    return (body['total_seconds'] as num).toDouble();
  }

  static Future<int> streakDays() async {
    final r = await http.get(
      Uri.parse('$apiBase/api/v1/authenticated/streak'),
      headers: await _headers(),
    );
    return jsonDecode(r.body)['streak_days'] as int;
  }

  static Future<Map<String, dynamic>> latestBeat() async {
    final r = await http.get(
      Uri.parse('$apiBase/api/v1/my/heartbeats/most_recent'),
      headers: await _headers(),
    );
    return jsonDecode(r.body);
  }

  static Future<Map<String, dynamic>> weeklyStats() async {
    final r = await http.get(
      Uri.parse('$apiBase/api/v1/users/current/stats/last_7_days'),
      headers: await _headers(),
    );
    final payload = jsonDecode(r.body);
    return payload['data'] ?? {};
  }

  // hackatime returns 503 if the weekly leaderboard is mid-generation
  static Future<List<dynamic>> topHackers() async {
    final r = await http.get(Uri.parse('$apiBase/api/v1/leaderboard/weekly'));
    if (r.statusCode != 200) return [];
    return jsonDecode(r.body)['entries'] ?? [];
  }

  static Future<List<dynamic>> liveHackers() async {
    final r = await http.get(Uri.parse('$apiBase/api/v1/currently_hacking'));
    return jsonDecode(r.body)['users'] ?? [];
  }
}
