import 'package:flutter/material.dart';

import '../models/story_item.dart';
import '../services/audio_service.dart';

class StoryCard extends StatelessWidget {
  final StoryItem story;

  final VoidCallback? onCompleted;

  const StoryCard({
    super.key,
    required this.story,
    this.onCompleted,
  });

  @override
  Widget build(BuildContext context) {
    final audio = AudioService();

    return Card(
      elevation: 6,
      margin: const EdgeInsets.all(16),
      color: Colors.white,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(28),
      ),

      child: SingleChildScrollView(
        padding: const EdgeInsets.all(22),

        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,

          children: [

            //------------------------------------------------
            // Emoji
            //------------------------------------------------

            Center(
              child: Text(
                story.emoji,
                style: const TextStyle(
                  fontSize: 72,
                ),
              ),
            ),

            const SizedBox(height: 18),

            //------------------------------------------------
            // Title
            //------------------------------------------------

            Center(
              child: Text(
                story.title,
                textAlign: TextAlign.center,
                style: const TextStyle(
                  fontSize: 28,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ),

            const SizedBox(height: 8),

            Center(
              child: Text(
                story.subtitle,
                textAlign: TextAlign.center,
                style: TextStyle(
                  fontSize: 17,
                  color: Colors.grey.shade700,
                ),
              ),
            ),

            const SizedBox(height: 20),

            //------------------------------------------------
            // Chips
            //------------------------------------------------

            Wrap(
              spacing: 8,
              runSpacing: 8,
              alignment: WrapAlignment.center,

              children: [

                Chip(
                  avatar: const Icon(
                    Icons.category,
                    size: 18,
                  ),
                  label: Text(story.category),
                ),

                Chip(
                  avatar: const Icon(
                    Icons.schedule,
                    size: 18,
                  ),
                  label: Text(
                    "${story.readingTime} min",
                  ),
                ),

                Chip(
                  avatar: const Icon(
                    Icons.star,
                    color: Colors.amber,
                    size: 18,
                  ),
                  label: Text(
                    story.difficulty.name.toUpperCase(),
                  ),
                ),
              ],
            ),

            const SizedBox(height: 18),

            //------------------------------------------------
            // Audio
            //------------------------------------------------

            Center(
              child: FilledButton.icon(
                onPressed: () {
                  audio.playSound(story.audio);
                },
                icon: const Icon(Icons.volume_up),
                label: const Text("Dhaggeeffadhu"),
              ),
            ),

            const SizedBox(height: 25),

            const Divider(),

            //------------------------------------------------
            // Story
            //------------------------------------------------

            const Text(
              "📖 Seenaa",
              style: TextStyle(
                fontSize: 22,
                fontWeight: FontWeight.bold,
              ),
            ),

            const SizedBox(height: 12),

            Text(
              story.story,
              style: const TextStyle(
                fontSize: 19,
                height: 1.8,
              ),
            ),

            const SizedBox(height: 30),

            //------------------------------------------------
            // Vocabulary
            //------------------------------------------------

            const Text(
              "📚 Jechoota Haaraa",
              style: TextStyle(
                fontSize: 22,
                fontWeight: FontWeight.bold,
              ),
            ),

            const SizedBox(height: 10),

            ...story.newWords.map(
              (word) => Card(
                color: Colors.orange.shade50,
                child: ListTile(
                  leading: const Icon(
                    Icons.menu_book,
                    color: Colors.orange,
                  ),
                  title: Text(word),
                ),
              ),
            ),

            const SizedBox(height: 25),

            //------------------------------------------------
            // Learning Points
            //------------------------------------------------

            const Text(
              "🌱 Barumsa",
              style: TextStyle(
                fontSize: 22,
                fontWeight: FontWeight.bold,
              ),
            ),

            const SizedBox(height: 10),

            ...story.learningPoints.map(
              (point) => ListTile(
                leading: const Icon(
                  Icons.check_circle,
                  color: Colors.green,
                ),
                title: Text(point),
              ),
            ),

            const SizedBox(height: 25),

            //------------------------------------------------
            // Lesson Summary
            //------------------------------------------------

            const Text(
              "💡 Gabaabumatti",
              style: TextStyle(
                fontSize: 22,
                fontWeight: FontWeight.bold,
              ),
            ),

            const SizedBox(height: 10),

            Container(
              padding: const EdgeInsets.all(18),
              decoration: BoxDecoration(
                color: Colors.blue.shade50,
                borderRadius: BorderRadius.circular(16),
              ),

              child: Text(
                story.lesson,
                style: const TextStyle(
                  fontSize: 18,
                ),
              ),
            ),

            const SizedBox(height: 30),

            //------------------------------------------------
            // Quiz
            //------------------------------------------------

            const Text(
              "❓ Gaaffii",
              style: TextStyle(
                fontSize: 22,
                fontWeight: FontWeight.bold,
              ),
            ),

            const SizedBox(height: 15),

            ...story.questions.map(
              (question) => Card(
                child: Padding(
                  padding: const EdgeInsets.all(16),

                  child: Column(
                    crossAxisAlignment:
                        CrossAxisAlignment.start,

                    children: [

                      Text(
                        question.question,
                        style: const TextStyle(
                          fontWeight: FontWeight.bold,
                          fontSize: 18,
                        ),
                      ),

                      const SizedBox(height: 12),

                      ...List.generate(
                        question.options.length,
                        (index) => ListTile(
                          leading: const Icon(
                            Icons.radio_button_unchecked,
                          ),
                          title: Text(
                            question.options[index],
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ),

            const SizedBox(height: 25),

            //------------------------------------------------
            // Rewards
            //------------------------------------------------

            Card(
              color: Colors.green.shade50,

              child: Padding(
                padding: const EdgeInsets.all(18),

                child: Row(
                  mainAxisAlignment:
                      MainAxisAlignment.spaceEvenly,

                  children: [

                    Column(
                      children: [

                        const Text(
                          "⭐",
                          style: TextStyle(fontSize: 28),
                        ),

                        Text(
                          "${story.xpReward} XP",
                        ),
                      ],
                    ),

                    Column(
                      children: [

                        const Text(
                          "🪙",
                          style: TextStyle(fontSize: 28),
                        ),

                        Text(
                          "${story.coinsReward}",
                        ),
                      ],
                    ),
                  ],
                ),
              ),
            ),

            const SizedBox(height: 25),

            //------------------------------------------------
            // Complete
            //------------------------------------------------

            SizedBox(
              width: double.infinity,

              child: FilledButton.icon(
                onPressed: onCompleted,
                icon: const Icon(
                  Icons.check_circle,
                ),
                label: const Text(
                  "Seenaa Xumuri",
                ),
              ),
            ),

            const SizedBox(height: 15),
          ],
        ),
      ),
    );
  }
}