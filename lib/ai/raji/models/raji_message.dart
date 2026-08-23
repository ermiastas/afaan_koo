
enum RajiMessageRole {
  user,
  assistant,
}

class RajiMessage {
  final String id;

  final RajiMessageRole role;

  final String text;

  final DateTime timestamp;

  // =====================================================
  // REWARDS
  // =====================================================

  final int xp;

  final int stars;

  final int coins;

  // =====================================================
  // ACTION
  // =====================================================

  final String? actionType;

  final String? actionId;

  // =====================================================
  // SUGGESTIONS
  // =====================================================

  final List<String> suggestions;

  const RajiMessage({
    required this.id,
    required this.role,
    required this.text,
    required this.timestamp,
    this.xp = 0,
    this.stars = 0,
    this.coins = 0,
    this.actionType,
    this.actionId,
    this.suggestions = const [],
  });

  // =====================================================
  // ROLE HELPERS
  // =====================================================

  bool get isUser =>
      role == RajiMessageRole.user;

  bool get isRaji =>
      role == RajiMessageRole.assistant;

  // =====================================================
  // REWARD HELPERS
  // =====================================================

  bool get hasReward =>
      xp > 0 ||
      stars > 0 ||
      coins > 0;

  // =====================================================
  // ACTION HELPERS
  // =====================================================

  bool get hasAction =>
      actionType != null &&
      actionType!.isNotEmpty;

  // =====================================================
  // JSON → MODEL
  // =====================================================

  factory RajiMessage.fromJson(
    Map<String, dynamic> json,
  ) {
    // ---------------------------------------------------
    // Reward
    // ---------------------------------------------------

    final reward =
        json['reward'] is Map
            ? Map<String, dynamic>.from(
                json['reward'],
              )
            : <String, dynamic>{};

    // ---------------------------------------------------
    // Action
    // ---------------------------------------------------

    final action =
        json['action'] is Map
            ? Map<String, dynamic>.from(
                json['action'],
              )
            : <String, dynamic>{};

    // ---------------------------------------------------
    // Suggestions
    // ---------------------------------------------------

    final suggestions =
        json['suggestions'] is List
            ? List<String>.from(
                json['suggestions'].map(
                  (item) => item.toString(),
                ),
              )
            : <String>[];

    // ---------------------------------------------------
    // Message
    // ---------------------------------------------------

    return RajiMessage(
      id:
          json['id']?.toString() ??
          DateTime.now()
              .microsecondsSinceEpoch
              .toString(),

      role: _parseRole(
        json['role']?.toString(),
      ),

      text:
          json['message']?.toString() ??
          json['text']?.toString() ??
          json['response']?.toString() ??
          '',

      timestamp:
          DateTime.tryParse(
                json['timestamp']
                        ?.toString() ??
                    '',
              ) ??
              DateTime.now(),

      xp: _toInt(
        reward['xp'],
      ),

      stars: _toInt(
        reward['stars'],
      ),

      coins: _toInt(
        reward['coins'],
      ),

      actionType:
          action['type']?.toString(),

      actionId:
          action['id']?.toString() ??
          action['gameId']?.toString() ??
          action['lessonId']?.toString(),

      suggestions:
          suggestions,
    );
  }

  // =====================================================
  // ROLE PARSER
  // =====================================================

  static RajiMessageRole _parseRole(
    String? role,
  ) {
    if (role?.toLowerCase() ==
        'user') {
      return RajiMessageRole.user;
    }

    return RajiMessageRole.assistant;
  }

  // =====================================================
  // INTEGER PARSER
  // =====================================================

  static int _toInt(
    dynamic value,
  ) {
    if (value is int) {
      return value;
    }

    if (value is num) {
      return value.toInt();
    }

    return int.tryParse(
          value?.toString() ?? '',
        ) ??
        0;
  }

  // =====================================================
  // MODEL → JSON
  // =====================================================

  Map<String, dynamic> toJson() {
    return {
      'id': id,

      'role':
          role == RajiMessageRole.user
              ? 'user'
              : 'assistant',

      'message': text,

      'timestamp':
          timestamp.toIso8601String(),

      'reward': {
        'xp': xp,
        'stars': stars,
        'coins': coins,
      },

      'action': {
        if (actionType != null)
          'type': actionType,

        if (actionId != null)
          'id': actionId,
      },

      'suggestions':
          suggestions,
    };
  }
}