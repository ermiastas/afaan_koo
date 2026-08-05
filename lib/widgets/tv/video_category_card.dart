import 'package:flutter/material.dart';

import '../../models/video_category.dart';

class VideoCategoryCard extends StatelessWidget {

  final VideoCategory category;

  final VoidCallback onTap;

  const VideoCategoryCard({
    super.key,
    required this.category,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {

    return InkWell(

      borderRadius: BorderRadius.circular(24),

      onTap: onTap,

      child: AnimatedContainer(

        duration: const Duration(milliseconds: 300),

        padding: const EdgeInsets.all(18),

        decoration: BoxDecoration(

          color: category.color.withValues(alpha: .15),

          borderRadius: BorderRadius.circular(24),

          border: Border.all(
            color: category.color.withValues(alpha: .3),
          ),

        ),

        child: Column(

          mainAxisAlignment: MainAxisAlignment.center,

          children: [

            Text(

              category.emoji,

              style: const TextStyle(
                fontSize: 42,
              ),

            ),

            const SizedBox(height: 12),

            Text(

              category.title,

              textAlign: TextAlign.center,

              style: const TextStyle(
                fontWeight: FontWeight.bold,
                fontSize: 18,
              ),

            ),

            const SizedBox(height: 6),

            Text(

              category.description,

              textAlign: TextAlign.center,

              style: TextStyle(

                fontSize: 13,

                color: Colors.grey.shade700,

              ),

            ),

          ],

        ),

      ),

    );

  }

}