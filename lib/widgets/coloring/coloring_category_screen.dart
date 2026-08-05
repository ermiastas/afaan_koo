import 'package:flutter/material.dart';

import '../../data/coloring_data.dart';
import '../../models/coloring_category.dart';
import '../../models/coloring_page.dart';

import '../../screens/coloring/coloring_canvas_screen.dart';
import 'coloring_page_card.dart';


class ColoringCategoryScreen extends StatefulWidget {

  final ColoringCategory category;

  const ColoringCategoryScreen({

    super.key,

    required this.category,

  });

  @override
  State<ColoringCategoryScreen> createState() =>
      _ColoringCategoryScreenState();

}

class _ColoringCategoryScreenState
    extends State<ColoringCategoryScreen> {

  String search = "";

  @override
  Widget build(BuildContext context) {

    final width = MediaQuery.of(context).size.width;

    final columns =

        width < 500

            ? 2

            : width < 900

                ? 3

                : 4;

    final List<ColoringPage> pages =

        coloringPages.where((page) {

      if (page.category != widget.category.id) {

        return false;

      }

      if (search.isEmpty) {

        return true;

      }

      final q = search.toLowerCase();

      return page.titleOromo
              .toLowerCase()
              .contains(q) ||

          page.titleEnglish
              .toLowerCase()
              .contains(q);

    }).toList();

    return Scaffold(

      backgroundColor:
          const Color(0xffEAF7FF),

      appBar: AppBar(

        backgroundColor:
            Colors.transparent,

        elevation: 0,

        centerTitle: true,

        title: Row(

          mainAxisSize: MainAxisSize.min,

          children: [

            Hero(

              tag: widget.category.id,

              child: Text(

                widget.category.emoji,

                style: const TextStyle(

                  fontSize: 34,

                ),

              ),

            ),

            const SizedBox(width: 10),

            Text(

              widget.category.title,

              style: const TextStyle(

                color: Colors.black,

              ),

            ),

          ],

        ),

      ),

      body: Column(

        children: [

          Padding(

            padding: const EdgeInsets.all(16),

            child: TextField(

              onChanged: (value) {

                setState(() {

                  search = value;

                });

              },

              decoration: InputDecoration(

                hintText:

                    "🔍 Suuraa barbaadi",

                prefixIcon:
                    const Icon(Icons.search),

                filled: true,

                fillColor: Colors.white,

                border: OutlineInputBorder(

                  borderRadius:
                      BorderRadius.circular(20),

                  borderSide:
                      BorderSide.none,

                ),

              ),

            ),

          ),

          Padding(

            padding: const EdgeInsets.symmetric(
              horizontal: 18,
            ),

            child: Align(

              alignment: Alignment.centerLeft,

              child: Text(

                "${pages.length} Suuraawwan",

                style: const TextStyle(

                  fontWeight: FontWeight.bold,

                  fontSize: 18,

                ),

              ),

            ),

          ),

          const SizedBox(height: 10),

          Expanded(

            child: GridView.builder(

              padding:
                  const EdgeInsets.all(16),

              itemCount: pages.length,

              gridDelegate:

                  SliverGridDelegateWithFixedCrossAxisCount(

                crossAxisCount: columns,

                crossAxisSpacing: 14,

                mainAxisSpacing: 14,

                childAspectRatio: .82,

              ),

              itemBuilder: (_, index) {

                final page = pages[index];

                return ColoringPageCard(

                  page: page,

                  onTap: () {

                    Navigator.of(context).push(

                      MaterialPageRoute(

                        builder: (context) => ColoringCanvasScreen(

                          page: page,

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

    );

  }

}