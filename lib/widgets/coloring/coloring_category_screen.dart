import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../../providers/coloring_catalog_provider.dart';
import '../../screens/coloring/coloring_canvas_screen.dart';
import '../../utils/responsive.dart';
import 'coloring_page_card.dart';

class ColoringCategoryScreen extends StatefulWidget {
  const ColoringCategoryScreen({super.key, required this.category});

  final String category;

  @override
  State<ColoringCategoryScreen> createState() => _ColoringCategoryScreenState();
}

class _ColoringCategoryScreenState extends State<ColoringCategoryScreen> {
  String _search = '';

  @override
  Widget build(BuildContext context) {
    final pages = context.watch<ColoringCatalogProvider>().pages.where((page) {
      final query = _search.toLowerCase();
      return page.category == widget.category &&
          (query.isEmpty ||
              page.titleOromo.toLowerCase().contains(query) ||
              page.titleEnglish.toLowerCase().contains(query));
    }).toList();
    final columns = Responsive.homeColumns(context, max: 4);
    return Scaffold(
      backgroundColor: const Color(0xffEAF7FF),
      appBar: AppBar(title: Text(widget.category)),
      body: Column(
        children: [
          Padding(
            padding: EdgeInsets.all(Responsive.pagePadding(context)),
            child: TextField(
              onChanged: (value) => setState(() => _search = value),
              decoration: InputDecoration(
                hintText: '🔍 Suuraa barbaadi',
                prefixIcon: const Icon(Icons.search),
                filled: true,
                fillColor: Colors.white,
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(20),
                  borderSide: BorderSide.none,
                ),
              ),
            ),
          ),
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 18),
            child: Align(
              alignment: Alignment.centerLeft,
              child: Text('${pages.length} Suuraawwan',
                  style: const TextStyle(fontWeight: FontWeight.bold)),
            ),
          ),
          const SizedBox(height: 8),
          Expanded(
            child: GridView.builder(
              padding: EdgeInsets.all(Responsive.pagePadding(context)),
              itemCount: pages.length,
              gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                crossAxisCount: columns,
                crossAxisSpacing: 14,
                mainAxisSpacing: 14,
                childAspectRatio: .82,
              ),
              itemBuilder: (_, index) => ColoringPageCard(
                page: pages[index],
                onTap: () => Navigator.of(context).push(MaterialPageRoute(
                  builder: (_) => ColoringCanvasScreen(page: pages[index]),
                )),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
