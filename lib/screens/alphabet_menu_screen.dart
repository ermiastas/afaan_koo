import 'package:flutter/material.dart';

import 'alphabet_screen.dart';
import 'lowercase_screen.dart';
import 'vowel_screen.dart';
import 'consonant_screen.dart';
import 'double_letter_screen.dart';
import 'tracing_practice_screen.dart';
import '../utils/responsive.dart';
import '../widgets/background/moving_clouds.dart';

class AlphabetMenuScreen extends StatelessWidget {
  const AlphabetMenuScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Qubee'),
        centerTitle: true,
      ),
      body: Stack(
        children: [
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
          const MovingClouds(),
          SafeArea(
            child: LayoutBuilder(
              builder: (context, constraints) {
                final width = constraints.maxWidth;
                final padding = Responsive.pagePadding(context);

                final int columns;
                if (width < 400) {
                  columns = 2;
                } else if (width < 800) {
                  columns = 3;
                } else if (width < 1200) {
                  columns = 4;
                } else {
                  columns = 5;
                }

                const spacing = 16.0;

                final availableWidth =
                    width - (padding * 2) - (spacing * (columns - 1));

                final cardWidth = availableWidth / columns;

                final cards = [
                  _AlphabetCard(
                    title: 'Qubee Guguddaa',
                    subtitle: 'A B C D E ...',
                    symbol: 'A',
                    color: Colors.blue,
                    onTap: () {
                      _go(context, const AlphabetScreen());
                    },
                  ),
                  _AlphabetCard(
                    title: 'Qubee Xiqqaa',
                    subtitle: 'a b c d e ...',
                    symbol: 'a',
                    color: Colors.green,
                    onTap: () {
                      _go(context, const LowercaseScreen());
                    },
                  ),
                  _AlphabetCard(
                    title: 'Dubbachiiftuu',
                    subtitle: 'A E I O U',
                    symbol: 'A',
                    color: Colors.orange,
                    onTap: () {
                      _go(context, const VowelScreen());
                    },
                  ),
                  _AlphabetCard(
                    title: 'Dubbifamaa',
                    subtitle: 'B C D F ...',
                    symbol: 'B',
                    color: Colors.deepPurple,
                    onTap: () {
                      _go(context, const ConsonantScreen());
                    },
                  ),
                  _AlphabetCard(
                    title: 'Qubee Dachaa',
                    subtitle: 'Ch Dh Ny Ph Sh',
                    symbol: 'Ch',
                    color: Colors.indigo,
                    onTap: () {
                      _go(context, const DoubleLetterScreen());
                    },
                  ),
                  _AlphabetCard(
                    title: 'Qubee Barreessi',
                    subtitle: 'Harkaan barreessuu shaakali',
                    symbol: '✎',
                    color: Colors.teal,
                    onTap: () {
                      _go(
                        context,
                        const TracingPracticeScreen(
                          mode: TracingMode.alphabet,
                        ),
                      );
                    },
                  ),
                ];

                return SingleChildScrollView(
                  physics: const BouncingScrollPhysics(),
                  padding: EdgeInsets.all(padding),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      const Text(
                        'Qubee Afaan Oromoo',
                        style: TextStyle(
                          fontSize: 25,
                          fontWeight: FontWeight.w800,
                          height: 1.15,
                        ),
                      ),
                      const SizedBox(height: 6),
                      const Text(
                        'Kutaa barnootaa filadhu',
                        style: TextStyle(
                          fontSize: 16,
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                      const SizedBox(height: 20),
                      Wrap(
                        spacing: spacing,
                        runSpacing: spacing,
                        children: cards.map((card) {
                          return SizedBox(
                            width: cardWidth,
                            child: card,
                          );
                        }).toList(),
                      ),
                    ],
                  ),
                );
              },
            ),
          ),
        ],
      ),
    );
  }

  void _go(
    BuildContext context,
    Widget page,
  ) {
    Navigator.of(context).push(
      MaterialPageRoute(
        builder: (_) => page,
      ),
    );
  }
}

class _AlphabetCard extends StatelessWidget {
  final String title;
  final String subtitle;
  final String symbol;
  final Color color;
  final VoidCallback onTap;

  const _AlphabetCard({
    required this.title,
    required this.subtitle,
    required this.symbol,
    required this.color,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: 180,
      child: Material(
        color: Colors.white.withValues(alpha: 0.94),
        borderRadius: BorderRadius.circular(24),
        clipBehavior: Clip.antiAlias,
        child: InkWell(
          onTap: onTap,
          child: Container(
            padding: const EdgeInsets.all(10),
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(24),
              border: Border.all(
                color: color.withValues(alpha: 0.35),
                width: 2,
              ),
              boxShadow: [
                BoxShadow(
                  color: color.withValues(alpha: 0.12),
                  blurRadius: 10,
                  offset: const Offset(0, 5),
                ),
              ],
            ),
            child: Center(
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Container(
                    width: 62,
                    height: 62,
                    decoration: BoxDecoration(
                      color: color.withValues(alpha: 0.10),
                      shape: BoxShape.circle,
                      border: Border.all(
                        color: color.withValues(alpha: 0.35),
                        width: 2,
                      ),
                    ),
                    alignment: Alignment.center,
                    child: Text(
                      symbol,
                      maxLines: 1,
                      overflow: TextOverflow.clip,
                      textAlign: TextAlign.center,
                      style: TextStyle(
                        fontSize: symbol.length > 1 ? 27 : 34,
                        fontWeight: FontWeight.w900,
                        color: color,
                        height: 1,
                      ),
                    ),
                  ),
                  const SizedBox(height: 8),
                  Text(
                    title,
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                    textAlign: TextAlign.center,
                    style: const TextStyle(
                      fontSize: 15,
                      fontWeight: FontWeight.w800,
                      height: 1.1,
                    ),
                  ),
                  const SizedBox(height: 4),
                  Text(
                    subtitle,
                    maxLines: 2,
                    overflow: TextOverflow.ellipsis,
                    textAlign: TextAlign.center,
                    style: TextStyle(
                      fontSize: 12,
                      fontWeight: FontWeight.w600,
                      height: 1.1,
                      color: color.withValues(alpha: 0.85),
                    ),
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}
