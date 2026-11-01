import 'package:flutter/material.dart';

import '../data/alphabet_data.dart';
import '../data/lesson_ids.dart';
import '../models/letter.dart';
import '../utils/responsive.dart';
import '../widgets/lesson_complete_button.dart';
import 'letter_detail_screen.dart';

class ConsonantScreen extends StatelessWidget {
  const ConsonantScreen({
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    final width = MediaQuery.of(context).size.width;
    final columns = Responsive.homeColumns(context, max: 5);

    final consonants = letters
        .where(
          (letter) =>
              letter.type == LetterType.consonant &&
              ![
                'CH',
                'DH',
                'NY',
                'PH',
                'SH',
              ].contains(letter.uppercase.toUpperCase()),
        )
        .toList();

    return Scaffold(
      body: Container(
        decoration: const BoxDecoration(
          gradient: LinearGradient(
            begin: Alignment.topCenter,
            end: Alignment.bottomCenter,
            colors: [
              Color(0xffa8ddff),
              Color(0xffe8f7ff),
              Color(0xffffffff),
            ],
          ),
        ),
        child: SafeArea(
          child: Column(
            children: [
              _topBar(context, width),
              Container(
                margin: const EdgeInsets.symmetric(horizontal: 12),
                padding: EdgeInsets.all(width < 500 ? 12 : 16),
                decoration: BoxDecoration(
                  color: Colors.white.withValues(alpha: 0.72),
                  borderRadius: BorderRadius.circular(24),
                  border: Border.all(
                    color: Colors.white,
                    width: 2,
                  ),
                ),
                child: Text(
                  'Dubbifamaa Afaan Oromoo',
                  textAlign: TextAlign.center,
                  style: TextStyle(
                    fontSize: width < 400 ? 18 : 24,
                    fontWeight: FontWeight.w900,
                    color: Colors.blue.shade700,
                  ),
                ),
              ),
              const SizedBox(height: 8),
              Expanded(
                child: GridView.builder(
                  padding: EdgeInsets.fromLTRB(
                    Responsive.pagePadding(context),
                    8,
                    Responsive.pagePadding(context),
                    12,
                  ),
                  itemCount: consonants.length,
                  gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                    crossAxisCount: columns,
                    crossAxisSpacing: width < 500 ? 8 : 12,
                    mainAxisSpacing: width < 500 ? 10 : 14,
                    childAspectRatio: _cardAspectRatio(width),
                  ),
                  itemBuilder: (context, index) {
                    final letter = consonants[index];

                    return _ConsonantCard(
                      letter: letter,
                      index: index,
                      onTap: () {
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (_) => LetterDetailScreen(
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
                padding: EdgeInsets.fromLTRB(
                  Responsive.pagePadding(context),
                  4,
                  Responsive.pagePadding(context),
                  12,
                ),
                child: const LessonCompleteButton(
                  lessonId: LessonIds.consonant,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _topBar(
    BuildContext context,
    double width,
  ) {
    final titleSize = width < 350
        ? 20.0
        : width < 600
            ? 24.0
            : 30.0;

    return Padding(
      padding: EdgeInsets.all(
        Responsive.pagePadding(context),
      ),
      child: Row(
        children: [
          IconButton.filledTonal(
            onPressed: () => Navigator.of(context).pop(),
            icon: const Icon(Icons.arrow_back),
          ),
          const SizedBox(width: 10),
          Expanded(
            child: Text(
              'Dubbifamaa 🔵',
              maxLines: 1,
              overflow: TextOverflow.ellipsis,
              style: TextStyle(
                fontSize: titleSize,
                fontWeight: FontWeight.w900,
              ),
            ),
          ),
        ],
      ),
    );
  }

  double _cardAspectRatio(double width) {
    if (width < 280) return 0.95;
    if (width < 420) return 0.82;
    if (width < 700) return 0.78;
    if (width < 1200) return 0.85;
    return 0.90;
  }
}

class _ConsonantCard extends StatefulWidget {
  const _ConsonantCard({
    required this.letter,
    required this.index,
    required this.onTap,
  });

  final Letter letter;
  final int index;
  final VoidCallback onTap;

  @override
  State<_ConsonantCard> createState() => _ConsonantCardState();
}

class _ConsonantCardState extends State<_ConsonantCard> {
  bool _pressed = false;

  static const colors = [
    Color(0xff4169e1),
    Color(0xff00a896),
    Color(0xff8e44ad),
    Color(0xffe84393),
    Color(0xffd63031),
    Color(0xfff39c12),
  ];

  @override
  Widget build(BuildContext context) {
    final width = MediaQuery.of(context).size.width;
    final color = colors[widget.index % colors.length];

    final letterSize = width < 400
        ? 52.0
        : width < 700
            ? 66.0
            : 82.0;

    return GestureDetector(
      onTapDown: (_) => setState(() => _pressed = true),
      onTapCancel: () => setState(() => _pressed = false),
      onTapUp: (_) {
        setState(() => _pressed = false);
        widget.onTap();
      },
      child: AnimatedScale(
        scale: _pressed ? 0.94 : 1,
        duration: const Duration(milliseconds: 100),
        child: Container(
          padding: const EdgeInsets.all(10),
          decoration: BoxDecoration(
            color: color.withValues(alpha: 0.08),
            borderRadius: BorderRadius.circular(26),
            border: Border.all(
              color: Colors.white,
              width: 2,
            ),
            boxShadow: [
              BoxShadow(
                color: color.withValues(alpha: 0.18),
                blurRadius: 14,
                offset: const Offset(0, 7),
              ),
            ],
          ),
          child: Column(
            children: [
              Expanded(
                child: Center(
                  child: FittedBox(
                    fit: BoxFit.contain,
                    child: Text(
                      widget.letter.uppercase,
                      style: TextStyle(
                        fontSize: letterSize,
                        fontWeight: FontWeight.w900,
                        color: color,
                        height: 0.9,
                      ),
                    ),
                  ),
                ),
              ),
              Flexible(
                child: Text(
                  widget.letter.example,
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                  textAlign: TextAlign.center,
                  style: const TextStyle(
                    fontSize: 13,
                    fontWeight: FontWeight.w700,
                  ),
                ),
              ),
              const SizedBox(height: 4),
              Icon(
                Icons.touch_app_rounded,
                size: 18,
                color: color.withValues(alpha: 0.65),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
