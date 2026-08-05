import 'package:flutter/material.dart';

class HandwritingToolbar extends StatelessWidget {
  final VoidCallback onReplay;
  final VoidCallback onUndo;
  final VoidCallback onClear;

  const HandwritingToolbar({
    super.key,
    required this.onReplay,
    required this.onUndo,
    required this.onClear,
  });

  @override
  Widget build(BuildContext context) {
    return Card(
      elevation: 2,
      margin: const EdgeInsets.symmetric(
        horizontal: 12,
        vertical: 8,
      ),
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(18),
      ),
      child: Padding(
        padding: const EdgeInsets.symmetric(
          horizontal: 16,
          vertical: 10,
        ),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
          children: [
            _toolButton(
              icon: Icons.replay,
              label: "Irra Deebi'i",
              color: Colors.orange,
              onTap: onReplay,
            ),
            _toolButton(
              icon: Icons.undo,
              label: "Duubatti",
              color: Colors.blue,
              onTap: onUndo,
            ),
            _toolButton(
              icon: Icons.delete_outline,
              label: "Haqi",
              color: Colors.red,
              onTap: onClear,
            ),
          ],
        ),
      ),
    );
  }

  Widget _toolButton({
    required IconData icon,
    required String label,
    required Color color,
    required VoidCallback onTap,
  }) {
    return FilledButton.icon(
      onPressed: onTap,
      icon: Icon(icon),
      label: Text(label),
      style: FilledButton.styleFrom(
        backgroundColor: color,
        foregroundColor: Colors.white,
      ),
    );
  }
}