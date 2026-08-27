import 'dart:async';
import 'dart:convert';

import 'package:flutter/foundation.dart';
import 'package:http/http.dart' as http;

import '../models/raji_context.dart';
import '../models/raji_message.dart';
import 'raji_local_responder.dart';

/// Flutter API client for the Raji AI assistant.
///
/// Flutter:
///   RajiChatWidget
///        ↓
///   RajiProvider
///        ↓
///   RajiClient
///        ↓
///   AfaanKoo Raji Backend
///        ↓
///   Open-source AI model
///
class RajiClient {
  final String baseUrl;

  final http.Client _httpClient;

  /// Maximum time allowed for an API request.
  final Duration timeout;

  RajiClient({
    required this.baseUrl,
    http.Client? httpClient,
    this.timeout = const Duration(seconds: 60),
  }) : _httpClient = httpClient ?? http.Client();

  // ============================================================
  // BASE URL
  // ============================================================

  String get _cleanBaseUrl {
    return baseUrl.trim().replaceFirst(
          RegExp(r'/+$'),
          '',
        );
  }

  // ============================================================
  // SEND MESSAGE
  // ============================================================

  Future<RajiMessage> sendMessage({
    required String message,
    required RajiContext context,
    List<RajiMessage> history = const [],
  }) async {
    final cleanMessage = message.trim();

    if (cleanMessage.isEmpty) {
      throw const RajiApiException(
        message: 'Ergaa duwwaa Rajiif erguun hin danda\'amu.',
      );
    }

    if (_cleanBaseUrl.isEmpty) {
      return RajiLocalResponder.respond(
        message: cleanMessage,
        context: context,
      );
    }

    final uri = Uri.parse(
      '$_cleanBaseUrl/api/raji/chat',
    );

    // ==========================================================
    // CONVERSATION HISTORY
    // ==========================================================

    final historyJson = history.map((item) {
      return {
        'role': item.isUser ? 'user' : 'assistant',
        'message': item.text,
      };
    }).toList();

    // ==========================================================
    // REQUEST BODY
    // ==========================================================

    final requestBody = <String, dynamic>{
      'message': cleanMessage,

      // Complete child context.
      'profile': context.toJson(),

      // Previous conversation.
      'history': historyJson,
    };

    debugPrint(
      '🤖 Raji → POST $uri',
    );

    try {
      final response = await _httpClient
          .post(
            uri,
            headers: const {
              'Content-Type': 'application/json',
              'Accept': 'application/json',
            },
            body: jsonEncode(requestBody),
          )
          .timeout(timeout);

      debugPrint(
        '🤖 Raji ← HTTP ${response.statusCode}',
      );

      // ========================================================
      // HTTP ERROR
      // ========================================================

      if (response.statusCode < 200 ||
          response.statusCode >= 300) {
        // Keep the assistant useful when an optional hosted backend is down
        // or has not been deployed at the configured address.
        if (response.statusCode == 404 || response.statusCode >= 500) {
          return RajiLocalResponder.respond(
            message: cleanMessage,
            context: context,
          );
        }
        throw RajiApiException(
          message: _extractErrorMessage(
            response.body,
            response.statusCode,
          ),
          statusCode: response.statusCode,
        );
      }

      // ========================================================
      // EMPTY RESPONSE
      // ========================================================

      if (response.body.trim().isEmpty) {
        throw RajiApiException(
          message: 'Raji deebii duwwaa erge.',
          statusCode: response.statusCode,
        );
      }

      // ========================================================
      // DECODE JSON
      // ========================================================

      dynamic decoded;

      try {
        decoded = jsonDecode(response.body);
      } catch (_) {
        throw RajiApiException(
          message: 'Raji response JSON sirrii miti.',
          statusCode: response.statusCode,
        );
      }

      if (decoded is! Map<String, dynamic>) {
        throw RajiApiException(
          message: 'Raji response sirrii miti.',
          statusCode: response.statusCode,
        );
      }

      // ========================================================
      // CREATE RAJI MESSAGE
      // ========================================================

      final result = RajiMessage.fromJson(
        decoded,
      );

      if (result.text.trim().isEmpty) {
        throw RajiApiException(
          message: 'Raji deebii duwwaa erge.',
          statusCode: response.statusCode,
        );
      }

      return result;
    } on RajiApiException {
      rethrow;
    } on TimeoutException {
      debugPrint(
        '⏰ Raji request timed out.',
      );

      return RajiLocalResponder.respond(
        message: cleanMessage,
        context: context,
      );
    } on FormatException catch (e) {
      debugPrint(
        '❌ Raji JSON error: $e',
      );

      throw const RajiApiException(
        message:
            'Deebiin Raji irraa dhufe sirrii miti.',
      );
    } catch (e) {
      debugPrint(
        '❌ Raji connection error: $e',
      );

      return RajiLocalResponder.respond(
        message: cleanMessage,
        context: context,
      );
    }
  }

  // ============================================================
  // ERROR MESSAGE
  // ============================================================

  String _extractErrorMessage(
    String body,
    int statusCode,
  ) {
    try {
      final decoded = jsonDecode(body);

      if (decoded is Map<String, dynamic>) {
        final message =
            decoded['message']?.toString();

        if (message != null &&
            message.trim().isNotEmpty) {
          return message;
        }

        final error =
            decoded['error']?.toString();

        if (error != null &&
            error.trim().isNotEmpty) {
          return error;
        }
      }
    } catch (_) {
      // Ignore malformed error responses.
    }

    if (statusCode == 401) {
      return 'Raji serveriin seenuuf hayyama hin qabu.';
    }

    if (statusCode == 404) {
      return 'Raji API hin argamne.';
    }

    if (statusCode == 429) {
      return 'Raji yeroo ammaa namoota hedduu gargaaramaa jira. Mee xiqqoo eegii yaali.';
    }

    if (statusCode >= 500) {
      return 'Raji serveriin yeroo ammaa rakkoo qaba. Mee yeroo muraasa booda yaali.';
    }

    return 'Raji serveriin dogoggora qaba.';
  }

  // ============================================================
  // HEALTH CHECK
  // ============================================================

  Future<bool> isAvailable() async {
    if (_cleanBaseUrl.isEmpty) {
      // The local responder is always available when no hosted model has
      // been configured for this build.
      return true;
    }

    final uri = Uri.parse(
      '$_cleanBaseUrl/api/raji/health',
    );

    try {
      final response = await _httpClient
          .get(
            uri,
            headers: const {
              'Accept': 'application/json',
            },
          )
          .timeout(
            const Duration(seconds: 10),
          );

      return response.statusCode >= 200 &&
          response.statusCode < 300;
    } on TimeoutException {
      debugPrint(
        '⏰ Raji health check timed out.',
      );

      return false;
    } catch (e) {
      debugPrint(
        '❌ Raji health check failed: $e',
      );

      return false;
    }
  }

  // ============================================================
  // DISPOSE
  // ============================================================

  void dispose() {
    _httpClient.close();
  }
}

// ============================================================
// RAJI API EXCEPTION
// ============================================================

class RajiApiException implements Exception {
  final String message;

  final int? statusCode;

  const RajiApiException({
    required this.message,
    this.statusCode,
  });

  @override
  String toString() {
    if (statusCode == null) {
      return message;
    }

    return '$message (HTTP $statusCode)';
  }
}
