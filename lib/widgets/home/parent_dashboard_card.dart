import 'package:flutter/material.dart';

class ParentDashboardCard extends StatelessWidget {
  final int completedLessons;
  final int totalLessons;
  final int learningMinutes;
  final VoidCallback onTap;

  const ParentDashboardCard({
    super.key,
    required this.completedLessons,
    required this.totalLessons,
    required this.learningMinutes,
    required this.onTap,
  });

  double get progress {
    if (totalLessons == 0) return 0;
    return completedLessons / totalLessons;
  }

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(
        horizontal: 20,
        vertical: 12,
      ),
      child: InkWell(
        borderRadius: BorderRadius.circular(25),
        onTap: onTap,
        child: Container(
          padding: const EdgeInsets.all(20),
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(25),
            gradient: const LinearGradient(
              colors: [
                Color(0xff1976D2),
                Color(0xff42A5F5),
              ],
            ),
            boxShadow: [
              BoxShadow(
                color: Colors.blue.withValues(alpha:.25),
                blurRadius: 15,
                offset: const Offset(0, 8),
              ),
            ],
          ),
          child: Column(
            children: [

              Row(
                children: const [
                  Icon(
                    Icons.family_restroom,
                    color: Colors.white,
                    size: 30,
                  ),
                  SizedBox(width: 10),
                  Expanded(
                    child: Text(
                      "Kutaa Maatii",
                      style: TextStyle(
                        color: Colors.white,
                        fontWeight: FontWeight.bold,
                        fontSize: 22,
                      ),
                    ),
                  ),
                  Icon(
                    Icons.arrow_forward_ios,
                    color: Colors.white,
                    size: 18,
                  ),
                ],
              ),

              const SizedBox(height: 20),

              ClipRRect(
                borderRadius: BorderRadius.circular(12),
                child: LinearProgressIndicator(
                  value: progress,
                  minHeight: 12,
                  backgroundColor: Colors.white24,
                ),
              ),

              const SizedBox(height: 10),

              Align(
                alignment: Alignment.centerLeft,
                child: Text(
                  "$completedLessons keessaa $totalLessons xumurame",
                  style: const TextStyle(
                    color: Colors.white,
                    fontWeight: FontWeight.w600,
                  ),
                ),
              ),

              const SizedBox(height: 20),

              Row(
                children: [

                  Expanded(
                    child: _info(
                      "📚",
                      completedLessons.toString(),
                      "Barnoota",
                    ),
                  ),

                  Expanded(
                    child: _info(
                      "⏱",
                      learningMinutes.toString(),
                      "Daqiiqaa",
                    ),
                  ),

                  Expanded(
                    child: _info(
                      "🎯",
                      "${(progress * 100).round()}%",
                      "Milkaa'ina",
                    ),
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _info(
    String emoji,
    String value,
    String title,
  ) {
    return Column(
      children: [
        Text(
          emoji,
          style: const TextStyle(fontSize: 28),
        ),
        const SizedBox(height: 8),
        Text(
          value,
          style: const TextStyle(
            color: Colors.white,
            fontSize: 20,
            fontWeight: FontWeight.bold,
          ),
        ),
        Text(
          title,
          style: const TextStyle(
            color: Colors.white70,
          ),
        ),
      ],
    );
  }
}