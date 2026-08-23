import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../providers/progress_provider.dart';
import '../providers/reward_provider.dart';
import '../utils/responsive.dart';

class RewardScreen extends StatelessWidget {
  const RewardScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final rewards = context.watch<RewardProvider>();
    final progress = context.watch<ProgressProvider>();
    final level = rewards.stars >= 50 ? 'Learning hero' : rewards.stars >= 20 ? 'Strong learner' : rewards.stars >= 5 ? 'Beginner' : 'New learner';
    return Scaffold(
      appBar: AppBar(title: const Text('My rewards')),
      body: SafeArea(
        child: SingleChildScrollView(
          padding: EdgeInsets.all(Responsive.pagePadding(context)),
          child: Column(children: [
            Container(
              width: double.infinity,
              padding: const EdgeInsets.all(24),
              decoration: BoxDecoration(gradient: LinearGradient(colors: [Colors.amber.shade700, Colors.orange]), borderRadius: BorderRadius.circular(28)),
              child: Column(children: [
                const Icon(Icons.star_rounded, size: 72, color: Colors.white),
                const SizedBox(height: 8),
                Text('${rewards.stars}', style: const TextStyle(fontSize: 48, color: Colors.white, fontWeight: FontWeight.w800)),
                const Text('Stars earned', style: TextStyle(color: Colors.white, fontSize: 18)),
              ]),
            ),
            const SizedBox(height: 24),
            GridView.count(
              crossAxisCount: Responsive.homeColumns(context, max: 4),
              shrinkWrap: true,
              physics: const NeverScrollableScrollPhysics(),
              crossAxisSpacing: 12,
              mainAxisSpacing: 12,
              childAspectRatio: 1.35,
              children: [
                _metric(Icons.menu_book_rounded, '${rewards.lessons > progress.completedCount ? rewards.lessons : progress.completedCount}', 'Lessons', Colors.green),
                _metric(Icons.games_rounded, '${rewards.gamesCompleted}', 'Games', Colors.blue),
                _metric(Icons.monetization_on_rounded, '${rewards.coins}', 'Coins', Colors.teal),
                _metric(Icons.bolt_rounded, '${rewards.xp}', 'Experience', Colors.deepPurple),
              ],
            ),
            const SizedBox(height: 22),
            Card(child: ListTile(leading: const Icon(Icons.emoji_events_rounded, color: Colors.orange), title: const Text('Current level'), trailing: Text(level, style: const TextStyle(fontWeight: FontWeight.w700)))),
          ]),
        ),
      ),
    );
  }

  Widget _metric(IconData icon, String value, String label, Color color) => Container(
        padding: const EdgeInsets.all(14),
        decoration: BoxDecoration(color: color.withValues(alpha: .1), borderRadius: BorderRadius.circular(20)),
        child: Column(crossAxisAlignment: CrossAxisAlignment.start, mainAxisAlignment: MainAxisAlignment.center, children: [Icon(icon, color: color), const SizedBox(height: 6), Text(value, style: TextStyle(fontSize: 22, fontWeight: FontWeight.w800, color: color)), Text(label)]),
      );
}
