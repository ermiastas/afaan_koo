import 'package:flutter/material.dart';

class KidLessonCard extends StatefulWidget {
  final String title;
  final String? subtitle;

  /// Use either icon or image.
  final IconData? icon;
  final String? image;

  final Color color;

  /// 0.0 - 1.0
  final double? progress;

  final bool completed;

  final VoidCallback onTap;

  const KidLessonCard({
    super.key,
    required this.title,
    required this.color,
    required this.onTap,
    this.subtitle,
    this.icon,
    this.image,
    this.progress,
    this.completed = false,
  });

  @override
  State<KidLessonCard> createState() => _KidLessonCardState();
}

class _KidLessonCardState extends State<KidLessonCard> {
  bool _pressed = false;

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTapDown: (_) {
        setState(() => _pressed = true);
      },
      onTapCancel: () {
        setState(() => _pressed = false);
      },
      onTapUp: (_) {
        setState(() => _pressed = false);
        widget.onTap();
      },
      child: AnimatedScale(
        duration: const Duration(milliseconds: 120),
        scale: _pressed ? 0.96 : 1,
        child: AnimatedContainer(
          duration: const Duration(milliseconds: 250),
          padding: const EdgeInsets.all(18),
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(30),
            gradient: LinearGradient(
              colors: [
                widget.color,
                widget.color.withValues(alpha:0.75),
              ],
              begin: Alignment.topLeft,
              end: Alignment.bottomRight,
            ),
            boxShadow: [
              BoxShadow(
                color: widget.color.withValues(alpha:0.30),
                blurRadius: 18,
                offset: const Offset(0, 8),
              ),
            ],
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [

              Align(
                alignment: Alignment.topRight,
                child: widget.completed
                    ? const Icon(
                        Icons.verified_rounded,
                        color: Colors.white,
                      )
                    : const SizedBox(height: 24),
              ),

              Expanded(
                child: Center(
                  child: widget.image != null
                      ? Image.asset(
                          widget.image!,
                          height: 80,
                          fit: BoxFit.contain,
                          errorBuilder: (_, __, ___) {
                            return Icon(
                              widget.icon ?? Icons.school,
                              color: Colors.white,
                              size: 70,
                            );
                          },
                        )
                      : Icon(
                          widget.icon ?? Icons.school,
                          color: Colors.white,
                          size: 70,
                        ),
                ),
              ),

              Text(
                widget.title,
                maxLines: 2,
                overflow: TextOverflow.ellipsis,
                style: const TextStyle(
                  color: Colors.white,
                  fontSize: 22,
                  fontWeight: FontWeight.bold,
                ),
              ),

              if (widget.subtitle != null) ...[
                const SizedBox(height: 4),
                Text(
                  widget.subtitle!,
                  style: const TextStyle(
                    color: Colors.white70,
                    fontSize: 15,
                  ),
                ),
              ],

              if (widget.progress != null) ...[
                const SizedBox(height: 14),

                ClipRRect(
                  borderRadius: BorderRadius.circular(20),
                  child: LinearProgressIndicator(
                    value: widget.progress,
                    minHeight: 8,
                    backgroundColor: Colors.white24,
                    valueColor:
                        const AlwaysStoppedAnimation<Color>(Colors.white),
                  ),
                ),

                const SizedBox(height: 6),

                Align(
                  alignment: Alignment.centerRight,
                  child: Text(
                    "${(widget.progress! * 100).round()}%",
                    style: const TextStyle(
                      color: Colors.white,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ),
              ],
            ],
          ),
        ),
      ),
    );
  }
}