import 'dart:async';
import 'dart:convert';
import 'package:http/http.dart' as http;

/// Exception thrown when an external API request fails.
class ApiException implements Exception {
  final String message;
  final int? statusCode;
  final bool isRateLimit;

  const ApiException(
    this.message, {
    this.statusCode,
    this.isRateLimit = false,
  });

  @override
  String toString() => message;
}

/// Lightweight HTTP client with response caching, timeouts, and error mapping.
class ApiClient {
  final http.Client _client;
  final Map<String, String> _cache = {};

  ApiClient({http.Client? client}) : _client = client ?? http.Client();

  Future<Map<String, dynamic>> getJson(
    Uri uri, {
    Duration timeout = const Duration(seconds: 15),
    bool useCache = true,
  }) async {
    final key = uri.toString();
    if (useCache && _cache.containsKey(key)) {
      return jsonDecode(_cache[key]!) as Map<String, dynamic>;
    }

    final body = await _getRaw(uri, timeout: timeout);
    try {
      final decoded = jsonDecode(body);
      if (decoded is Map<String, dynamic>) {
        if (useCache) _cache[key] = body;
        return decoded;
      }
      throw const ApiException('Unexpected response format from server.');
    } on FormatException {
      throw const ApiException('Failed to parse server JSON response.');
    }
  }

  Future<String> getText(
    Uri uri, {
    Duration timeout = const Duration(seconds: 20),
    bool useCache = true,
  }) async {
    final key = 'txt:$uri';
    if (useCache && _cache.containsKey(key)) {
      return _cache[key]!;
    }
    final body = await _getRaw(uri, timeout: timeout);
    if (useCache) _cache[key] = body;
    return body;
  }

  Future<String> _getRaw(Uri uri, {required Duration timeout}) async {
    try {
      final response = await _client.get(uri).timeout(timeout);
      if (response.statusCode == 200) {
        return response.body;
      }
      if (response.statusCode == 429) {
        throw const ApiException(
          'Rate limit reached (HTTP 429). Showing available results.',
          statusCode: 429,
          isRateLimit: true,
        );
      }
      throw ApiException(
        'Request failed with status ${response.statusCode}.',
        statusCode: response.statusCode,
      );
    } on TimeoutException {
      throw const ApiException(
        'The request timed out. Please try again.',
      );
    } on ApiException {
      rethrow;
    } catch (e) {
      throw ApiException(
        'Unable to reach the server (${e.runtimeType}). Check your connection or CORS settings.',
      );
    }
  }
}

