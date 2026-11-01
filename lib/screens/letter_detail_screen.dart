import 'package:flutter/material.dart';

import '../models/letter.dart';
import '../services/audio_service.dart';

class LetterDetailScreen extends StatelessWidget {
  final Letter letter;
  final List<Letter>? letterList;
  final int? index;

  final AudioService audioService = AudioService();

  LetterDetailScreen({
    super.key,
    required this.letter,
    this.letterList,
    this.index,
  });

  static const List<Color> _letterColors = [
    Color(0xFF1565C0),
    Color(0xFF00897B),
    Color(0xFF8E24AA),
    Color(0xFFEF6C00),
    Color(0xFFC62828),
    Color(0xFF3949AB),
  ];

  void playSound(String sound) {
    if (sound.isEmpty) return;
    audioService.play(sound);
  }

  void _navigateToLetter(BuildContext context, int newIndex) {
    final list = letterList;

    if (list == null || newIndex < 0 || newIndex >= list.length) {
      return;
    }

    Navigator.pushReplacement(
      context,
      MaterialPageRoute(
        builder: (_) => LetterDetailScreen(
          letter: list[newIndex],
          letterList: list,
          index: newIndex,
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final list = letterList;
    final currentIndex = index;

    final canGoBack = list != null && currentIndex != null && currentIndex > 0;

    final canGoNext =
        list != null && currentIndex != null && currentIndex < list.length - 1;

    final themeColor = _letterColors[
        (currentIndex ?? letter.uppercase.codeUnitAt(0)) %
            _letterColors.length];

    return Scaffold(
      appBar: AppBar(
        title: Text(
          letter.display,
          style: const TextStyle(fontWeight: FontWeight.bold),
        ),
        centerTitle: true,
      ),
      body: SafeArea(
        child: SingleChildScrollView(
          padding: const EdgeInsets.all(20),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              // Qubee guddaa fi xiqqaa — suuraa malee.
              Container(
                width: double.infinity,
                padding: const EdgeInsets.symmetric(
                  horizontal: 12,
                  vertical: 24,
                ),
                decoration: BoxDecoration(
                  color: themeColor.withValues(alpha: 0.09),
                  borderRadius: BorderRadius.circular(28),
                  border: Border.all(
                    color: themeColor.withValues(alpha: 0.25),
                    width: 2,
                  ),
                ),
                child: Column(
                  children: [
                    Text(
                      letter.uppercase,
                      textAlign: TextAlign.center,
                      style: TextStyle(
                        fontSize: 100,
                        height: 1.05,
                        fontWeight: FontWeight.w900,
                        color: themeColor,
                      ),
                    ),
                    const SizedBox(height: 8),
                    Text(
                      letter.lowercase,
                      textAlign: TextAlign.center,
                      style: TextStyle(
                        fontSize: 64,
                        height: 1.1,
                        fontWeight: FontWeight.w800,
                        color: _letterColors[
                            ((_letterColors.indexOf(themeColor) + 2) %
                                _letterColors.length)],
                      ),
                    ),
                    const SizedBox(height: 8),
                    Text(
                      letter.name,
                      textAlign: TextAlign.center,
                      style: TextStyle(
                        fontSize: 22,
                        fontWeight: FontWeight.w700,
                        color: themeColor,
                      ),
                    ),
                  ],
                ),
              ),

              const SizedBox(height: 20),

              Center(
                child: ElevatedButton.icon(
                  onPressed: () => playSound(letter.sound),
                  icon: const Icon(Icons.volume_up_rounded),
                  label: const Text('Qubee dhaggeeffadhu'),
                  style: ElevatedButton.styleFrom(
                    backgroundColor: themeColor,
                    foregroundColor: Colors.white,
                    padding: const EdgeInsets.symmetric(
                      horizontal: 22,
                      vertical: 14,
                    ),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(18),
                    ),
                  ),
                ),
              ),

              const SizedBox(height: 30),

              const Text(
                'Jechoota Fakkeenyaa',
                style: TextStyle(
                  fontSize: 24,
                  fontWeight: FontWeight.w800,
                ),
              ),

              const SizedBox(height: 12),

              if (letter.allExamples.isEmpty ||
                  letter.allExamples.every(
                    (example) => example.wordOromo.trim().isEmpty,
                  ))
                const Card(
                  child: Padding(
                    padding: EdgeInsets.all(16),
                    child: Text(
                      'Jechoonni fakkeenyaa ammaaf hin jiran.',
                      style: TextStyle(fontSize: 16),
                    ),
                  ),
                )
              else
                ...letter.allExamples
                    .where((example) => example.wordOromo.trim().isNotEmpty)
                    .map((example) {
                  return Card(
                    margin: const EdgeInsets.only(bottom: 12),
                    elevation: 2,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(18),
                    ),
                    child: ListTile(
                      contentPadding: const EdgeInsets.symmetric(
                        horizontal: 16,
                        vertical: 8,
                      ),
                      leading: Container(
                        width: 48,
                        height: 48,
                        decoration: BoxDecoration(
                          color: themeColor.withValues(alpha: 0.12),
                          borderRadius: BorderRadius.circular(14),
                        ),
                        alignment: Alignment.center,
                        child: Text(
                          example.wordOromo.characters.first.toUpperCase(),
                          style: TextStyle(
                            fontSize: 26,
                            fontWeight: FontWeight.w900,
                            color: themeColor,
                          ),
                        ),
                      ),
                      title: Text(
                        example.wordOromo,
                        style: const TextStyle(
                          fontSize: 21,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      subtitle: example.wordEnglish == null ||
                              example.wordEnglish!.trim().isEmpty
                          ? null
                          : Text(example.wordEnglish!),
                      trailing:
                          example.sound != null && example.sound!.isNotEmpty
                              ? IconButton(
                                  tooltip: 'Jechoota dhaggeeffadhu',
                                  icon: Icon(
                                    Icons.volume_up_rounded,
                                    color: themeColor,
                                  ),
                                  onPressed: () => playSound(example.sound!),
                                )
                              : null,
                    ),
                  );
                }),

              if (list != null && currentIndex != null) ...[
                const SizedBox(height: 24),
                Row(
                  children: [
                    Expanded(
                      child: OutlinedButton.icon(
                        onPressed: canGoBack
                            ? () => _navigateToLetter(
                                  context,
                                  currentIndex - 1,
                                )
                            : null,
                        icon: const Icon(Icons.arrow_back_rounded),
                        label: const Text('Duubatti'),
                      ),
                    ),
                    const SizedBox(width: 12),
                    Expanded(
                      child: ElevatedButton.icon(
                        onPressed: canGoNext
                            ? () => _navigateToLetter(
                                  context,
                                  currentIndex + 1,
                                )
                            : null,
                        icon: const Icon(Icons.arrow_forward_rounded),
                        label: const Text('Itti Aanu'),
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 12),
                Center(
                  child: Text(
                    'Qubee ${currentIndex + 1} / ${list.length}',
                    style: const TextStyle(
                      fontWeight: FontWeight.w600,
                      color: Colors.black54,
                    ),
                  ),
                ),
              ],
            ],
          ),
        ),
      ),
    );
  }
}
