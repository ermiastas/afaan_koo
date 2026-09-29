/// The metadata embedded in a downloaded lesson-content pack.
///
/// During installation, this manifest will be compared with the catalog entry
/// before the pack is made available to the child.
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

  factory ContentPackManifest.fromJson(Map<String, dynamic> json) {
    return ContentPackManifest(
      id: _requiredString(json, 'id'),
      name: _requiredString(json, 'name'),
      version: _requiredInt(json, 'version'),
      minAppVersion: _requiredString(json, 'min_app_version'),
      lessonCount: _requiredInt(json, 'lesson_count'),
      sizeBytes: _requiredInt(json, 'size_bytes'),
      language: _requiredString(json, 'language'),
      checksum: _requiredString(json, 'checksum'),
      isActive: _requiredBool(json, 'is_active'),
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

  static String _requiredString(Map<String, dynamic> json, String key) {
    final value = json[key];
    if (value is String && value.trim().isNotEmpty) {
      return value;
    }
    throw FormatException(
      'Content pack manifest field "$key" must be a non-empty string.',
    );
  }

  static int _requiredInt(Map<String, dynamic> json, String key) {
    final value = json[key];
    if (value is num && value.isFinite && value == value.roundToDouble()) {
      return value.toInt();
    }
    throw FormatException(
      'Content pack manifest field "$key" must be an integer.',
    );
  }

  static bool _requiredBool(Map<String, dynamic> json, String key) {
    final value = json[key];
    if (value is bool) {
      return value;
    }
    throw FormatException(
      'Content pack manifest field "$key" must be a boolean.',
    );
  }
}
