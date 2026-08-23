import 'dart:math';

import 'package:flutter/material.dart';

import '../providers/profile_provider.dart';
import '../services/raji_audio_service.dart';
import 'package:provider/provider.dart';
import '../ai/raji/widgets/raji_cartoon.dart';

class RajiAssistant extends StatefulWidget {

  final String message;

  final bool celebrate;

  final bool wave;

  final VoidCallback? onTap;

  const RajiAssistant({

    super.key,

    required this.message,

    this.celebrate = false,

    this.wave = false,

    this.onTap,

  });

  @override
  State<RajiAssistant> createState() =>
      _RajiAssistantState();
}

class _RajiAssistantState
    extends State<RajiAssistant>
    with TickerProviderStateMixin {

  late AnimationController _bounce;

  late AnimationController _float;

  @override
  void initState() {

    super.initState();

    _bounce = AnimationController(

      vsync: this,

      duration: const Duration(milliseconds: 700),

    );

    _float = AnimationController(

      vsync: this,

      duration: const Duration(seconds: 2),

    )..repeat(reverse: true);

    if(widget.celebrate){

      _bounce.repeat(reverse: true);

    }

  }

  @override
  void dispose() {

    _bounce.dispose();

    _float.dispose();

    super.dispose();

  }

  @override
  Widget build(BuildContext context) {

    final profile =
        context.watch<ProfileProvider>();

    return GestureDetector(

      onTap: () async {

        await RajiAudioService.welcome();

        widget.onTap?.call();

      },

      child: AnimatedBuilder(

        animation: Listenable.merge([

          _bounce,

          _float,

        ]),

        builder: (_,__) {

          final offset =
              sin(_float.value * pi * 2) * 6;

          return Transform.translate(

            offset: Offset(0, offset),

            child: Column(

              children: [

                Container(

                  padding: const EdgeInsets.all(12),

                  decoration: BoxDecoration(

                    color: Colors.white,

                    borderRadius:
                        BorderRadius.circular(20),

                    boxShadow: const [

                      BoxShadow(

                        blurRadius: 8,

                        color: Colors.black12,

                      )

                    ],

                  ),

                  child: Text(

                    "${profile.name}, ${widget.message}",

                    textAlign: TextAlign.center,

                    style: const TextStyle(

                      fontSize: 16,

                      fontWeight: FontWeight.bold,

                    ),

                  ),

                ),

                const SizedBox(height: 10),

                Transform.scale(

                  scale: 1 + (_bounce.value * .12),

                  child: const RajiCartoon(size: 90),

                ),

              ],

            ),

          );

        },

      ),

    );

  }

}
