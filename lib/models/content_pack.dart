
/// Local installation states for downloadable content packs.
enum ContentPackInstallationStatus {
  notInstalled,
  downloading,
  installing,
  installed,
  updateAvailable,
  failed,
}

/// Describes the kind of content delivered by a pack.
enum ContentPackItemType {
  lesson,
  game;

  static ContentPackItemType fromValue(dynamic value) {
    switch (value) {
      case 'game':
        return ContentPackItemType.game;
      case null:
      case '':
      case 'lesson':
        return ContentPackItemType.lesson;
      default:
        throw FormatException(
          'Unsupported content pack item_type: $value',
        );
    }
  }

  String get value => name;
}

/// Describes who may access a content pack.
enum ContentPackAccessTier {
  free,
  premium,
  paid;

  static ContentPackAccessTier fromValue(dynamic value) {
    switch (value) {
      case 'premium':
        return ContentPackAccessTier.premium;
      case 'paid':
        return ContentPackAccessTier.paid;
      case null:
      case '':
      case 'free':
        return ContentPackAccessTier.free;
      default:
        throw FormatException(
          'Unsupported content pack access_tier: $value',
        );
    }
  }

  String get value => name;
}

/// Metadata for a downloadable content pack.
///
/// Packs contain content data and media, never executable Flutter or Dart code.
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
    this.itemType = ContentPackItemType.lesson,
    this.itemId,
    this.accessTier = ContentPackAccessTier.free,
  });

  final String id;
  final String slug;
  final String title;
  final String description;
  final int version;
  final int sizeBytes;

  /// Retained for compatibility with the existing lesson-pack UI.
  /// For game packs, this may represent the number of included content items.
  final int lessonCount;

  final String category;
  final String minAppVersion;
  final String language;
  final bool isActive;
  final String? downloadUrl;
  final String? checksum;

  final ContentPackItemType itemType;
  final String? itemId;
  final ContentPackAccessTier accessTier;

  /// The content identifier defaults to the pack ID for older catalog rows.
  String get contentItemId {
    final value = itemId?.trim();
    return value == null || value.isEmpty ? id : value;
  }

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
      itemType: ContentPackItemType.fromValue(json['item_type']),
      itemId: _optionalString(json, 'item_id'),
      accessTier: ContentPackAccessTier.fromValue(
        json['access_tier'],
      ),
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
      'item_type': itemType.value,
      'item_id': contentItemId,
      'access_tier': accessTier.value,
    };
  }
}

String _requiredString(Map<String, dynamic> json, String key) {
  final value = json[key];
  if (value is String && value.trim().isNotEmpty) {
    return value;
  }

  throw FormatException(
    'Content pack field "$key" must be a non-empty string.',
  );
}

String? _optionalString(Map<String, dynamic> json, String key) {
  final value = json[key];

  if (value == null) return null;

  if (value is String && value.trim().isNotEmpty) {
    return value;
  }

  throw FormatException(
    'Content pack field "$key" must be a string or null.',
  );
}

int _requiredInt(Map<String, dynamic> json, String key) {
  final value = json[key];

  if (value is num &&
      value.isFinite &&
      value == value.roundToDouble()) {
    return value.toInt();
  }

  throw FormatException(
    'Content pack field "$key" must be an integer.',
  );
}

bool _requiredBool(Map<String, dynamic> json, String key) {
  final value = json[key];

  if (value is bool) return value;

  throw FormatException(
    'Content pack field "$key" must be a boolean.',
  );
}
