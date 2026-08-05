import 'dart:math';

import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../data/alphabet_data.dart';
import '../models/game_item.dart';
import '../providers/reward_provider.dart';
import '../widgets/alphabet_tracing_widget.dart';

class AlphabetTracingGame extends StatefulWidget {
  final GameItem game;
  const AlphabetTracingGame({super.key, required this.game});

  @override
  State<AlphabetTracingGame> createState() => _AlphabetTracingGameState();
}

class _AlphabetTracingGameState extends State<AlphabetTracingGame> {
  final _random = Random();
  late List<int> _rounds;
  int _round = 0;
  bool _isComplete = false;
  bool _celebratedRound = false;

  @override
  void initState() {
    super.initState();
    _rounds = List<int>.generate(letters.length, (index) => index)..shuffle(_random);
    _rounds = _rounds.take(5).toList();
  }

  void _finishStroke() {
    if (_celebratedRound || _isComplete) return;
    setState(() => _celebratedRound = true);
    if (_round == _rounds.length - 1) {
      setState(() => _isComplete = true);
      context.read<RewardProvider>().completeGame(
        xp: widget.game.rewardXP,
        coins: widget.game.rewardCoins,
        stars: widget.game.rewardStars,
        gameId: widget.game.id,
      );
      return;
    }
    Future.delayed(const Duration(milliseconds: 850), () {
      if (!mounted) return;
      setState(() {
        _round++;
        _celebratedRound = false;
      });
    });
  }

  @override
  Widget build(BuildContext context) {
    final letter = letters[_rounds[_round]];
    return Scaffold(
      appBar: AppBar(title: const Text('Alphabet tracing game')),
      body: SafeArea(
        child: SingleChildScrollView(
          padding: const EdgeInsets.all(16),
          child: Column(children: [
            LinearProgressIndicator(value: (_round + (_isComplete ? 1 : 0)) / _rounds.length, minHeight: 10),
            const SizedBox(height: 10),
            Text(_isComplete ? 'You completed every round!' : 'Round ${_round + 1} of ${_rounds.length}', style: const TextStyle(fontSize: 20, fontWeight: FontWeight.bold)),
            const SizedBox(height: 8),
            Text(_isComplete ? 'Great focus and careful writing!' : 'Trace ${letter.uppercase} and ${letter.lowercase} to earn a star.', textAlign: TextAlign.center, style: const TextStyle(fontSize: 17)),
            const SizedBox(height: 12),
            if (!_isComplete)
              AlphabetTracingWidget(
                key: ValueKey('$_round-${letter.uppercase}'),
                capitalLetter: letter.uppercase,
                smallLetter: letter.lowercase,
                onComplete: _finishStroke,
              )
            else
              const Padding(padding: EdgeInsets.all(72), child: Text('Fantastic tracing!', style: TextStyle(fontSize: 30, fontWeight: FontWeight.w800))),
            if (_celebratedRound && !_isComplete) const Text('Nice tracing! Next letter coming up…', style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
            if (_isComplete) FilledButton.icon(onPressed: () => Navigator.of(context).pop(), icon: const Icon(Icons.emoji_events_rounded), label: const Text('Collect rewards')),
          ]),
        ),
      ),
    );
  }
}
