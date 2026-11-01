import 'package:flutter/material.dart';

import '../data/alphabet_data.dart';
import '../models/letter.dart';
import '../utils/responsive.dart';
import 'letter_detail_screen.dart';

class LowercaseAlphabetScreen extends StatelessWidget {
  const LowercaseAlphabetScreen({
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    final screenWidth = MediaQuery.of(context).size.width;
    final columns = Responsive.homeColumns(context);

    return Scaffold(
      body: Container(
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
        child: SafeArea(
          child: Column(
            children: [
              _topBar(context, screenWidth),
              Expanded(
                child: GridView.builder(
                  padding: EdgeInsets.fromLTRB(
                    Responsive.pagePadding(context),
                    12,
                    Responsive.pagePadding(context),
                    24,
                  ),
                  itemCount: letters.length,
                  gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                    crossAxisCount: columns,
                    crossAxisSpacing: screenWidth < 500 ? 8 : 12,
                    mainAxisSpacing: screenWidth < 500 ? 10 : 14,
                    childAspectRatio: _cardAspectRatio(screenWidth),
                  ),
                  itemBuilder: (context, index) {
                    final letter = letters[index];

                    return _AlphabetLetterCard(
                      letter: letter,
                      index: index,
                      lowercase: true,
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
            tooltip: 'Duubatti deebi\'i',
            onPressed: () {
              Navigator.of(context).pop();
            },
            icon: const Icon(Icons.arrow_back),
          ),
          const SizedBox(width: 10),
          Expanded(
            child: Text(
              'Qubee Xiqqaa 🔡',
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

class _AlphabetLetterCard extends StatefulWidget {
  const _AlphabetLetterCard({
    required this.letter,
    required this.index,
    required this.lowercase,
    required this.onTap,
  });

  final Letter letter;
  final int index;
  final bool lowercase;
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

  Color get _letterColor => _letterColors[widget.index % _letterColors.length];

  Color get _cardColor => _cardColors[widget.index % _cardColors.length];

  @override
  Widget build(BuildContext context) {
    final width = MediaQuery.of(context).size.width;

    final small = width < 400;
    final medium = width >= 400 && width < 700;

    final letterSize = small
        ? 52.0
        : medium
            ? 66.0
            : 82.0;

    return Semantics(
      button: true,
      label: 'Qubee ${widget.letter.lowercase}',
      child: GestureDetector(
        onTapDown: (_) {
          setState(() => _pressed = true);
        },
        onTapCancel: () {
          setState(() => _pressed = false);
        },
        onTapUp: (_) {
          setState(() => _pressed = false);
          widget.onTap();
        },
        child: AnimatedScale(
          scale: _pressed ? 0.94 : 1.0,
          duration: const Duration(milliseconds: 100),
          child: Container(
            width: double.infinity,
            padding: EdgeInsets.all(small ? 8 : 12),
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
            child: Column(
              children: [
                Expanded(
                  child: Center(
                    child: FittedBox(
                      fit: BoxFit.contain,
                      child: Text(
                        widget.letter.lowercase,
                        maxLines: 1,
                        style: TextStyle(
                          fontSize: letterSize,
                          fontWeight: FontWeight.w900,
                          color: _letterColor,
                          height: 0.9,
                          letterSpacing: 1,
                        ),
                      ),
                    ),
                  ),
                ),
                const SizedBox(height: 4),
                Flexible(
                  child: Text(
                    widget.letter.example,
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                    textAlign: TextAlign.center,
                    style: TextStyle(
                      fontSize: small
                          ? 11
                          : medium
                              ? 12
                              : 14,
                      fontWeight: FontWeight.w700,
                      height: 1.1,
                    ),
                  ),
                ),
                const SizedBox(height: 4),
                Icon(
                  Icons.touch_app_rounded,
                  size: small ? 16 : 19,
                  color: _letterColor.withValues(alpha: 0.65),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
