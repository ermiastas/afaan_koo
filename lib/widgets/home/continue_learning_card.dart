import 'package:flutter/material.dart';

class ContinueLearningCard extends StatelessWidget {
  final String title;
  final String subtitle;
  final double progress;
  final VoidCallback onTap;

  const ContinueLearningCard({
    super.key,
    required this.title,
    required this.subtitle,
    required this.progress,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {

    return Padding(

      padding: const EdgeInsets.symmetric(
        horizontal: 20,
      ),

      child: InkWell(

        borderRadius:
            BorderRadius.circular(24),

        onTap: onTap,

        child: Container(

          padding:
              const EdgeInsets.all(20),

          decoration: BoxDecoration(

            borderRadius:
                BorderRadius.circular(24),

            gradient:
                const LinearGradient(

              colors: [

                Color(0xffFFB74D),

                Color(0xffFB8C00),

              ],

            ),

          ),

          child: Column(

            crossAxisAlignment:
                CrossAxisAlignment.start,

            children: [

              const Text(

                "▶ Continue Learning",

                style: TextStyle(

                  color: Colors.white,

                  fontWeight:
                      FontWeight.bold,

                  fontSize: 18,

                ),

              ),

              const SizedBox(height: 15),

              Text(

                title,

                style: const TextStyle(

                  color: Colors.white,

                  fontSize: 22,

                  fontWeight:
                      FontWeight.bold,

                ),

              ),

              const SizedBox(height: 6),

              Text(

                subtitle,

                style: const TextStyle(

                  color: Colors.white70,

                ),

              ),

              const SizedBox(height: 18),

              ClipRRect(

                borderRadius:
                    BorderRadius.circular(12),

                child: LinearProgressIndicator(

                  value: progress,

                  minHeight: 10,

                  backgroundColor:
                      Colors.white24,

                ),

              ),

              const SizedBox(height: 10),

              Text(

                "${(progress * 100).round()}% Complete",

                style: const TextStyle(

                  color: Colors.white,

                ),

              ),

            ],

          ),

        ),

      ),

    );

  }

}