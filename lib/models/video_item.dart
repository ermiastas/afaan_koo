import 'package:flutter/material.dart';

class VideoItem {
  final String id;

  final String title;

  final String titleEnglish;

  final String description;

  final String thumbnail;

  final String videoUrl;

  final String category;

  final String emoji;

  final Duration duration;

  final bool downloadable;

  final bool featured;

  final bool favorite;

  final bool downloaded;

  final int rewardXP;

  final List<int> ages;

  final Color color;
  final String? localPath;

  const VideoItem({
    required this.id,
    required this.title,
    required this.titleEnglish,
    required this.description,
    required this.thumbnail,
    required this.videoUrl,
    required this.category,
    required this.color,
    this.emoji = "📺",
    this.duration = Duration.zero,
    this.downloadable = true,
    this.featured = false,
    this.favorite = false,
    this.downloaded = false,
    this.rewardXP = 20,
    this.ages = const [3,4,5,6,7,8,9,10,11,12],
    this.localPath,
  });

  factory VideoItem.fromJson(
      Map<String, dynamic> json) {
    return VideoItem(
      id: json["id"] ?? "",
      title: json["title"] ?? "",
      titleEnglish: json["titleEnglish"] ?? "",
      description: json["description"] ?? "",
      thumbnail: json["thumbnail"] ?? "",
      videoUrl: json["videoUrl"] ?? "",
      category: json["category"] ?? "",
      emoji: json["emoji"] ?? "📺",
      downloadable: json["downloadable"] ?? true,
      featured: json["featured"] ?? false,
      favorite: json["favorite"] ?? false,
      downloaded: json["downloaded"] ?? false,
      rewardXP: json["rewardXP"] ?? 20,
      color: Color(json["color"] ?? Colors.red.toARGB32()),
      duration: Duration(
        seconds: json["duration"] ?? 0,
      ),
      ages: json["ages"] != null
          ? List<int>.from(json["ages"])
          : const [3,4,5,6,7,8,9,10,11,12],
    );
  }

  Map<String, dynamic> toJson() {
    return {
      "id": id,
      "title": title,
      "titleEnglish": titleEnglish,
      "description": description,
      "thumbnail": thumbnail,
      "videoUrl": videoUrl,
      "category": category,
      "emoji": emoji,
      "duration": duration.inSeconds,
      "downloadable": downloadable,
      "featured": featured,
      "favorite": favorite,
      "downloaded": downloaded,
      "rewardXP": rewardXP,
      "ages": ages,
      "color": color.toARGB32(),
    };
  }
}