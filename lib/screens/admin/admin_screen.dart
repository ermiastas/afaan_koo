import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../../providers/admin_provider.dart';
import 'coloring_review_screen.dart';
import 'content_manager_screen.dart';
import '../../utils/responsive.dart';

class AdminScreen extends StatelessWidget {
  const AdminScreen({super.key});

  @override
  Widget build(BuildContext context) {
    const categories = [
      ('animals', 'Animals', Icons.pets, Colors.green),
      ('alphabet', 'Alphabet', Icons.abc, Colors.orange),
      ('words', 'Words', Icons.menu_book, Colors.blue),
      ('colors', 'Colors', Icons.color_lens, Colors.purple),
      ('numbers', 'Numbers', Icons.numbers, Colors.red),
      ('stories', 'Stories', Icons.auto_stories, Colors.brown),
      ('songs', 'Songs', Icons.music_note, Colors.teal),
      ('quiz', 'Quiz', Icons.quiz, Colors.indigo),
      ('videos', 'Videos', Icons.ondemand_video_rounded, Colors.deepPurple),
      ('custom', 'Custom content', Icons.edit_note_rounded, Colors.blueGrey),
    ];
    return Scaffold(
      appBar: AppBar(
        title: const Text('Admin Dashboard'),
        actions: [
          IconButton(
            tooltip: 'Sign out',
            icon: const Icon(Icons.logout),
            onPressed: () {
              context.read<AdminProvider>().logout();
              Navigator.of(context).pop();
            },
          ),
        ],
      ),
      body: Column(
        children: [
          Padding(
            padding: const EdgeInsets.fromLTRB(15, 15, 15, 0),
            child: SizedBox(
              width: double.infinity,
              child: OutlinedButton.icon(
                icon: const Icon(Icons.palette_outlined),
                label: const Text('Review generated coloring pages'),
                onPressed: () => Navigator.of(context).push(
                  MaterialPageRoute(
                      builder: (_) => const ColoringReviewScreen()),
                ),
              ),
            ),
          ),
          Expanded(
            child: GridView.builder(
              padding: EdgeInsets.all(Responsive.pagePadding(context)),
              gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                crossAxisCount: Responsive.homeColumns(context, max: 5),
                crossAxisSpacing: 15,
                mainAxisSpacing: 15,
              ),
              itemCount: categories.length,
              itemBuilder: (_, index) {
                final item = categories[index];
                return Card(
                  elevation: 5,
                  shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(20)),
                  child: InkWell(
                    borderRadius: BorderRadius.circular(20),
                    onTap: () => Navigator.of(context).push(MaterialPageRoute(
                      builder: (_) => ContentManagerScreen(category: item.$1),
                    )),
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Icon(item.$3, size: 55, color: item.$4),
                        const SizedBox(height: 15),
                        Text(item.$2,
                            style: const TextStyle(
                                fontSize: 20, fontWeight: FontWeight.bold)),
                      ],
                    ),
                  ),
                );
              },
            ),
          ),
        ],
      ),
    );
  }
}
