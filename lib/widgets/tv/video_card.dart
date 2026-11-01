import 'package:flutter/material.dart';

import '../../models/video_item.dart';

class VideoCard extends StatelessWidget {
  final VideoItem video;
  final VoidCallback onTap;

  const VideoCard({
    super.key,
    required this.video,
    required this.onTap,
  });

  bool get _isYouTube => video.source == 'youtube';

  @override
  Widget build(BuildContext context) {
    return InkWell(
      borderRadius: BorderRadius.circular(22),
      onTap: onTap,
      child: Container(
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(22),
          boxShadow: [
            BoxShadow(
              color: Colors.black.withValues(alpha: .08),
              blurRadius: 10,
              offset: const Offset(0, 4),
            ),
          ],
        ),
        child: Padding(
          padding: const EdgeInsets.all(12),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Expanded(
                child: ClipRRect(
                  borderRadius: BorderRadius.circular(16),
                  child: Stack(
                    fit: StackFit.expand,
                    children: [
                      _thumbnail(),
                      Center(
                        child: DecoratedBox(
                          decoration: BoxDecoration(
                            color: Colors.black.withValues(alpha: .58),
                            shape: BoxShape.circle,
                          ),
                          child: const Padding(
                            padding: EdgeInsets.all(10),
                            child: Icon(
                              Icons.play_arrow_rounded,
                              color: Colors.white,
                              size: 34,
                            ),
                          ),
                        ),
                      ),
                      if (_isYouTube)
                        Positioned(
                          top: 8,
                          left: 8,
                          child: Container(
                            padding: const EdgeInsets.symmetric(
                              horizontal: 8,
                              vertical: 5,
                            ),
                            decoration: BoxDecoration(
                              color: Colors.red,
                              borderRadius: BorderRadius.circular(10),
                            ),
                            child: const Text(
                              'YouTube',
                              style: TextStyle(
                                color: Colors.white,
                                fontSize: 11,
                                fontWeight: FontWeight.w800,
                              ),
                            ),
                          ),
                        ),
                    ],
                  ),
                ),
              ),
              const SizedBox(height: 10),
              Text(
                video.title,
                maxLines: 2,
                overflow: TextOverflow.ellipsis,
                style: const TextStyle(
                  fontWeight: FontWeight.w900,
                  fontSize: 17,
                ),
              ),
              const SizedBox(height: 5),
              Text(
                video.description,
                maxLines: 2,
                overflow: TextOverflow.ellipsis,
                style: TextStyle(
                  color: Colors.grey.shade700,
                  fontSize: 13,
                ),
              ),
              const SizedBox(height: 8),
              Row(
                children: [
                  Icon(
                    Icons.play_circle_fill_rounded,
                    color: video.color,
                    size: 20,
                  ),
                  const SizedBox(width: 5),
                  Text(
                    video.duration == Duration.zero
                        ? 'Viidiyoo'
                        : '${video.duration.inMinutes} min',
                    style: const TextStyle(
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                  const Spacer(),
                  if (_isYouTube)
                    const Icon(
                      Icons.cloud_rounded,
                      size: 20,
                      color: Colors.blueGrey,
                    )
                  else if (video.downloadable)
                    const Icon(
                      Icons.download_rounded,
                      size: 20,
                    ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _thumbnail() {
    if (video.thumbnail.trim().isNotEmpty) {
      return Image.network(
        video.thumbnail,
        fit: BoxFit.cover,
        errorBuilder: (_, __, ___) => _fallbackThumbnail(),
        loadingBuilder: (context, child, progress) {
          if (progress == null) return child;

          return Container(
            color: video.color.withValues(alpha: .12),
            alignment: Alignment.center,
            child: CircularProgressIndicator(
              strokeWidth: 3,
              color: video.color,
            ),
          );
        },
      );
    }

    return _fallbackThumbnail();
  }

  Widget _fallbackThumbnail() {
    return Container(
      color: video.color.withValues(alpha: .12),
      alignment: Alignment.center,
      child: Icon(
        Icons.ondemand_video_rounded,
        color: video.color,
        size: 64,
      ),
    );
  }
}
