import 'package:flutter/material.dart';

class HandwritingNavigation extends StatelessWidget {
  final bool canGoBack;
  final bool canGoNext;
  final bool isLast;

  final VoidCallback onBack;
  final VoidCallback onNext;

  const HandwritingNavigation({
    super.key,
    required this.canGoBack,
    required this.canGoNext,
    required this.isLast,
    required this.onBack,
    required this.onNext,
  });

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(16),
      child: Row(
        children: [
          Expanded(
            child: FilledButton.icon(
              onPressed: canGoBack ? onBack : null,
              icon: const Icon(Icons.arrow_back),
              label: const Text("Duubatti"),
            ),
          ),
          const SizedBox(width: 12),
          Expanded(
            child: FilledButton.icon(
              onPressed: canGoNext ? onNext : null,
              icon: Icon(
                isLast
                    ? Icons.check_circle
                    : Icons.arrow_forward,
              ),
              label: Text(
                isLast ? "Xumuri" : "Itti Fufi",
              ),
            ),
          ),
        ],
      ),
    );
  }
}