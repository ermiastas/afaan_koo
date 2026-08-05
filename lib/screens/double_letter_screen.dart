import 'package:flutter/material.dart';

import '../services/audio_service.dart';

class DoubleLetterScreen extends StatelessWidget {
  const DoubleLetterScreen({super.key});

  static const List<_DoubleLetter> _letters = [
    _DoubleLetter(
      letter: "CH",
      word: "Chaappaa",
      emoji: "🦁",
      color: Colors.orange,
    ),
    _DoubleLetter(
      letter: "DH",
      word: "Dhala",
      emoji: "🏡",
      color: Colors.green,
    ),
    _DoubleLetter(
      letter: "NY",
      word: "Nyaata",
      emoji: "🍎",
      color: Colors.red,
    ),
    _DoubleLetter(
      letter: "SH",
      word: "Shubbisa",
      emoji: "💃",
      color: Colors.purple,
    ),
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Qubee Dachaa 🟣"),
        centerTitle: true,
      ),
      body: GridView.builder(
        padding: const EdgeInsets.all(16),
        itemCount: _letters.length,
        gridDelegate:
            const SliverGridDelegateWithFixedCrossAxisCount(
          crossAxisCount: 2,
          crossAxisSpacing: 16,
          mainAxisSpacing: 16,
          childAspectRatio: .82,
        ),
        itemBuilder: (context, index) {
          final item = _letters[index];

          return InkWell(
            borderRadius: BorderRadius.circular(24),
            onTap: () async {
              // Replace with your own audio method.
              await AudioService().play(
                "assets/audio/alphabet/${item.letter.toLowerCase()}.mp3",
              );
            },
            child: Container(
              decoration: BoxDecoration(
                color: item.color.withValues(alpha: .12),
                borderRadius: BorderRadius.circular(24),
                border: Border.all(
                  color: item.color.withValues(alpha: .4),
                  width: 2,
                ),
              ),
              child: Padding(
                padding: const EdgeInsets.all(16),
                child: Column(
                  mainAxisAlignment:
                      MainAxisAlignment.spaceEvenly,
                  children: [

                    Text(
                      item.emoji,
                      style: const TextStyle(
                        fontSize: 52,
                      ),
                    ),

                    Text(
                      item.letter,
                      style: TextStyle(
                        fontSize: 42,
                        fontWeight: FontWeight.bold,
                        color: item.color,
                      ),
                    ),

                    Text(
                      item.word,
                      textAlign: TextAlign.center,
                      style: const TextStyle(
                        fontSize: 20,
                        fontWeight: FontWeight.w600,
                      ),
                    ),

                    Container(
                      padding: const EdgeInsets.symmetric(
                        horizontal: 14,
                        vertical: 8,
                      ),
                      decoration: BoxDecoration(
                        color: item.color.withValues(alpha: .18),
                        borderRadius:
                            BorderRadius.circular(20),
                      ),
                      child: const Row(
                        mainAxisSize: MainAxisSize.min,
                        children: [

                          Icon(
                            Icons.volume_up,
                            size: 18,
                          ),

                          SizedBox(width: 6),

                          Text("Dhaggeeffadhu"),
                        ],
                      ),
                    ),
                  ],
                ),
              ),
            ),
          );
        },
      ),
    );
  }
}

class _DoubleLetter {
  final String letter;
  final String word;
  final String emoji;
  final Color color;

  const _DoubleLetter({
    required this.letter,
    required this.word,
    required this.emoji,
    required this.color,
  });
}