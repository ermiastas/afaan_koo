import 'content_pack.dart';

/// Locally persisted information about a content pack.
///
/// This record describes installed content only. It deliberately does not
/// contain lesson-completion data, which remains owned by ProgressProvider.
class ContentPackInstallation {
  const ContentPackInstallation({
    required this.packId,
    required this.version,
    required this.status,
    this.installedAt,
    this.sizeBytes,
    this.checksum,
    this.localPath,
  });

  final String packId;
  final int version;
  final ContentPackInstallationStatus status;
  final DateTime? installedAt;
  final int? sizeBytes;
  final String? checksum;
  final String? localPath;

  /// Whether the locally installed content may be opened.
  ///
  /// A pack remains usable while an update is available; the existing version
  /// is retained until a later update is fully installed.
  bool get isUsable =>
      status == ContentPackInstallationStatus.installed ||
      status == ContentPackInstallationStatus.updateAvailable;

  factory ContentPackInstallation.fromJson(Map<String, dynamic> json) {
    return ContentPackInstallation(
      packId: _requiredString(json, 'pack_id'),
      version: _requiredNonNegativeInt(json, 'version'),
      status: _requiredStatus(json),
      installedAt: _optionalDateTime(json, 'installed_at'),
      sizeBytes: _optionalNonNegativeInt(json, 'size_bytes'),
      checksum: _optionalString(json, 'checksum'),
      localPath: _optionalString(json, 'local_path'),
    );
  }

  /// Returns null for a malformed local record rather than preventing the
  /// remaining registry entries from loading.
  static ContentPackInstallation? tryFromJson(Map<String, dynamic> json) {
    try {
      return ContentPackInstallation.fromJson(json);
    } on FormatException {
      return null;
    }
  }

  Map<String, dynamic> toJson() {
    return {
      'pack_id': packId,
      'version': version,
      'status': status.name,
      'installed_at': installedAt?.toUtc().toIso8601String(),
      'size_bytes': sizeBytes,
      'checksum': checksum,
      'local_path': localPath,
    };
  }
}

String _requiredString(Map<String, dynamic> json, String key) {
  final value = json[key];
  if (value is String && value.trim().isNotEmpty) {
    return value;
  }
  throw FormatException('Content pack installation "$key" is required.');
}

String? _optionalString(Map<String, dynamic> json, String key) {
  final value = json[key];
  if (value == null) {
    return null;
  }
  if (value is String && value.trim().isNotEmpty) {
    return value;
  }
  throw FormatException('Content pack installation "$key" is invalid.');
}

int _requiredNonNegativeInt(Map<String, dynamic> json, String key) {
  final value = _optionalNonNegativeInt(json, key);
  if (value != null) {
    return value;
  }
  throw FormatException('Content pack installation "$key" is required.');
}

int? _optionalNonNegativeInt(Map<String, dynamic> json, String key) {
  final value = json[key];
  if (value == null) {
    return null;
  }
  if (value is num &&
      value.isFinite &&
      value == value.roundToDouble() &&
      value >= 0) {
    return value.toInt();
  }
  throw FormatException('Content pack installation "$key" is invalid.');
}

DateTime? _optionalDateTime(Map<String, dynamic> json, String key) {
  final value = json[key];
  if (value == null) {
    return null;
  }
  if (value is String) {
    final parsed = DateTime.tryParse(value);
    if (parsed != null) {
      return parsed.toUtc();
    }
  }
  throw FormatException('Content pack installation "$key" is invalid.');
}

ContentPackInstallationStatus _requiredStatus(Map<String, dynamic> json) {
  final value = json['status'];
  if (value is String) {
    for (final status in ContentPackInstallationStatus.values) {
      if (status.name == value) {
        return status;
      }
    }
  }
  throw const FormatException('Content pack installation "status" is invalid.');
}
