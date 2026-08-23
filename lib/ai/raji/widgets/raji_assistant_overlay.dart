import 'package:flutter/material.dart';

import 'raji_cartoon.dart';
import 'raji_chat_widget.dart';

/// Raji assistant launcher displayed above the current app content.
class RajiAssistantOverlay extends StatelessWidget {
  const RajiAssistantOverlay({
    super.key,
    required this.child,
  });

  final Widget child;

  @override
  Widget build(BuildContext context) {
    final media = MediaQuery.of(context);

    return SizedBox.expand(
      child: Stack(
        fit: StackFit.expand,
        children: [
          child,

          Positioned(
            right: 16,
            bottom: media.padding.bottom + 16,
            child: SafeArea(
              child: Semantics(
                button: true,
                label: 'Open Raji learning assistant',
                child: Material(
                  color: Colors.transparent,
                  child: InkWell(
                    onTap: () => _openChat(context),
                    borderRadius: BorderRadius.circular(38),
                    child: Ink(
                      width: 72,
                      height: 72,
                      decoration: BoxDecoration(
                        gradient: const LinearGradient(
                          colors: [
                            Color(0xffF9E7C5),
                            Color(0xffE5DEFF),
                          ],
                        ),
                        borderRadius: BorderRadius.circular(36),
                        border: Border.all(
                          color: Colors.white,
                          width: 3,
                        ),
                        boxShadow: const [
                          BoxShadow(
                            color: Color(0x33000000),
                            blurRadius: 14,
                            offset: Offset(0, 6),
                          ),
                        ],
                      ),
                      child: const RajiCartoon(
                        size: 62,
                      ),
                    ),
                  ),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }

  void _openChat(BuildContext context) {
    final navigator = Navigator.maybeOf(context);

    if (navigator == null) {
      debugPrint(
        'RajiAssistantOverlay: No Navigator found in context.',
      );
      return;
    }

    final height = MediaQuery.sizeOf(context).height * 0.78;

    showModalBottomSheet<void>(
      context: context,
      isScrollControlled: true,
      useSafeArea: true,
      backgroundColor: Colors.transparent,
      builder: (sheetContext) {
        return Padding(
          padding: const EdgeInsets.fromLTRB(
            12,
            0,
            12,
            12,
          ),
          child: RajiChatWidget(
            height: height,
            compact: true,
          ),
        );
      },
    );
  }
}