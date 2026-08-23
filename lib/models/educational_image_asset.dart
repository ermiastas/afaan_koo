import 'package:flutter/foundation.dart';

/// Where an educational image is supplied from.  The app treats generated
/// colouring SVGs as derived data; [sourcePath] and [remoteUrl] always refer
/// to the original image and are never written to by the colouring pipeline.
enum EducationalImageSource { bundledAsset, remote, localImport }

enum ImageFormat { png, jpg, webp, svg, unknown }

enum ColoringConversionStatus {
  discovered,
  analyzed,
  queued,
  converting,
  pendingReview,
  approved,
  published,
  failed,
  rejected,
}

@immutable
class EducationalImageAsset {
  const EducationalImageAsset({
    required this.id,
    required this.sourcePath,
    required this.title,
    required this.format,
    required this.source,
    required this.createdAt,
    required this.updatedAt,
    this.remoteUrl,
    this.description,
    this.category,
    this.subject,
    this.ageGroup,
    this.lessonIds = const [],
    this.lessonTitles = const [],
    this.width,
    this.height,
    this.fileSizeBytes,
    this.colorCount,
    this.hasTransparency,
    this.contentFingerprint,
    this.perceptualHash,
    this.isColoringCandidate = false,
    this.conversionConfidence = 0,
    this.candidateReason,
    this.conversionStatus = ColoringConversionStatus.discovered,
    this.generatedSvgPath,
    this.thumbnailPath,
    this.vectorizationVersion = 1,
    this.errorReason,
    this.isCanonical = true,
    this.canonicalAssetId,
    this.isEnabled = true,
  });

  final String id;
  final String sourcePath;
  final String? remoteUrl;
  final String title;
  final String? description;
  final String? category;
  final String? subject;
  final String? ageGroup;
  final List<String> lessonIds;
  final List<String> lessonTitles;
  final ImageFormat format;
  final EducationalImageSource source;
  final int? width;
  final int? height;
  final int? fileSizeBytes;
  final int? colorCount;
  final bool? hasTransparency;
  final String? contentFingerprint;
  final String? perceptualHash;
  final bool isColoringCandidate;
  final double conversionConfidence;
  final String? candidateReason;
  final ColoringConversionStatus conversionStatus;
  final String? generatedSvgPath;
  final String? thumbnailPath;
  final int vectorizationVersion;
  final String? errorReason;
  final bool isCanonical;
  final String? canonicalAssetId;
  final bool isEnabled;
  final DateTime createdAt;
  final DateTime updatedAt;

  String? get lessonId => lessonIds.isEmpty ? null : lessonIds.first;
  String? get lessonTitle => lessonTitles.isEmpty ? null : lessonTitles.first;
  bool get isPublished =>
      isEnabled &&
      isCanonical &&
      conversionStatus == ColoringConversionStatus.published &&
      generatedSvgPath != null;

  EducationalImageAsset copyWith({
    String? title,
    String? description,
    String? category,
    String? subject,
    String? ageGroup,
    List<String>? lessonIds,
    List<String>? lessonTitles,
    int? width,
    int? height,
    int? fileSizeBytes,
    int? colorCount,
    bool? hasTransparency,
    String? contentFingerprint,
    String? perceptualHash,
    bool? isColoringCandidate,
    double? conversionConfidence,
    String? candidateReason,
    ColoringConversionStatus? conversionStatus,
    String? generatedSvgPath,
    String? thumbnailPath,
    int? vectorizationVersion,
    String? errorReason,
    bool? isCanonical,
    String? canonicalAssetId,
    bool? isEnabled,
    DateTime? updatedAt,
  }) {
    return EducationalImageAsset(
      id: id,
      sourcePath: sourcePath,
      remoteUrl: remoteUrl,
      title: title ?? this.title,
      description: description ?? this.description,
      category: category ?? this.category,
      subject: subject ?? this.subject,
      ageGroup: ageGroup ?? this.ageGroup,
      lessonIds: lessonIds ?? this.lessonIds,
      lessonTitles: lessonTitles ?? this.lessonTitles,
      format: format,
      source: source,
      width: width ?? this.width,
      height: height ?? this.height,
      fileSizeBytes: fileSizeBytes ?? this.fileSizeBytes,
      colorCount: colorCount ?? this.colorCount,
      hasTransparency: hasTransparency ?? this.hasTransparency,
      contentFingerprint: contentFingerprint ?? this.contentFingerprint,
      perceptualHash: perceptualHash ?? this.perceptualHash,
      isColoringCandidate: isColoringCandidate ?? this.isColoringCandidate,
      conversionConfidence: conversionConfidence ?? this.conversionConfidence,
      candidateReason: candidateReason ?? this.candidateReason,
      conversionStatus: conversionStatus ?? this.conversionStatus,
      generatedSvgPath: generatedSvgPath ?? this.generatedSvgPath,
      thumbnailPath: thumbnailPath ?? this.thumbnailPath,
      vectorizationVersion: vectorizationVersion ?? this.vectorizationVersion,
      errorReason: errorReason ?? this.errorReason,
      isCanonical: isCanonical ?? this.isCanonical,
      canonicalAssetId: canonicalAssetId ?? this.canonicalAssetId,
      isEnabled: isEnabled ?? this.isEnabled,
      createdAt: createdAt,
      updatedAt: updatedAt ?? this.updatedAt,
    );
  }

