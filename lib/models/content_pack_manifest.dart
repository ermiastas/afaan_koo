/// Metadata embedded inside every downloadable content pack.
///
/// The manifest is validated against the server-side catalog before a pack
/// is activated. It describes the content package itself; it does not contain
/// learner progress or rewards.
class ContentPackManifest {
  const ContentPackManifest({
    required this.id,
    required this.name,
    required this.version,
    required this.minAppVersion,
    required this.lessonCount,
    required this.sizeBytes,
    required this.language,
    required this.checksum,
    required this.isActive,
  });

  final String id;
  final String name;
  final int version;
  final String minAppVersion;
  final int lessonCount;
  final int sizeBytes;
  final String language;
  final String checksum;
  final bool isActive;

  factory ContentPackManifest.fromJson(
    Map<String, dynamic> json,
  ) {
    return ContentPackManifest(
      id: _requiredString(json, 'id'),
      name: _requiredString(json, 'name'),
      version: _requiredPositiveInt(json, 'version'),
      minAppVersion: _requiredString(
        json,
        'min_app_version',
      ),
      lessonCount: _requiredNonNegativeInt(
        json,
        'lesson_count',
      ),
      sizeBytes: _requiredNonNegativeInt(
        json,
        'size_bytes',
      ),
      language: _requiredString(
        json,
        'language',
      ),
      checksum: _requiredChecksum(
        json,
        'checksum',
      ),
      isActive: _requiredBool(
        json,
        'is_active',
      ),
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'name': name,
      'version': version,
      'min_app_version': minAppVersion,
      'lesson_count': lessonCount,
      'size_bytes': sizeBytes,
      'language': language,
      'checksum': checksum,
      'is_active': isActive,
    };
  }
}

String _requiredString(
  Map<String, dynamic> json,
  String key,
) {
  final value = json[key];

  if (value is String && value.trim().isNotEmpty) {
    return value.trim();
  }

  throw FormatException(
    'Content pack manifest field "$key" must be a non-empty string.',
  );
}

int _requiredPositiveInt(
  Map<String, dynamic> json,
  String key,
) {
  final value = _requiredNonNegativeInt(json, key);

  if (value > 0) {
    return value;
  }

  throw FormatException(
    'Content pack manifest field "$key" must be greater than zero.',
  );
}

int _requiredNonNegativeInt(
  Map<String, dynamic> json,
  String key,
) {
  final value = json[key];

  if (value is num &&
      value.isFinite &&
      value == value.roundToDouble() &&
      value >= 0) {
    return value.toInt();
  }

  throw FormatException(
    'Content pack manifest field "$key" must be a non-negative integer.',
  );
}

bool _requiredBool(
  Map<String, dynamic> json,
  String key,
) {
  final value = json[key];

  if (value is bool) {
    return value;
  }

  throw FormatException(
    'Content pack manifest field "$key" must be a boolean.',
  );
}

String _requiredChecksum(
  Map<String, dynamic> json,
  String key,
) {
  final value = _requiredString(json, key);

  if (!RegExp(r'^[a-fA-F0-9]{64}$').hasMatch(value)) {
    throw FormatException(
      'Content pack manifest field "$key" must be a SHA-256 checksum.',
    );
  }

  return value.toLowerCase();
}
