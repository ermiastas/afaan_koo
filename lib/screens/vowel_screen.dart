import 'package:flutter/material.dart';

import '../data/alphabet_data.dart';
import '../data/lesson_ids.dart';
import '../models/letter.dart';
import '../widgets/lesson_complete_button.dart';
import '../utils/responsive.dart';
import 'letter_detail_screen.dart';

class VowelScreen extends StatelessWidget {
  const VowelScreen({super.key});

  static const List<Color> _colors = [
    Color(0xFFFF8A65),
    Color(0xFF66BB6A),
    Color(0xFF42A5F5),
    Color(0xFFAB47BC),
    Color(0xFFFFCA28),
  ];

  @override
  Widget build(BuildContext context) {
    final vowels =
        letters.where((letter) => letter.type == LetterType.vowel).toList();

    return Scaffold(
      backgroundColor: const Color(0xFFFFFDF5),
      appBar: AppBar(
        title: const Text(
          "Dubbachiiftuu 🟢",
          style: TextStyle(
            fontWeight: FontWeight.w800,
          ),
        ),
        centerTitle: true,
        backgroundColor: Colors.orange,
        foregroundColor: Colors.white,
      ),
      body: SafeArea(
        child: Column(
          children: [
            Container(
              width: double.infinity,
              padding: const EdgeInsets.fromLTRB(16, 14, 16, 18),
              decoration: const BoxDecoration(
                color: Colors.orange,
                borderRadius: BorderRadius.only(
                  bottomLeft: Radius.circular(30),
                  bottomRight: Radius.circular(30),
                ),
              ),
              child: const Column(
                children: [
                  Text(
                    "A E I O U",
                    textAlign: TextAlign.center,
                    style: TextStyle(
                      color: Colors.white,
                      fontSize: 30,
                      fontWeight: FontWeight.w900,
                      letterSpacing: 4,
                    ),
                  ),
                  SizedBox(height: 6),
                  Text(
                    "Dubbachiiftuu Afaan Oromoo haa barannu!",
                    textAlign: TextAlign.center,
                    style: TextStyle(
                      color: Colors.white,
                      fontSize: 16,
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                ],
              ),
            ),
            Expanded(
              child: vowels.isEmpty
                  ? const Center(
                      child: Text(
                        "Dubbachiiftuun hin argamne",
                        style: TextStyle(
                          fontSize: 20,
                          fontWeight: FontWeight.w700,
                        ),
                      ),
                    )
                  : GridView.builder(
                      padding: EdgeInsets.all(
                        Responsive.pagePadding(context),
                      ),
                      gridDelegate: Responsive.homeGridDelegate(
                        context,
                        crossAxisSpacing: 12,
                        mainAxisSpacing: 12,
                        childAspectRatio: 0.85,
                      ),
                      itemCount: vowels.length,
                      itemBuilder: (context, index) {
                        final letter = vowels[index];

                        return _VowelCard(
                          letter: letter,
                          color: _colors[index % _colors.length],
                          onTap: () {
                            Navigator.push(
                              context,
                              MaterialPageRoute(
                                builder: (context) => LetterDetailScreen(
                                  letter: letter,
                                ),
                              ),
                            );
                          },
                        );
                      },
                    ),
            ),
            Padding(
              padding: const EdgeInsets.fromLTRB(16, 8, 16, 16),
              child: LessonCompleteButton(
                lessonId: LessonIds.vowels,
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class _VowelCard extends StatefulWidget {
  final Letter letter;
  final Color color;
  final VoidCallback onTap;

  const _VowelCard({
    required this.letter,
    required this.color,
    required this.onTap,
  });

  @override
  State<_VowelCard> createState() => _VowelCardState();
}

class _VowelCardState extends State<_VowelCard> {
  bool _pressed = false;

  @override
  Widget build(BuildContext context) {
    return AnimatedScale(
      scale: _pressed ? 0.96 : 1.0,
      duration: const Duration(milliseconds: 100),
      child: Material(
        color: Colors.transparent,
        child: InkWell(
          borderRadius: BorderRadius.circular(24),
          onTap: widget.onTap,
          onTapDown: (_) {
            setState(() => _pressed = true);
          },
          onTapCancel: () {
            setState(() => _pressed = false);
          },
          onTapUp: (_) {
            setState(() => _pressed = false);
          },
          child: Container(
            decoration: BoxDecoration(
              color: widget.color.withValues(alpha: 0.12),
              borderRadius: BorderRadius.circular(24),
              border: Border.all(
                color: widget.color.withValues(alpha: 0.45),
                width: 2,
              ),
              boxShadow: [
                BoxShadow(
                  color: widget.color.withValues(alpha: 0.12),
                  blurRadius: 8,
                  offset: const Offset(0, 4),
                ),
              ],
            ),
            padding: const EdgeInsets.all(12),
            child: Column(
              children: [
                Expanded(
                  flex: 5,
                  child: Center(
                    child: FittedBox(
                      fit: BoxFit.contain,
                      child: Text(
                        widget.letter.uppercase,
                        style: TextStyle(
                          fontSize: 82,
                          fontWeight: FontWeight.w900,
                          color: widget.color,
                          height: 1,
                        ),
                      ),
                    ),
                  ),
                ),
                const SizedBox(height: 4),
                Flexible(
                  flex: 2,
                  child: FittedBox(
                    fit: BoxFit.scaleDown,
                    child: Text(
                      widget.letter.example,
                      textAlign: TextAlign.center,
                      style: const TextStyle(
                        fontSize: 19,
                        fontWeight: FontWeight.w700,
                        color: Color(0xFF333333),
                      ),
                    ),
                  ),
                ),
                const SizedBox(height: 8),
                Container(
                  padding: const EdgeInsets.symmetric(
                    horizontal: 12,
                    vertical: 7,
                  ),
                  decoration: BoxDecoration(
                    color: widget.color.withValues(alpha: 0.16),
                    borderRadius: BorderRadius.circular(18),
                  ),
                  child: Icon(
                    Icons.volume_up_rounded,
                    color: widget.color,
                    size: 20,
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
