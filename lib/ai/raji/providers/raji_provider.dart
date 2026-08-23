
import 'package:flutter/foundation.dart';

import '../models/raji_context.dart';
import '../models/raji_message.dart';
import '../services/raji_client.dart';

class RajiProvider extends ChangeNotifier {
  final RajiClient client;

  RajiProvider({
    required this.client,
  });

  // =====================================================
  // STATE
  // =====================================================

  final List<RajiMessage> _messages =
      [];

  bool _isLoading = false;

  String? _error;

  RajiContext? _context;

  // =====================================================
  // GETTERS
  // =====================================================

  List<RajiMessage> get messages =>
      List.unmodifiable(_messages);

  bool get isLoading =>
      _isLoading;

  String? get error =>
      _error;

  RajiContext? get contextData =>
      _context;

  bool get hasMessages =>
      _messages.isNotEmpty;

  // =====================================================
  // INITIALIZE
  // =====================================================

  Future<void> initialize({
    required RajiContext context,
  }) async {
    _context = context;
    _error = null;

    notifyListeners();
  }

  // =====================================================
  // SEND MESSAGE
  // =====================================================

  Future<void> sendMessage(
    String text,
  ) async {
    final cleanText =
        text.trim();

    if (cleanText.isEmpty) {
      return;
    }

    if (_isLoading) {
      return;
    }

    if (_context == null) {
      _error =
          'Raji hin qophoofne.';

      notifyListeners();
      return;
    }

    _error = null;

    // ---------------------------------------------------
    // Add user's message
    // ---------------------------------------------------

    final userMessage =
        RajiMessage(
      id: DateTime.now()
          .microsecondsSinceEpoch
          .toString(),
      role:
          RajiMessageRole.user,
      text: cleanText,
      timestamp: DateTime.now(),
    );

    _messages.add(
      userMessage,
    );

    _isLoading = true;

    notifyListeners();

    try {
      // -------------------------------------------------
      // Send conversation history BEFORE adding response
      // -------------------------------------------------

      final response =
          await client.sendMessage(
        message: cleanText,
        context: _context!,
        history: List.unmodifiable(
          _messages.take(_messages.length - 1),
        ),
      );

      // -------------------------------------------------
      // Add Raji response
      // -------------------------------------------------

      _messages.add(
        response,
      );
    } catch (e) {
      debugPrint(
        '❌ Raji error: $e',
      );

      _error =
          _friendlyError(e);
    } finally {
      _isLoading = false;

      notifyListeners();
    }
  }

  // =====================================================
  // UPDATE CONTEXT
  // =====================================================

  void updateContext(
    RajiContext context,
  ) {
    _context = context;

    notifyListeners();
  }

  // =====================================================
  // CLEAR CHAT
  // =====================================================

  void clearChat() {
    _messages.clear();

    _error = null;

    notifyListeners();
  }

  // =====================================================
  // REMOVE LAST MESSAGE
  // =====================================================

  void removeLastMessage() {
    if (_messages.isEmpty) {
      return;
    }

    _messages.removeLast();

    notifyListeners();
  }

  // =====================================================
  // RETRY
  // =====================================================

  Future<void> retryLastMessage() async {
    if (_isLoading) {
      return;
    }

    // Find the most recent user message.
    RajiMessage? lastUserMessage;

    for (final message
        in _messages.reversed) {
      if (message.isUser) {
        lastUserMessage = message;
        break;
      }
    }

    if (lastUserMessage == null) {
      return;
    }

    // Remove the last Raji error state.
    _error = null;

    // Remove messages after the user message.
    final index =
        _messages.indexOf(
      lastUserMessage,
    );

    if (index >= 0 &&
        index + 1 <
            _messages.length) {
      _messages.removeRange(
        index + 1,
        _messages.length,
      );
    }

    // Send again.
    await _sendExistingUserMessage(
      lastUserMessage.text,
    );
  }

  // =====================================================
  // INTERNAL SEND
  // =====================================================

  Future<void> _sendExistingUserMessage(
    String text,
  ) async {
    if (_context == null) {
      _error =
          'Raji hin qophoofne.';

      notifyListeners();
      return;
    }

    _isLoading = true;

    _error = null;

    notifyListeners();

    try {
      final response =
          await client.sendMessage(
        message: text,
        context: _context!,
        history:
            List.unmodifiable(
          _messages,
        ),
      );

      _messages.add(
        response,
      );
    } catch (e) {
      debugPrint(
        '❌ Raji retry error: $e',
      );

      _error =
          _friendlyError(e);
    } finally {
      _isLoading = false;

      notifyListeners();
    }
  }

  // =====================================================
  // ERROR HANDLING
  // =====================================================

  String _friendlyError(
    Object error,
  ) {
    if (error
        is RajiApiException) {
      // -------------------------------------------------
      // Unauthorized
      // -------------------------------------------------

      if (error.statusCode ==
          401) {
        return 'Raji serveriin seenuun dadhabe.';
      }

      // -------------------------------------------------
      // Rate limit
      // -------------------------------------------------

      if (error.statusCode ==
          429) {
        return 'Raji yeroo ammaa namoota hedduu gargaaramaa jira. Mee xiqqoo eegii yaali.';
      }

      // -------------------------------------------------
      // Server error
      // -------------------------------------------------

      if (error.statusCode !=
              null &&
          error.statusCode! >=
              500) {
        return 'Raji serveriin yeroo ammaa hin hojjetu. Mee yeroo muraasa booda yaali.';
      }

      return error.message;
    }

    return 'Raji waliin wal qunnamuun hin danda\'amne. Internet kee ilaali.';
  }

  // =====================================================
  // DISPOSE
  // =====================================================

  @override
  void dispose() {
    client.dispose();

    super.dispose();
  }
}

