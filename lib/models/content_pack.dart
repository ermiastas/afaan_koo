/// The installation state of a downloadable lesson pack on this device.
///
/// These states describe local availability only; lesson progress remains
/// independent of a pack's installation state.
enum ContentPackInstallationStatus {
  notInstalled,
  downloading,
  installing,
  installed,
  updateAvailable,
  failed,
}

/// Metadata for a lesson-content pack listed by the content catalog.
///
/// Content packs contain data and media only. They never contain executable
/// Flutter or Dart code.
class ContentPack {
  const ContentPack({
    required this.id,
    required this.slug,
    required this.title,
    required this.description,
    required this.version,
    required this.sizeBytes,
    required this.lessonCount,
    required this.category,
    required this.minAppVersion,
    required this.language,
    required this.isActive,
    this.downloadUrl,
    this.checksum,
  });

  final String id;
  final String slug;
  final String title;
  final String description;
  final int version;
  final int sizeBytes;
  final int lessonCount;
  final String category;
  final String minAppVersion;
  final String language;
  final bool isActive;
  final String? downloadUrl;
  final String? checksum;

  factory ContentPack.fromJson(Map<String, dynamic> json) {
    return ContentPack(
      id: _requiredString(json, 'id'),
      slug: _requiredString(json, 'slug'),
      title: _requiredString(json, 'title'),
      description: _requiredString(json, 'description'),
      version: _requiredInt(json, 'version'),
      sizeBytes: _requiredInt(json, 'size_bytes'),
      lessonCount: _requiredInt(json, 'lesson_count'),
      category: _requiredString(json, 'category'),
      minAppVersion: _requiredString(json, 'min_app_version'),
      language: _requiredString(json, 'language'),
      isActive: _requiredBool(json, 'is_active'),
      downloadUrl: _optionalString(json, 'download_url'),
      checksum: _optionalString(json, 'checksum'),
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'slug': slug,
      'title': title,
      'description': description,
      'version': version,
      'size_bytes': sizeBytes,
      'lesson_count': lessonCount,
      'category': category,
      'download_url': downloadUrl,
      'checksum': checksum,
      'min_app_version': minAppVersion,
      'language': language,
      'is_active': isActive,
    };
  }
}

String _requiredString(Map<String, dynamic> json, String key) {
  final value = json[key];
  if (value is String && value.trim().isNotEmpty) {
    return value;
  }
  throw FormatException('Content pack field "$key" must be a non-empty string.');
}

String? _optionalString(Map<String, dynamic> json, String key) {
  final value = json[key];
  if (value == null) {
    return null;
  }
  if (value is String && value.trim().isNotEmpty) {
    return value;
  }
  throw FormatException('Content pack field "$key" must be a string or null.');
}

int _requiredInt(Map<String, dynamic> json, String key) {
  final value = json[key];
  if (value is num && value.isFinite && value == value.roundToDouble()) {
    return value.toInt();
  }
  throw FormatException('Content pack field "$key" must be an integer.');
}

bool _requiredBool(Map<String, dynamic> json, String key) {
  final value = json[key];
  if (value is bool) {
    return value;
  }
  throw FormatException('Content pack field "$key" must be a boolean.');
}
