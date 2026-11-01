import 'dart:convert';

import 'package:flutter/material.dart';

import '../models/word_item.dart';
import '../services/audio_service.dart';

class WordDetailScreen extends StatelessWidget {
  final WordItem word;

  WordDetailScreen({
    super.key,
    required this.word,
  });

  final AudioService audio = AudioService();

  Widget _buildWordImage() {
    final image = word.image;

    // Content-pack images stored as Base64 data URIs.
    if (image.startsWith('data:image/')) {
      try {
        final commaIndex = image.indexOf(',');

        if (commaIndex < 0) {
          throw const FormatException('Invalid image data URI');
        }

        final imageBytes = base64Decode(
          image.substring(commaIndex + 1),
        );

        return Image.memory(
          imageBytes,
          height: 220,
          fit: BoxFit.contain,
          errorBuilder: (context, error, stackTrace) {
            return const Icon(
              Icons.image_not_supported,
              size: 120,
            );
          },
        );
      } catch (error) {
        debugPrint('Word image decoding failed: $error');

        return const Icon(
          Icons.image_not_supported,
          size: 120,
        );
      }
    }

    // Regular Flutter asset images.
    return Image.asset(
      image,
      height: 220,
      fit: BoxFit.contain,
      errorBuilder: (context, error, stackTrace) {
        debugPrint('Word asset image loading failed: $error');

        return const Icon(
          Icons.image_not_supported,
          size: 120,
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xfffffaf0),
      appBar: AppBar(
        title: Text(word.wordOromo),
        centerTitle: true,
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(20),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Card(
              elevation: 5,
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(25),
              ),
              child: Padding(
                padding: const EdgeInsets.all(20),
                child: Column(
                  children: [
                    _buildWordImage(),
                    const SizedBox(height: 20),
                    Text(
                      word.wordOromo,
                      textAlign: TextAlign.center,
                      style: const TextStyle(
                        fontSize: 40,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    const SizedBox(height: 10),
                    Text(
                      word.wordEnglish,
                      style: const TextStyle(
                        fontSize: 25,
                        color: Colors.grey,
                      ),
                    ),
                    const SizedBox(height: 25),
                    Text(
                      "😊 Raajii:\nKun jecha ${word.wordOromo} dha!",
                      textAlign: TextAlign.center,
                      style: const TextStyle(
                        fontSize: 18,
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                    const SizedBox(height: 25),
                    ElevatedButton.icon(
                      onPressed: () {
                        audio.playSound(word.sound);
                      },
                      icon: const Icon(Icons.volume_up),
                      label: const Text(
                        "Sagalee dhaggeeffadhu 🔊",
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
