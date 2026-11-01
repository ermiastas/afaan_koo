import 'package:flutter/material.dart';

import '../data/alphabet_data.dart';
import '../data/lesson_ids.dart';
import '../models/letter.dart';
import '../services/raji_audio_service.dart';
import '../services/content_service.dart';
import '../utils/responsive.dart';
import '../widgets/background/moving_clouds.dart';
import '../widgets/lesson_complete_button.dart';
import '../widgets/raji_assistant.dart';
import 'letter_detail_screen.dart';

class AlphabetScreen extends StatefulWidget {
  const AlphabetScreen({
    super.key,
  });

  @override
  State<AlphabetScreen> createState() => _AlphabetScreenState();
}

class _AlphabetScreenState extends State<AlphabetScreen>
    with SingleTickerProviderStateMixin {
  late final AnimationController _controller;
  final ContentService _contentService = ContentService();
  List<Letter> _alphabet = letters;

  Future<void> _loadAlphabet() async {
    try {
      final loadedLetters = await _contentService.getLetters();

      if (!mounted || loadedLetters.isEmpty) return;

      setState(() {
        _alphabet = loadedLetters;
      });
    } catch (error) {
      debugPrint('Alphabet pack load failed: $error');
    }
  }

  @override
  void initState() {
    super.initState();

    _controller = AnimationController(
      vsync: this,
      duration: const Duration(seconds: 12),
    )..repeat();
    _loadAlphabet();
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final screenWidth = MediaQuery.of(context).size.width;
    final columns = Responsive.homeColumns(context);
    final List<Letter> alphabet = _alphabet;

    return Scaffold(
      body: Stack(
        children: [
          // =========================================================
          // SKY BACKGROUND
          // =========================================================

          Positioned.fill(
            child: Container(
              decoration: const BoxDecoration(
                gradient: LinearGradient(
                  begin: Alignment.topCenter,
                  end: Alignment.bottomCenter,
                  colors: [
                    Color(0xff8ED6FF),
                    Color(0xffCDEEFF),
                    Color(0xffF7FCFF),
                  ],
                ),
              ),
            ),
          ),

          // =========================================================
          // MOVING CLOUDS
          // =========================================================

          const MovingClouds(),

          // =========================================================
          // ANIMATED BUBBLES
          // =========================================================

          IgnorePointer(
            child: AnimatedBuilder(
              animation: _controller,
              builder: (context, child) {
                return CustomPaint(
                  painter: BubblePainter(_controller.value),
                  size: Size.infinite,
                );
              },
            ),
          ),

          // =========================================================
          // MAIN CONTENT
          // =========================================================

          SafeArea(
            child: SingleChildScrollView(
              padding: EdgeInsets.fromLTRB(
                Responsive.pagePadding(context),
                Responsive.pagePadding(context),
                Responsive.pagePadding(context),
                40,
              ),
              child: Center(
                child: ConstrainedBox(
                  constraints: const BoxConstraints(
                    maxWidth: 1400,
                  ),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      // =================================================
                      // TOP BAR
                      // =================================================

                      _topBar(context),

                      const SizedBox(height: 18),

                      // =================================================
                      // RAJI
                      // =================================================

                      const RajiAssistant(
                        message: 'Qubee baranna! Har\'a maal jalqabna? 😊',
                        wave: true,
                      ),

                      const SizedBox(height: 4),

                      // =================================================
                      // RAJI AUDIO
                      // =================================================

                      Align(
                        alignment: Alignment.centerLeft,
                        child: IconButton(
                          tooltip: 'Raji sagalee dhaggeeffadhu',
                          icon: const Icon(
                            Icons.volume_up,
                            size: 32,
                          ),
                          onPressed: () {
                            RajiAudioService.welcome();
                          },
                        ),
                      ),

                      const SizedBox(height: 8),

                      // =================================================
                      // PAGE HEADER
                      // =================================================

                      _headerCard(context),

                      const SizedBox(height: 20),

                      // =================================================
                      // ALPHABET GRID
                      // =================================================

                      GridView.builder(
                        shrinkWrap: true,
                        physics: const NeverScrollableScrollPhysics(),
                        itemCount: alphabet.length,
                        gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                          crossAxisCount: columns,
                          crossAxisSpacing: screenWidth < 500 ? 8 : 12,
                          mainAxisSpacing: screenWidth < 500 ? 10 : 14,
                          childAspectRatio: _cardAspectRatio(screenWidth),
                        ),
                        itemBuilder: (context, index) {
                          final letter = alphabet[index];

                          return Center(
                            child: ConstrainedBox(
                              constraints: const BoxConstraints(
                                maxWidth: 220,
                              ),
                              child: _AlphabetLetterCard(
                                letter: letter,
                                index: index,
                                onTap: () {
                                  Navigator.push(
                                    context,
                                    MaterialPageRoute(
                                      builder: (_) => LetterDetailScreen(
                                        letter: letter,
                                        letterList: alphabet,
                                        index: index,
                                      ),
                                    ),
                                  );
                                },
                              ),
                            ),
                          );
                        },
                      ),

                      const SizedBox(height: 25),

                      // =================================================
                      // COMPLETE LESSON
                      // =================================================

                      const LessonCompleteButton(
                        lessonId: LessonIds.alphabet,
                      ),
                    ],
                  ),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }

  // ===============================================================
  // TOP BAR
  // ===============================================================

  Widget _topBar(BuildContext context) {
    final screenWidth = MediaQuery.of(context).size.width;

    final titleSize = screenWidth < 350
        ? 20.0
        : screenWidth < 600
            ? 24.0
            : 30.0;

    return Row(
      children: [
        IconButton.filledTonal(
          tooltip: 'Duubatti deebi\'i',
          onPressed: () {
            Navigator.of(context).pop();
          },
          icon: const Icon(Icons.arrow_back),
        ),
        const SizedBox(width: 10),
        Expanded(
          child: Text(
            'Qubee Guguddaa🔤',
            maxLines: 1,
            overflow: TextOverflow.ellipsis,
            style: TextStyle(
              fontSize: titleSize,
              fontWeight: FontWeight.bold,
            ),
          ),
        ),
        IconButton.filledTonal(
          tooltip: 'Sagalee',
          onPressed: () {
            RajiAudioService.welcome();
          },
          icon: const Icon(
            Icons.volume_up_outlined,
          ),
        ),
      ],
    );
  }

  // ===============================================================
  // HEADER CARD
  // ===============================================================

  Widget _headerCard(BuildContext context) {
    final screenWidth = MediaQuery.of(context).size.width;

    final emojiSize = screenWidth < 400
        ? 42.0
        : screenWidth < 700
            ? 52.0
            : 64.0;

    final titleSize = screenWidth < 400
        ? 18.0
        : screenWidth < 700
            ? 21.0
            : 25.0;

    final descriptionSize = screenWidth < 400
        ? 12.0
        : screenWidth < 700
            ? 13.0
            : 15.0;

    return Container(
      width: double.infinity,
      padding: EdgeInsets.all(
        screenWidth < 500 ? 14 : 20,
      ),
      decoration: BoxDecoration(
        color: Colors.white.withValues(alpha: 0.78),
        borderRadius: BorderRadius.circular(25),
        border: Border.all(
          color: Colors.white.withValues(alpha: 0.75),
          width: 1.5,
        ),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withValues(alpha: 0.05),
            blurRadius: 12,
            offset: const Offset(0, 5),
          ),
        ],
      ),
      child: Row(
        children: [
          Text(
            '🔤',
            style: TextStyle(
              fontSize: emojiSize,
            ),
          ),
          const SizedBox(width: 15),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  'Qubee Afaan Oromoo',
                  style: TextStyle(
                    fontSize: titleSize,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                const SizedBox(height: 5),
                Text(
                  'Qubee guguddaa baradhu, dubbisi, '
                  'fakkeenya isaa ilaali.',
                  style: TextStyle(
                    fontSize: descriptionSize,
                    color: Colors.black54,
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  // ===============================================================
  // RESPONSIVE CARD ASPECT RATIO
  // ===============================================================

  double _cardAspectRatio(double width) {
    if (width < 280) {
      return 0.95;
    }

    if (width < 420) {
      return 0.82;
    }

    if (width < 700) {
      return 0.78;
    }

    if (width < 1200) {
      return 0.85;
    }

    return 0.90;
  }
}

// ===================================================================
// ALPHABET LETTER CARD
// ===================================================================
//
// Important:
// - No Image.asset()
// - No letter.image
// - The letter itself is the main visual.
// - Keeps navigation to LetterDetailScreen.
// ===================================================================

class _AlphabetLetterCard extends StatefulWidget {
  const _AlphabetLetterCard({
    required this.letter,
    required this.index,
    required this.onTap,
  });

  final Letter letter;
  final int index;
  final VoidCallback onTap;

  @override
  State<_AlphabetLetterCard> createState() => _AlphabetLetterCardState();
}

class _AlphabetLetterCardState extends State<_AlphabetLetterCard> {
  bool _pressed = false;

  static const List<Color> _letterColors = [
    Color(0xffFF4F81),
    Color(0xffFF8A00),
    Color(0xff00A896),
    Color(0xff4169E1),
    Color(0xff8E44AD),
    Color(0xffE84393),
    Color(0xff009688),
    Color(0xffF39C12),
    Color(0xff2E86DE),
    Color(0xffD63031),
    Color(0xff6C5CE7),
    Color(0xff00B894),
  ];

  static const List<Color> _cardColors = [
    Color(0xfffff4f8),
    Color(0xfffff8ed),
    Color(0xffedfffb),
    Color(0xffeef4ff),
    Color(0xfff7efff),
    Color(0xfffff0f7),
  ];

  Color get _letterColor {
    return _letterColors[widget.index % _letterColors.length];
  }

  Color get _cardColor {
    return _cardColors[widget.index % _cardColors.length];
  }

  @override
  Widget build(BuildContext context) {
    final width = MediaQuery.of(context).size.width;

    final bool isSmall = width < 400;
    final bool isMedium = width >= 400 && width < 700;

    final double letterSize = isSmall
        ? 48
        : isMedium
            ? 62
            : 78;

    final double cardPadding = isSmall
        ? 8
        : isMedium
            ? 10
            : 12;

    return Semantics(
      button: true,
      label: 'Qubee ${widget.letter.uppercase}',
      child: GestureDetector(
        onTapDown: (_) {
          setState(() {
            _pressed = true;
          });
        },
        onTapCancel: () {
          setState(() {
            _pressed = false;
          });
        },
        onTapUp: (_) {
          setState(() {
            _pressed = false;
          });

          widget.onTap();
        },
        child: AnimatedScale(
          scale: _pressed ? 0.94 : 1.0,
          duration: const Duration(milliseconds: 100),
          curve: Curves.easeOut,
          child: Container(
            width: double.infinity,
            padding: EdgeInsets.all(cardPadding),
            decoration: BoxDecoration(
              color: _cardColor,
              borderRadius: BorderRadius.circular(26),
              border: Border.all(
                color: Colors.white.withValues(alpha: 0.95),
                width: 2,
              ),
              boxShadow: [
                BoxShadow(
                  color: _letterColor.withValues(alpha: 0.18),
                  blurRadius: 14,
                  offset: const Offset(0, 7),
                ),
              ],
            ),
            child: LayoutBuilder(
              builder: (context, constraints) {
                return Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    // =================================================
                    // MAIN LETTER
                    // =================================================

                    Expanded(
                      child: Center(
                        child: FittedBox(
                          fit: BoxFit.contain,
                          child: Text(
                            widget.letter.uppercase,
                            maxLines: 1,
                            textAlign: TextAlign.center,
                            style: TextStyle(
                              fontSize: letterSize,
                              fontWeight: FontWeight.w900,
                              color: _letterColor,
                              height: 0.95,
                              letterSpacing: 1,
                            ),
                          ),
                        ),
                      ),
                    ),

                    const SizedBox(height: 4),

                    // =================================================
                    // EXAMPLE WORD
                    // =================================================

                    Flexible(
                      child: Text(
                        widget.letter.example,
                        maxLines: 1,
                        overflow: TextOverflow.ellipsis,
                        textAlign: TextAlign.center,
                        style: TextStyle(
                          fontSize: isSmall
                              ? 11
                              : isMedium
                                  ? 12
                                  : 14,
                          fontWeight: FontWeight.w700,
                          color: Colors.black87,
                          height: 1.1,
                        ),
                      ),
                    ),

                    const SizedBox(height: 4),

                    // =================================================
                    // TAP INDICATOR
                    // =================================================

                    Icon(
                      Icons.touch_app_rounded,
                      size: isSmall ? 16 : 19,
                      color: _letterColor.withValues(
                        alpha: 0.65,
                      ),
                    ),
                  ],
                );
              },
            ),
          ),
        ),
      ),
    );
  }
}

// ===================================================================
// BUBBLE PAINTER
// ===================================================================

class BubblePainter extends CustomPainter {
  final double animation;

  BubblePainter(this.animation);

  @override
  void paint(
    Canvas canvas,
    Size size,
  ) {
    if (size.width <= 0 || size.height <= 0) {
      return;
    }

    final paint = Paint()
      ..color = Colors.white.withValues(
        alpha: 0.35,
      );

    for (int i = 0; i < 20; i++) {
      final double x = (i * 80) % size.width;

      final double y = ((i * 120) + animation * 200) % size.height;

      canvas.drawCircle(
        Offset(x, y),
        20 + (i % 5) * 5,
        paint,
      );
    }
  }

  @override
  bool shouldRepaint(
    covariant BubblePainter oldDelegate,
  ) {
    return oldDelegate.animation != animation;
  }
}
