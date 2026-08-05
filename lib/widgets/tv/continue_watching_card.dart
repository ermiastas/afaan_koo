import 'package:flutter/material.dart';

import '../../models/video_item.dart';

class ContinueWatchingCard extends StatelessWidget {

  final VideoItem video;

  final double progress;

  final VoidCallback onTap;

  const ContinueWatchingCard({
    super.key,
    required this.video,
    required this.progress,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {

    return Card(

      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(22),
      ),

      child: ListTile(

        leading: CircleAvatar(
          backgroundColor: video.color,
          child: Text(
            video.emoji,
            style: const TextStyle(fontSize: 22),
          ),
        ),

        title: Text(video.title),

        subtitle: Column(
          crossAxisAlignment:
              CrossAxisAlignment.start,
          children: [

            const SizedBox(height: 8),

            LinearProgressIndicator(
              value: progress,
            ),

            const SizedBox(height: 4),

            Text(
              "${(progress*100).round()}% complete",
            ),

          ],
        ),

        trailing: IconButton(
          icon: const Icon(Icons.play_arrow),
          onPressed: onTap,
        ),

      ),

    );
  }
}