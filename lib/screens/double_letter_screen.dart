import 'package:flutter/material.dart';

import '../data/lesson_ids.dart';
import '../services/audio_service.dart';
import '../utils/responsive.dart';
import '../widgets/lesson_complete_button.dart';

class DoubleLetterScreen extends StatelessWidget {
  const DoubleLetterScreen({
    super.key,
  });

  static const List<_DoubleLetter> _letters = [
    _DoubleLetter(
      letter: 'CH',
      word: 'Chaappaa',
      color: Color(0xffff8a00),
    ),
    _DoubleLetter(
      letter: 'DH',
      word: 'Dhala',
      color: Color(0xff00a896),
    ),
    _DoubleLetter(
      letter: 'NY',
      word: 'Nyaata',
      color: Color(0xffe84393),
    ),
    _DoubleLetter(
      letter: 'PH',
      word: 'Phonii',
      color: Color(0xff4169e1),
    ),
    _DoubleLetter(
      letter: 'SH',
      word: 'Shubbisa',
      color: Color(0xff8e44ad),
    ),
  ];

  @override
  Widget build(BuildContext context) {
    final width = MediaQuery.of(context).size.width;
    final columns = Responsive.homeColumns(context);

    return Scaffold(
      body: Container(
        decoration: const BoxDecoration(
          gradient: LinearGradient(
            begin: Alignment.topCenter,
            end: Alignment.bottomCenter,
            colors: [
              Color(0xffc8b6ff),
              Color(0xffeee9ff),
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
                  'Ch • Dh • Ny • Ph • Sh',
                  textAlign: TextAlign.center,
                  style: TextStyle(
                    fontSize: width < 400 ? 18 : 24,
                    fontWeight: FontWeight.w900,
                    color: Colors.deepPurple,
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
                    10,
                  ),
                  itemCount: _letters.length,
                  gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                    crossAxisCount: columns,
                    crossAxisSpacing: width < 500 ? 8 : 12,
                    mainAxisSpacing: width < 500 ? 10 : 14,
                    childAspectRatio: _cardAspectRatio(width),
                  ),
                  itemBuilder: (context, index) {
                    final item = _letters[index];

                    return _DoubleLetterCard(
                      item: item,
                      width: width,
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
                  lessonId: LessonIds.doubleLetters,
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
              'Qubee Dachaa ✨',
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

class _DoubleLetterCard extends StatefulWidget {
  const _DoubleLetterCard({
    required this.item,
    required this.width,
  });

  final _DoubleLetter item;
  final double width;

  @override
  State<_DoubleLetterCard> createState() => _DoubleLetterCardState();
}

class _DoubleLetterCardState extends State<_DoubleLetterCard> {
  bool _pressed = false;

  Future<void> _playAudio() async {
    await AudioService().play(
      'assets/audio/alphabet/'
      '${widget.item.letter.toLowerCase()}.mp3',
    );
  }

  @override
  Widget build(BuildContext context) {
    final width = widget.width;

    final letterSize = width < 400
        ? 42.0
        : width < 700
            ? 56.0
            : 72.0;

    return GestureDetector(
      onTapDown: (_) => setState(() => _pressed = true),
      onTapCancel: () => setState(() => _pressed = false),
      onTapUp: (_) {
        setState(() => _pressed = false);
        _playAudio();
      },
      child: AnimatedScale(
        scale: _pressed ? 0.94 : 1,
        duration: const Duration(milliseconds: 100),
        child: Container(
          padding: EdgeInsets.all(
            width < 400 ? 8 : 12,
          ),
          decoration: BoxDecoration(
            color: widget.item.color.withValues(alpha: 0.08),
            borderRadius: BorderRadius.circular(26),
            border: Border.all(
              color: Colors.white,
              width: 2,
            ),
            boxShadow: [
              BoxShadow(
                color: widget.item.color.withValues(alpha: 0.18),
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
                      widget.item.letter,
                      maxLines: 1,
                      style: TextStyle(
                        fontSize: letterSize,
                        fontWeight: FontWeight.w900,
                        color: widget.item.color,
                        height: 0.9,
                        letterSpacing: 1,
                      ),
                    ),
                  ),
                ),
              ),
              Flexible(
                child: Text(
                  widget.item.word,
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                  textAlign: TextAlign.center,
                  style: TextStyle(
                    fontSize: width < 400 ? 11 : 14,
                    fontWeight: FontWeight.w800,
                  ),
                ),
              ),
              const SizedBox(height: 4),
              Icon(
                Icons.volume_up_rounded,
                size: width < 400 ? 16 : 19,
                color: widget.item.color.withValues(alpha: 0.7),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class _DoubleLetter {
  const _DoubleLetter({
    required this.letter,
    required this.word,
    required this.color,
  });

  final String letter;
  final String word;
  final Color color;
}
