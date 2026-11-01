import 'package:flutter/foundation.dart';

enum ColoringActionType {
  fill,
  bucket,
  erase,
  brush,
  line,
  shape,
  import,
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
    this.points,
    this.startPoint,
    this.endPoint,
    this.shapeType,
    this.bounds,
    this.rotation,
    this.strokeWidth,
    this.tolerance,
    this.assetPath,
  });

  final String regionId;
  final ColoringActionType type;
  final int? colorValue;
  final int? previousColorValue;
  final DateTime at;

  final List<Map<String, double>>? points;
  final Map<String, double>? startPoint;
  final Map<String, double>? endPoint;
  final String? shapeType;
  final Map<String, double>? bounds;
  final double? rotation;
  final double? strokeWidth;
  final int? tolerance;
  final String? assetPath;

  Map<String, dynamic> toJson() {
    return {
      'regionId': regionId,
      'type': type.name,
      'colorValue': colorValue,
      'previousColorValue': previousColorValue,
      'at': at.toIso8601String(),
      'points': points,
      'startPoint': startPoint,
      'endPoint': endPoint,
      'shapeType': shapeType,
      'bounds': bounds,
      'rotation': rotation,
      'strokeWidth': strokeWidth,
      'tolerance': tolerance,
      'assetPath': assetPath,
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

    return ColoringAction(
      regionId: json['regionId']?.toString() ?? '',
      type: type,
      colorValue: _readInt(json['colorValue']),
      previousColorValue: _readInt(
        json['previousColorValue'],
      ),
      at: DateTime.tryParse(
            json['at']?.toString() ?? '',
          ) ??
          DateTime.now(),
      points: _readPoints(json['points']),
      startPoint: _readPoint(json['startPoint']),
      endPoint: _readPoint(json['endPoint']),
      shapeType: json['shapeType']?.toString(),
      bounds: _readPoint(json['bounds']),
      rotation: _readDouble(json['rotation']),
      strokeWidth: _readDouble(json['strokeWidth']),
      tolerance: _readInt(json['tolerance']),
      assetPath: json['assetPath']?.toString(),
    );
  }

  static List<Map<String, double>>? _readPoints(
    dynamic value,
  ) {
    if (value is! List) {
      return null;
    }

    final result = <Map<String, double>>[];

    for (final item in value) {
      final point = _readPoint(item);
      if (point != null) {
        result.add(point);
      }
    }

    return result.isEmpty ? null : result;
  }

  static Map<String, double>? _readPoint(
    dynamic value,
  ) {
    if (value is! Map) {
      return null;
    }

    final result = <String, double>{};

    for (final entry in value.entries) {
      final number = _readDouble(entry.value);
      if (number != null) {
        result[entry.key.toString()] = number;
      }
    }

    return result.isEmpty ? null : result;
  }

  static int? _readInt(dynamic value) {
    if (value is int) {
      return value;
    }

    if (value is num) {
      return value.toInt();
    }

    return int.tryParse(
      value?.toString() ?? '',
    );
  }

  static double? _readDouble(dynamic value) {
    if (value is num) {
      return value.toDouble();
    }

    return double.tryParse(
      value?.toString() ?? '',
    );
  }
}
