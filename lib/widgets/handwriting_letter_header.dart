import 'package:flutter/material.dart';

class HandwritingLetterHeader extends StatelessWidget {
  final String uppercase;
  final String lowercase;
  final String name;
  final String sound;
  final String category;

  const HandwritingLetterHeader({
    super.key,
    required this.uppercase,
    required this.lowercase,
    required this.name,
    required this.sound,
    required this.category,
  });

  @override
  Widget build(BuildContext context) {
    return Card(
      elevation: 3,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(20),
      ),
      child: Padding(
        padding: const EdgeInsets.symmetric(
          horizontal: 20,
          vertical: 18,
        ),
        child: Column(
          children: [
            // Uppercase & Lowercase
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Text(
                  uppercase,
                  style: const TextStyle(
                    fontSize: 56,
                    fontWeight: FontWeight.bold,
                  ),
                ),

                const SizedBox(width: 24),

                Text(
                  lowercase,
                  style: TextStyle(
                    fontSize: 48,
                    color: Colors.grey.shade700,
                    fontWeight: FontWeight.w600,
                  ),
                ),
              ],
            ),

            const SizedBox(height: 12),

            Text(
              name,
              style: const TextStyle(
                fontSize: 24,
                fontWeight: FontWeight.bold,
              ),
            ),

            const SizedBox(height: 6),

            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                const Icon(
                  Icons.volume_up,
                  size: 20,
                  color: Colors.blue,
                ),

                const SizedBox(width: 6),

                Text(
                  sound,
                  style: const TextStyle(
                    fontSize: 18,
                  ),
                ),
              ],
            ),

            const SizedBox(height: 12),

            Container(
              padding: const EdgeInsets.symmetric(
                horizontal: 14,
                vertical: 6,
              ),
              decoration: BoxDecoration(
                color: Colors.blue.shade50,
                borderRadius: BorderRadius.circular(30),
              ),
              child: Text(
                category,
                style: TextStyle(
                  color: Colors.blue.shade800,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}