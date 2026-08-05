import 'package:flutter/material.dart';

import '../../models/coloring_category.dart';

class ColoringCategoryCard extends StatefulWidget {
  final ColoringCategory category;
  final VoidCallback onTap;

  const ColoringCategoryCard({
    super.key,
    required this.category,
    required this.onTap,
  });

  @override
  State<ColoringCategoryCard> createState() =>
      _ColoringCategoryCardState();
}

class _ColoringCategoryCardState
    extends State<ColoringCategoryCard>
    with SingleTickerProviderStateMixin {
  late final AnimationController _controller;
  late final Animation<double> _scale;

  @override
  void initState() {
    super.initState();

    _controller = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 140),
    );

    _scale = Tween<double>(
      begin: 1.0,
      end: 0.96,
    ).animate(
      CurvedAnimation(
        parent: _controller,
        curve: Curves.easeOut,
      ),
    );
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  Future<void> _handleTap() async {
    await _controller.forward();
    await _controller.reverse();

    if (mounted) {
      widget.onTap();
    }
  }

  @override
  Widget build(BuildContext context) {
    return ScaleTransition(
      scale: _scale,
      child: GestureDetector(
        onTap: _handleTap,
        child: Container(
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(28),
            gradient: LinearGradient(
              begin: Alignment.topLeft,
              end: Alignment.bottomRight,
              colors: [
                Colors.white,
                categoryColor.withValues(alpha: .10),
              ],
            ),
            boxShadow: [
              BoxShadow(
                color: Colors.black.withValues(alpha: .08),
                blurRadius: 15,
                offset: const Offset(0, 8),
              ),
            ],
          ),
          child: Padding(
            padding: const EdgeInsets.all(16),
            child: LayoutBuilder(
              builder: (context, constraints) {
                final smallCard = constraints.maxHeight < 270;

                return Column(
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    Hero(
                      tag: widget.category.id,
                      child: Text(
                        widget.category.emoji,
                        style: TextStyle(
                          fontSize: smallCard ? 46 : 56,
                        ),
                      ),
                    ),

                    const SizedBox(height: 10),

                    Text(
                      widget.category.title,
                      textAlign: TextAlign.center,
                      maxLines: 2,
                      overflow: TextOverflow.ellipsis,
                      style: TextStyle(
                        fontWeight: FontWeight.bold,
                        fontSize: smallCard ? 16 : 18,
                      ),
                    ),

                    const SizedBox(height: 6),

                    Text(
                      widget.category.description,
                      textAlign: TextAlign.center,
                      maxLines: 2,
                      overflow: TextOverflow.ellipsis,
                      style: TextStyle(
                        color: Colors.grey.shade700,
                        fontSize: smallCard ? 11 : 12,
                      ),
                    ),

                    const Spacer(),

                    Container(
                      padding: const EdgeInsets.symmetric(
                        horizontal: 14,
                        vertical: 6,
                      ),
                      decoration: BoxDecoration(
                        color: Colors.orange.shade100,
                        borderRadius: BorderRadius.circular(30),
                      ),
                      child: const Text(
                        "Suuraa",
                        style: TextStyle(
                          fontWeight: FontWeight.bold,
                          fontSize: 12,
                        ),
                      ),
                    ),

                    const SizedBox(height: 12),

                    SizedBox(
                      width: double.infinity,
                      height: 42,
                      child: ElevatedButton(
                        style: ElevatedButton.styleFrom(
                          elevation: 0,
                          backgroundColor: categoryColor,
                          foregroundColor: Colors.white,
                          shape: RoundedRectangleBorder(
                            borderRadius:
                                BorderRadius.circular(18),
                          ),
                        ),
                        onPressed: _handleTap,
                        child: const Text(
                          "Halluu Dibi",
                          style: TextStyle(
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ),
                    ),
                  ],
                );
              },
            ),
          ),
        ),
      ),
    );
  }

  Color get categoryColor {
    switch (widget.category.id) {
      case "alphabet":
        return Colors.blue;

      case "numbers":
        return Colors.orange;

      case "animals":
        return Colors.green;

      case "fruits":
        return Colors.red;

      case "vegetables":
        return Colors.teal;

      case "nature":
        return Colors.lightGreen;

      case "home":
        return Colors.brown;

      case "transport":
        return Colors.indigo;

      case "occupation":
        return Colors.deepPurple;

      case "culture":
        return Colors.amber;

      default:
        return Colors.blue;
    }
  }
}