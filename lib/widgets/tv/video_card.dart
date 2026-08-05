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
              offset: const Offset(0,4),
            ),
          ],

        ),

        child: Padding(

          padding: const EdgeInsets.all(16),

          child: Column(

            crossAxisAlignment:
                CrossAxisAlignment.start,

            children: [

              Expanded(
                child: Center(
                  child: Text(
                    video.emoji,
                    style: const TextStyle(
                      fontSize: 70,
                    ),
                  ),
                ),
              ),

              Text(
                video.title,
                maxLines: 1,
                overflow: TextOverflow.ellipsis,
                style: const TextStyle(
                  fontWeight: FontWeight.bold,
                  fontSize: 18,
                ),
              ),

              const SizedBox(height: 6),

              Text(
                video.description,
                maxLines: 2,
                overflow: TextOverflow.ellipsis,
                style: TextStyle(
                  color: Colors.grey.shade700,
                  fontSize: 13,
                ),
              ),

              const Spacer(),

              Row(
                children: [

                  Icon(
                    Icons.play_circle_fill,
                    color: video.color,
                  ),

                  const SizedBox(width: 6),

                  Text(
                    "${video.duration.inMinutes} min",
                  ),

                  const Spacer(),

                  const Icon(Icons.download),

                ],
              ),
            ],
          ),
        ),
      ),
    );
  }
}