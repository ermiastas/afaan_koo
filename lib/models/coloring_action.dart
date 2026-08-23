import 'package:flutter/foundation.dart';

enum ColoringActionType {
  fill,
  erase,
  clear,
}

@immutable
class ColoringAction {
  const ColoringAction({
    required this.regionId,
    required this.type,
    required this.at,
    this.colorValue,
    this.previousColorValue,
  });

  final String regionId;
  final ColoringActionType type;
  final int? colorValue;
  final int? previousColorValue;
  final DateTime at;

  Map<String, dynamic> toJson() {
    return {
      'regionId': regionId,
      'type': type.name,
      'colorValue': colorValue,
      'previousColorValue': previousColorValue,
      'at': at.toIso8601String(),
    };
  }

  factory ColoringAction.fromJson(
    Map<String, dynamic> json,
  ) {
    final typeName = json['type']?.toString();

    final type = ColoringActionType.values.firstWhere(
      (item) => item.name == typeName,
      orElse: () => ColoringActionType.fill,
    );

    final colorValue = _readInt(json['colorValue']);
    final previousColorValue = _readInt(
      json['previousColorValue'],
    );

    final timestamp = DateTime.tryParse(
      json['at']?.toString() ?? '',
    );

    return ColoringAction(
      regionId: json['regionId']?.toString() ?? '',
      type: type,
      colorValue: colorValue,
      previousColorValue: previousColorValue,
      at: timestamp ?? DateTime.now(),
    );
  }

  static int? _readInt(dynamic value) {
    if (value is int) {
      return value;
    }

    if (value is num) {
      return value.toInt();
    }

    return int.tryParse(value?.toString() ?? '');
  }
}