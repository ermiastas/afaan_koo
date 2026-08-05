import 'package:flutter/material.dart';

import '../services/audio_service.dart';

/// A consistent, accessible replay button for lesson pronunciation and stories.
class AudioButton extends StatelessWidget {
  const AudioButton({
    super.key,
    required this.audioPath,
    this.tooltip = 'Play audio',
    this.iconSize = 24,
  });

  final String audioPath;
  final String tooltip;
  final double iconSize;

  @override
  Widget build(BuildContext context) {
    return Semantics(
      button: true,
      label: tooltip,
      child: IconButton.filledTonal(
        tooltip: tooltip,
        iconSize: iconSize,
        constraints: const BoxConstraints(minWidth: 48, minHeight: 48),
        onPressed: () => AudioService().playSound(audioPath),
        icon: const Icon(Icons.volume_up_rounded),
      ),
    );
  }
}