  Map<String, dynamic> toJson() => {
        'id': id,
        'sourcePath': sourcePath,
        'remoteUrl': remoteUrl,
        'title': title,
        'description': description,
        'category': category,
        'subject': subject,
        'ageGroup': ageGroup,
        'lessonIds': lessonIds,
        'lessonTitles': lessonTitles,
        'format': format.name,
        'source': source.name,
        'width': width,
        'height': height,
        'fileSizeBytes': fileSizeBytes,
        'colorCount': colorCount,
        'hasTransparency': hasTransparency,
        'contentFingerprint': contentFingerprint,
        'perceptualHash': perceptualHash,
        'isColoringCandidate': isColoringCandidate,
        'conversionConfidence': conversionConfidence,
        'candidateReason': candidateReason,
        'conversionStatus': conversionStatus.name,
        'generatedSvgPath': generatedSvgPath,
        'thumbnailPath': thumbnailPath,
        'vectorizationVersion': vectorizationVersion,
        'errorReason': errorReason,
        'isCanonical': isCanonical,
        'canonicalAssetId': canonicalAssetId,
        'isEnabled': isEnabled,
        'createdAt': createdAt.toIso8601String(),
        'updatedAt': updatedAt.toIso8601String(),
      };

  factory EducationalImageAsset.fromJson(Map<String, dynamic> json) {
    T enumValue<T extends Enum>(List<T> values, Object? value, T fallback) {
      return values.firstWhere(
        (item) => item.name == value,
        orElse: () => fallback,
      );
    }

    return EducationalImageAsset(
      id: json['id'] as String,
      sourcePath: json['sourcePath'] as String? ?? '',
      remoteUrl: json['remoteUrl'] as String?,
      title: json['title'] as String? ?? 'Suuraa',
      description: json['description'] as String?,
      category: json['category'] as String?,
      subject: json['subject'] as String?,
      ageGroup: json['ageGroup'] as String?,
      lessonIds: List<String>.from(json['lessonIds'] ?? const []),
      lessonTitles: List<String>.from(json['lessonTitles'] ?? const []),
      format:
          enumValue(ImageFormat.values, json['format'], ImageFormat.unknown),
      source: enumValue(
        EducationalImageSource.values,
        json['source'],
        EducationalImageSource.bundledAsset,
      ),
      width: json['width'] as int?,
      height: json['height'] as int?,
      fileSizeBytes: json['fileSizeBytes'] as int?,
      colorCount: json['colorCount'] as int?,
      hasTransparency: json['hasTransparency'] as bool?,
      contentFingerprint: json['contentFingerprint'] as String?,
      perceptualHash: json['perceptualHash'] as String?,
      isColoringCandidate: json['isColoringCandidate'] as bool? ?? false,
      conversionConfidence:
          (json['conversionConfidence'] as num?)?.toDouble() ?? 0,
      candidateReason: json['candidateReason'] as String?,
      conversionStatus: enumValue(
        ColoringConversionStatus.values,
        json['conversionStatus'],
        ColoringConversionStatus.discovered,
      ),
      generatedSvgPath: json['generatedSvgPath'] as String?,
      thumbnailPath: json['thumbnailPath'] as String?,
      vectorizationVersion: json['vectorizationVersion'] as int? ?? 1,
      errorReason: json['errorReason'] as String?,
      isCanonical: json['isCanonical'] as bool? ?? true,
      canonicalAssetId: json['canonicalAssetId'] as String?,
      isEnabled: json['isEnabled'] as bool? ?? true,
      createdAt: DateTime.tryParse(json['createdAt'] as String? ?? '') ??
          DateTime.fromMillisecondsSinceEpoch(0),
      updatedAt: DateTime.tryParse(json['updatedAt'] as String? ?? '') ??
          DateTime.fromMillisecondsSinceEpoch(0),
    );
  }
}
