import 'dart:math';

import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../models/game_item.dart';
import '../providers/reward_provider.dart';

class BalloonCountGame extends StatefulWidget {
  final GameItem game;
  const BalloonCountGame({super.key, required this.game});

  @override
  State<BalloonCountGame> createState() => _BalloonCountGameState();
}

class _BalloonCountGameState extends State<BalloonCountGame> with SingleTickerProviderStateMixin {
  final _random = Random();
  late AnimationController _float;
  int _target = 1;
  int _score = 0;
  bool _finished = false;

  @override
  void initState() {
    super.initState();
    _float = AnimationController(vsync: this, duration: const Duration(milliseconds: 1400))..repeat(reverse: true);
    _newRound();
  }

  void _newRound() => _target = _random.nextInt(9) + 1;
  void _choose(int value) {
    if (_finished) return;
    if (value == _target) {
      if (_score == 4) {
        setState(() { _score++; _finished = true; });
        context.read<RewardProvider>().completeGame(xp: widget.game.rewardXP, coins: widget.game.rewardCoins, stars: widget.game.rewardStars, gameId: widget.game.id);
      } else {
        setState(() { _score++; _newRound(); });
      }
    } else {
      ScaffoldMessenger.of(context).showSnackBar(const SnackBar(content: Text('Try again — count the balloons slowly!')));
    }
  }

  @override
  void dispose() { _float.dispose(); super.dispose(); }

  @override
  Widget build(BuildContext context) {
    final options = <int>{_target};
    while (options.length < 3) { options.add(_random.nextInt(9) + 1); }
    return Scaffold(
      appBar: AppBar(title: const Text('Balloon counting')),
      body: Padding(
        padding: const EdgeInsets.all(20),
        child: Column(children: [
          Text('Round ${_score + 1} of 5', style: const TextStyle(fontWeight: FontWeight.bold)),
          const SizedBox(height: 12),
          const Text('How many balloons can you count?', style: TextStyle(fontSize: 24, fontWeight: FontWeight.w800), textAlign: TextAlign.center),
          const SizedBox(height: 20),
          Expanded(child: AnimatedBuilder(animation: _float, builder: (context, child) => Transform.translate(offset: Offset(0, -12 * _float.value), child: Wrap(alignment: WrapAlignment.center, spacing: 8, runSpacing: 10, children: List.generate(_target, (index) => Text(['🎈', '🎈', '🎈'][index % 3], style: const TextStyle(fontSize: 54))))))),
          if (_finished) const Text('🎉 You are a counting star!', style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold)),
          Wrap(spacing: 12, runSpacing: 12, alignment: WrapAlignment.center, children: options.map((value) => FilledButton(onPressed: _finished ? null : () => _choose(value), style: FilledButton.styleFrom(minimumSize: const Size(86, 60), textStyle: const TextStyle(fontSize: 25, fontWeight: FontWeight.bold)), child: Text('$value'))).toList()),
          const SizedBox(height: 24),
        ]),
      ),
    );
  }
}
