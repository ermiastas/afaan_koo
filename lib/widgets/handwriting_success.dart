import 'package:flutter/material.dart';

class HandwritingSuccess extends StatelessWidget {
  final bool visible;

  const HandwritingSuccess({
    super.key,
    required this.visible,
  });

  @override
  Widget build(BuildContext context) {
    return AnimatedSwitcher(
      duration: const Duration(milliseconds: 400),
      child: visible
          ? Container(
              key: const ValueKey("success"),
              margin: const EdgeInsets.symmetric(
                horizontal: 20,
                vertical: 8,
              ),
              padding: const EdgeInsets.all(14),
              decoration: BoxDecoration(
                color: Colors.green.shade100,
                borderRadius: BorderRadius.circular(18),
              ),
              child: const Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Icon(
                    Icons.celebration,
                    color: Colors.green,
                  ),
                  SizedBox(width: 10),
                  Text(
                    "🎉 Baay'ee gaarii!",
                    style: TextStyle(
                      fontSize: 22,
                      fontWeight: FontWeight.bold,
                      color: Colors.green,
                    ),
                  ),
                ],
              ),
            )
          : const SizedBox.shrink(),
    );
  }
}