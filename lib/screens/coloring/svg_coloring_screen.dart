import 'package:flutter/material.dart';

import '../../models/coloring_svg_item.dart';
import '../../services/coloring_state_service.dart';
import '../../widgets/coloring/interactive_svg_coloring.dart';

class SvgColoringScreen extends StatefulWidget {
  final ColoringSvgItem page;

  const SvgColoringScreen({
    super.key,
    required this.page,
  });

  @override
  State<SvgColoringScreen> createState() => _SvgColoringScreenState();
}

class _SvgColoringScreenState extends State<SvgColoringScreen> {
  Color selectedColor = Colors.red;

  final ColoringStateService coloringService = ColoringStateService();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("${widget.page.emoji} ${widget.page.titleOromo}"),
      ),
      body: Column(
        children: [
          Expanded(
            child: Center(
                child: InteractiveSvgColoring(
              pageId: widget.page.id,
              svgAsset: widget.page.svgAsset,
              selectedColor: selectedColor,
              service: coloringService,
              pageReward: 0,
            )),
          ),
          SizedBox(
            height: 80,
            child: ListView(
              scrollDirection: Axis.horizontal,
              children: [
                Colors.red,
                Colors.blue,
                Colors.green,
                Colors.yellow,
                Colors.orange,
                Colors.purple,
              ].map((color) {
                return GestureDetector(
                  onTap: () {
                    setState(() {
                      selectedColor = color;
                    });
                  },
                  child: Container(
                    margin: const EdgeInsets.all(10),
                    width: 50,
                    height: 50,
                    decoration: BoxDecoration(
                      color: color,
                      shape: BoxShape.circle,
                    ),
                  ),
                );
              }).toList(),
            ),
          )
        ],
      ),
    );
  }
}
