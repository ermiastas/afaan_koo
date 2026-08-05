import 'package:flutter/material.dart';

import '../data/story_data.dart';
import '../models/story_item.dart';
import '../services/audio_service.dart';
import '../widgets/lesson_complete_button.dart';
import '../data/lesson_ids.dart';

class StoryScreen extends StatefulWidget {
  const StoryScreen({super.key});

  @override
  State<StoryScreen> createState() => _StoryScreenState();
}

class _StoryScreenState extends State<StoryScreen> {
  final PageController _pageController = PageController();

  final AudioService _audioService = AudioService();

  int currentPage = 0;

  List<StoryItem> get stories => storyData;

  @override
  void dispose() {
    _pageController.dispose();
    super.dispose();
  }

  void nextStory() {
    if (currentPage < stories.length - 1) {
      _pageController.nextPage(
        duration: const Duration(milliseconds: 350),
        curve: Curves.easeInOut,
      );
    }
  }

  void previousStory() {
    if (currentPage > 0) {
      _pageController.previousPage(
        duration: const Duration(milliseconds: 350),
        curve: Curves.easeInOut,
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    if (stories.isEmpty) {
      return const Scaffold(
        body: Center(
          child: Text(
            "Seenaa hin jiru.",
            style: TextStyle(fontSize: 22),
          ),
        ),
      );
    }

    return Scaffold(
      backgroundColor: const Color(0xFFFFF8E7),

      appBar: AppBar(
        elevation: 0,
        backgroundColor: Colors.brown,
        foregroundColor: Colors.white,
        centerTitle: true,
        title: const Text(
          "📖 Seenaa Koo",
          style: TextStyle(
            fontWeight: FontWeight.bold,
          ),
        ),
      ),

      body: Column(
        children: [

          //==========================
          // Raji Header
          //==========================

          Container(
            margin: const EdgeInsets.all(16),
            padding: const EdgeInsets.all(18),
            decoration: BoxDecoration(
              color: Colors.brown.shade100,
              borderRadius: BorderRadius.circular(22),
            ),
            child: const Row(
              children: [

                CircleAvatar(
                  radius: 28,
                  child: Text(
                    "🤖",
                    style: TextStyle(fontSize: 24),
                  ),
                ),

                SizedBox(width: 14),

                Expanded(
                  child: Text(
                    "Raji:\n"
                    "Har'a seenaa bareedaa haa dubbisnu. "
                    "Dubbisii xumurte booda gaaffilee deebisuu hin dagatin!",
                    style: TextStyle(
                      fontSize: 17,
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                ),
              ],
            ),
          ),

          //==========================
          // Progress
          //==========================

          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 20),

            child: Column(
              children: [

                Row(
                  mainAxisAlignment:
                      MainAxisAlignment.spaceBetween,

                  children: [

                    Text(
                      "Seenaa ${currentPage + 1}",
                      style: const TextStyle(
                        fontWeight: FontWeight.bold,
                      ),
                    ),

                    Text(
                      "${stories.length} keessaa",
                      style: const TextStyle(
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ],
                ),

                const SizedBox(height: 8),

                LinearProgressIndicator(
                  value: (currentPage + 1) / stories.length,
                  minHeight: 10,
                  borderRadius: BorderRadius.circular(12),
                ),

              ],
            ),
          ),

          const SizedBox(height: 15),

          //==========================
          // Stories
          //==========================

          Expanded(
            child: PageView.builder(
              controller: _pageController,

              itemCount: stories.length,

              onPageChanged: (index) {
                setState(() {
                  currentPage = index;
                });
              },

              itemBuilder: (context, index) {
                final story = stories[index];

                return Padding(
                  padding: const EdgeInsets.all(16),

                  child: Card(
                    elevation: 6,

                    shape: RoundedRectangleBorder(
                      borderRadius:
                          BorderRadius.circular(24),
                    ),

                    child: SingleChildScrollView(
                      padding: const EdgeInsets.all(22),

                      child: Column(
                        crossAxisAlignment:
                            CrossAxisAlignment.start,

                        children: [

                          Center(
                            child: Text(
                              story.emoji,
                              style: const TextStyle(
                                fontSize: 70,
                              ),
                            ),
                          ),

                          const SizedBox(height: 20),

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

                          Row(
                            mainAxisAlignment:
                                MainAxisAlignment.center,
                            children: [

                              Chip(
                                label: Text(story.category),
                              ),

                              const SizedBox(width: 10),

                              Chip(
                                label: Text(
                                  "${story.readingTime} min",
                                ),
                              ),
                            ],
                          ),

                          const SizedBox(height: 20),

                          IconButton(
                            iconSize: 42,
                            onPressed: () {
                              _audioService.playSound(
                                story.audio,
                              );
                            },
                            icon: const Icon(
                              Icons.volume_up,
                              color: Colors.brown,
                            ),
                          ),

                          const Divider(),

                          Text(
                            story.story,
                            style: const TextStyle(
                              fontSize: 20,
                              height: 1.8,
                            ),
                          ),

                          const SizedBox(height: 30),

                          const Center(
                            child: Text(
                              "➡️ Kutaa itti aanu keessatti\n"
                              "Vocabulary, Lesson,\n"
                              "Learning Points fi Quiz ni daballa.",
                              textAlign: TextAlign.center,
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                );
              },
            ),
          ),

          //==========================
          // Navigation
          //==========================

          Padding(
            padding:
                const EdgeInsets.symmetric(horizontal: 16),

            child: Row(
              children: [

                Expanded(
                  child: ElevatedButton.icon(
                    onPressed:
                        currentPage == 0
                            ? null
                            : previousStory,

                    icon: const Icon(Icons.arrow_back),

                    label: const Text("Duubatti"),
                  ),
                ),

                const SizedBox(width: 10),

                Expanded(
                  child: ElevatedButton.icon(
                    onPressed:
                        currentPage == stories.length - 1
                            ? null
                            : nextStory,

                    icon:
                        const Icon(Icons.arrow_forward),

                    label: const Text("Itti Aanu"),
                  ),
                ),
              ],
            ),
          ),

          Padding(
            padding: const EdgeInsets.all(16),
            child: LessonCompleteButton(
              lessonId: LessonIds.story,
            ),
          ),
        ],
      ),
    );
  }
}