import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../../models/coloring_page.dart';
import '../../providers/age_provider.dart';
import '../../providers/coloring_catalog_provider.dart';
import '../../providers/learning_path_provider.dart';
import '../../utils/responsive.dart';
import 'coloring_canvas_screen.dart';
import '../../widgets/coloring/coloring_category_screen.dart';
import 'coloring_gallery_screen.dart';

class ColoringHomeScreen extends StatefulWidget {
  const ColoringHomeScreen({super.key});

  @override
  State<ColoringHomeScreen> createState() => _ColoringHomeScreenState();
}

class _ColoringHomeScreenState extends State<ColoringHomeScreen> {
  String _search = '';

  @override
  void initState() {
    super.initState();
    Future<void>.microtask(
        () => context.read<ColoringCatalogProvider>().initialize());
  }

  @override
  Widget build(BuildContext context) {
    final catalog = context.watch<ColoringCatalogProvider>();
    final filteredCategories = catalog.categories
        .where((category) =>
            category.toLowerCase().contains(_search.toLowerCase()))
        .toList();
    return Scaffold(
      backgroundColor: const Color(0xffEAF7FF),
      body: SafeArea(
        child: Column(
          children: [
            _header(catalog),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 20),
              child: TextField(
                onChanged: (value) => setState(() => _search = value),
                decoration: InputDecoration(
                  hintText: '🔍 Barbaadi...',
                  filled: true,
                  fillColor: Colors.white,
                  prefixIcon: const Icon(Icons.search),
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(20),
                    borderSide: BorderSide.none,
                  ),
                ),
              ),
            ),
            const SizedBox(height: 12),
            if (catalog.isLoading && catalog.pages.isEmpty)
              const Expanded(child: Center(child: CircularProgressIndicator()))
            else if (catalog.pages.isEmpty)
              _emptyState(catalog)
            else
              Expanded(
                child: GridView.builder(
                  padding: EdgeInsets.symmetric(
                    horizontal: Responsive.pagePadding(context),
                    vertical: 8,
                  ),
                  itemCount: filteredCategories.length,
                  gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                    crossAxisCount: Responsive.homeColumns(context, max: 5),
                    crossAxisSpacing: 14,
                    mainAxisSpacing: 14,
                    childAspectRatio: 1.05,
                  ),
                  itemBuilder: (_, index) {
                    final category = filteredCategories[index];
                    final count = catalog.pages
                        .where((page) => page.category == category)
                        .length;
                    return _categoryCard(category, count);
                  },
                ),
              ),
          ],
        ),
      ),
    );
  }

  Widget _header(ColoringCatalogProvider catalog) => Padding(
        padding: const EdgeInsets.fromLTRB(20, 18, 14, 8),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                const Text('🎨', style: TextStyle(fontSize: 40)),
                const SizedBox(width: 10),
                const Expanded(
                  child: Text('Halluu Dibuu',
                      style:
                          TextStyle(fontSize: 29, fontWeight: FontWeight.bold)),
                ),
                IconButton(
                  tooltip: 'My gallery',
                  onPressed: () => Navigator.of(context).push(
                    MaterialPageRoute(
                        builder: (_) => const ColoringGalleryScreen()),
                  ),
                  icon: const Icon(Icons.photo_library_rounded),
                ),
              ],
            ),
            const Text('Halluu dibuun baradhu, taphadhu fi kalaqi.'),
            const SizedBox(height: 10),
            FilledButton.icon(
              onPressed:
                  catalog.pages.isEmpty ? null : () => _pickForMe(catalog),
              icon: const Icon(Icons.casino_rounded),
              label: const Text('Naaf fili'),
            ),
          ],
        ),
      );

  Widget _emptyState(ColoringCatalogProvider catalog) => Expanded(
        child: Center(
          child: Padding(
            padding: const EdgeInsets.all(28),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                const Icon(Icons.auto_awesome_rounded,
                    size: 64, color: Colors.deepOrange),
                const SizedBox(height: 12),
                const Text('Fuulawwan haaraan qophaa’aa jiru.',
                    textAlign: TextAlign.center),
                if (catalog.error != null) ...[
                  const SizedBox(height: 8),
                  Text(catalog.error!, textAlign: TextAlign.center),
                ],
                const SizedBox(height: 12),
                OutlinedButton(
                  onPressed: () => catalog.processNextBatch(maximum: 8),
                  child: const Text('Haaromsi'),
                ),
              ],
            ),
          ),
        ),
      );

  Widget _categoryCard(String category, int count) => Semantics(
        button: true,
        label: '$category, $count pages',
        child: InkWell(
          borderRadius: BorderRadius.circular(24),
          onTap: () => Navigator.of(context).push(MaterialPageRoute(
            builder: (_) => ColoringCategoryScreen(category: category),
          )),
          child: Ink(
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.circular(24),
              boxShadow: const [
                BoxShadow(color: Color(0x14000000), blurRadius: 10)
              ],
            ),
            child: Padding(
              padding: const EdgeInsets.all(18),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Text(_emoji(category), style: const TextStyle(fontSize: 42)),
                  const SizedBox(height: 8),
                  Text(category,
                      textAlign: TextAlign.center,
                      style: const TextStyle(
                          fontWeight: FontWeight.bold, fontSize: 16)),
                  Text('$count suuraa',
                      style: TextStyle(color: Colors.grey.shade700)),
                ],
              ),
            ),
          ),
        ),
      );

  void _pickForMe(ColoringCatalogProvider catalog) {
    final age = context.read<AgeProvider>().age;
    final learning = context.read<LearningPathProvider>();
    final page = catalog.randomPage(
      age: age,
      currentLessonIds:
          learning.todayTasks.map((task) => task.id.replaceFirst('daily_', '')),
    );
    if (page == null) return;
    _open(page);
  }

  void _open(ColoringPage page) => Navigator.of(context).push(
        MaterialPageRoute(builder: (_) => ColoringCanvasScreen(page: page)),
      );

  String _emoji(String category) => switch (category) {
        'Qubee' => '🔤',
        'Lakkoofsa' => '🔢',
        'Bineensota' => '🐾',
        'Biqiltoota' || 'Uumama' => '🌿',
        'Muduraa' => '🍎',
        'Kuduraa' => '🥕',
        'Nyaata' => '🍽️',
        'Geejjibaa' => '🚗',
        'Aadaa' => '🏛️',
        _ => '🎨',
      };
}
