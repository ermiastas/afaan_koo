import 'package:flutter/material.dart';

import '../../models/paint_mode.dart';

class PaintToolbar extends StatelessWidget {
  const PaintToolbar({
    super.key,
    required this.selectedMode,
    required this.brushSize,
    required this.onBrushChanged,
    required this.onModeChanged,
    required this.onUndo,
    required this.onRedo,
    required this.onClear,
    required this.onSave,
    required this.onGallery,
    this.canUndo = false,
    this.canRedo = false,
    this.isSaving = false,
  });

  final PaintMode selectedMode;
  final double brushSize;
  final ValueChanged<double> onBrushChanged;
  final ValueChanged<PaintMode> onModeChanged;
  final VoidCallback onUndo;
  final VoidCallback onRedo;
  final VoidCallback onClear;
  final VoidCallback onSave;
  final VoidCallback onGallery;
  final bool canUndo;
  final bool canRedo;
  final bool isSaving;

  @override
  Widget build(BuildContext context) {
    return Card(
      child: Padding(
        padding: const EdgeInsets.all(12),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            SizedBox(
              height: 52,
              child: ListView(
                scrollDirection: Axis.horizontal,
                children: [
                  _toolButton(Icons.brush_rounded, 'Brush', PaintMode.brush),
                  _toolButton(Icons.edit_rounded, 'Pencil', PaintMode.pencil),
                  _toolButton(Icons.border_color_rounded, 'Marker', PaintMode.marker),
                  _toolButton(Icons.auto_fix_high_rounded, 'Glitter', PaintMode.glitter),
                  _toolButton(Icons.gradient_rounded, 'Rainbow', PaintMode.rainbow),
                  _toolButton(Icons.cleaning_services_rounded, 'Eraser', PaintMode.eraser),
                  _toolButton(Icons.emoji_emotions_outlined, 'Sticker', PaintMode.sticker),
                  _toolButton(Icons.format_color_fill_rounded, 'Fill canvas', PaintMode.bucket),
                ],
              ),
            ),
            Row(
              children: [
                const Icon(Icons.line_weight_rounded),
                Expanded(
                  child: Slider(
                    value: brushSize,
                    min: 2,
                    max: 50,
                    label: brushSize.round().toString(),
                    onChanged: onBrushChanged,
                  ),
                ),
              ],
            ),
            Wrap(
              alignment: WrapAlignment.spaceEvenly,
              spacing: 4,
              runSpacing: 4,
              children: [
                _actionButton(Icons.undo_rounded, 'Undo', canUndo ? onUndo : null),
                _actionButton(Icons.redo_rounded, 'Redo', canRedo ? onRedo : null),
                _actionButton(Icons.delete_outline_rounded, 'Clear canvas', onClear),
                _actionButton(
                  isSaving ? Icons.hourglass_top_rounded : Icons.save_alt_rounded,
                  isSaving ? 'Saving drawing' : 'Save drawing',
                  isSaving ? null : onSave,
                ),
                _actionButton(Icons.photo_library_outlined, 'Open gallery', onGallery),
              ],
            ),
          ],
        ),
      ),
    );
  }

  Widget _toolButton(IconData icon, String label, PaintMode mode) {
    final active = selectedMode == mode;
    return Semantics(
      button: true,
      selected: active,
      label: label,
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 2),
        child: IconButton.filledTonal(
          tooltip: label,
          onPressed: () => onModeChanged(mode),
          icon: Icon(icon),
          color: active ? Colors.white : null,
          style: IconButton.styleFrom(
            backgroundColor: active ? Colors.orange.shade700 : null,
          ),
        ),
      ),
    );
  }

  Widget _actionButton(IconData icon, String label, VoidCallback? onPressed) {
    return Semantics(
      button: true,
      label: label,
      child: IconButton(
        tooltip: label,
        constraints: const BoxConstraints(minHeight: 48, minWidth: 48),
        onPressed: onPressed,
        icon: Icon(icon),
      ),
    );
  }
}
