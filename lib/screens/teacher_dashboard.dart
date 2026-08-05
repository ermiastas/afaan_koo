import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:supabase_flutter/supabase_flutter.dart';
import '../providers/progress_provider.dart';
import '../providers/reward_provider.dart';

class TeacherDashboard extends StatelessWidget {
  const TeacherDashboard({super.key});

  @override
  Widget build(BuildContext context) {
    final progress = context.watch<ProgressProvider>();
    final rewards = context.watch<RewardProvider>();
    return Scaffold(
      appBar: AppBar(title: const Text('Teacher space'), actions: [IconButton(tooltip: 'Sign out', onPressed: () async { await Supabase.instance.client.auth.signOut(); if (context.mounted) Navigator.of(context).pop(); }, icon: const Icon(Icons.logout_rounded))]),
      body: SingleChildScrollView(padding: const EdgeInsets.all(20), child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
        Container(padding: const EdgeInsets.all(22), decoration: BoxDecoration(gradient: LinearGradient(colors: [Colors.indigo, Colors.lightBlue.shade600]), borderRadius: BorderRadius.circular(28)), child: const Row(children: [CircleAvatar(radius: 28, child: Icon(Icons.school_rounded, size: 30)), SizedBox(width: 16), Expanded(child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [Text('Learning insights', style: TextStyle(color: Colors.white, fontSize: 24, fontWeight: FontWeight.w800)), SizedBox(height: 4), Text('Use progress to encourage the next small win.', style: TextStyle(color: Colors.white))]))])),
        const SizedBox(height: 24),
        const Text('Current learner snapshot', style: TextStyle(fontSize: 23, fontWeight: FontWeight.w800)),
        const SizedBox(height: 12),
        _tile(Icons.menu_book_rounded, '${progress.completedCount}', 'Lessons completed', Colors.indigo),
        _tile(Icons.games_rounded, '${rewards.gamesCompleted}', 'Games completed', Colors.green),
        _tile(Icons.draw_rounded, '${progress.progress.gamesCompleted}', 'Handwriting challenges', Colors.indigo),
        _tile(Icons.star_rounded, '${rewards.stars}', 'Stars earned', Colors.amber.shade800),
        const SizedBox(height: 20),
        const Text('EMM teaching rhythm', style: TextStyle(fontSize: 23, fontWeight: FontWeight.w800)),
        const SizedBox(height: 10),
        const Card(child: Padding(padding: EdgeInsets.all(18), child: Text('Invite a child to explore a lesson, let them practise through play, recognise their effort, then use their results to choose a kind next challenge.'))),
      ])),
    );
  }
  Widget _tile(IconData icon, String value, String title, Color color) => Card(child: ListTile(leading: CircleAvatar(backgroundColor: color.withValues(alpha: .12), child: Icon(icon, color: color)), title: Text(title), trailing: Text(value, style: TextStyle(fontWeight: FontWeight.w800, fontSize: 22, color: color))));
}
