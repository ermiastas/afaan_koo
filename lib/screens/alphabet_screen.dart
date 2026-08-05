import 'package:flutter/material.dart';

import '../data/alphabet_data.dart';
import '../data/lesson_ids.dart';
import '../models/letter.dart';
import '../widgets/letter_card.dart';
import '../widgets/lesson_complete_button.dart';
import 'letter_detail_screen.dart';

class AlphabetScreen extends StatelessWidget {
  const AlphabetScreen({
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    final List<Letter> alphabet = letters;

    final screenWidth = MediaQuery.of(context).size.width;

    // Responsive columns
    const double cardWidth = 180;

    final int columns =
        (screenWidth / cardWidth).floor().clamp(2, 8);

    return Scaffold(
      appBar: AppBar(
        title: const Text("Qubee Guguddaa 🔠"),
        centerTitle: true,
      ),
      body: SafeArea(
        child: Center(
          child: ConstrainedBox(
            constraints: const BoxConstraints(
              maxWidth: 1400,
            ),
            child: Column(
              children: [
                Expanded(
                  child: GridView.builder(
                    padding: EdgeInsets.symmetric(
                      horizontal: screenWidth > 900 ? 40 : 16,
                      vertical: 20,
                    ),
                    itemCount: alphabet.length,
                    gridDelegate:
                        SliverGridDelegateWithFixedCrossAxisCount(
                      crossAxisCount: columns,
                      childAspectRatio: screenWidth < 500
                          ? 0.82
                          : screenWidth < 900
                              ? 0.90
                              : 0.98,
                      crossAxisSpacing:
                          screenWidth > 900 ? 20 : 12,
                      mainAxisSpacing:
                          screenWidth > 900 ? 20 : 12,
                    ),
                    itemBuilder: (context, index) {
                      final letter = alphabet[index];

                      return Center(
                        child: ConstrainedBox(
                          constraints: const BoxConstraints(
                            maxWidth: 220,
                          ),
                          child: LetterCard(
                            letter: letter.uppercase,
                            word: letter.example,
                            image: letter.image,
                            onTap: () {
                              Navigator.push(
                                context,
                                MaterialPageRoute(
                                  builder: (_) =>
                                      LetterDetailScreen(
                                    letter: letter,
                                  ),
                                ),
                              );
                            },
                          ),
                        ),
                      );
                    },
                  ),
                ),

                Padding(
                  padding: EdgeInsets.fromLTRB(
                    screenWidth > 900 ? 40 : 16,
                    0,
                    screenWidth > 900 ? 40 : 16,
                    20,
                  ),
                  child: const LessonCompleteButton(
                    lessonId: LessonIds.alphabet,
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}