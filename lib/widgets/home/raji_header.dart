import 'package:flutter/material.dart';

class RajiHeader extends StatefulWidget {
  final String userName;

  final int xp;
  final int coins;
  final int streak;
  final int level;

  const RajiHeader({
    super.key,
    required this.userName,
    this.xp = 0,
    this.coins = 0,
    this.streak = 0,
    this.level = 1,
  });

  @override
  State<RajiHeader> createState() =>
      _RajiHeaderState();
}

class _RajiHeaderState
    extends State<RajiHeader>
    with SingleTickerProviderStateMixin {

  late final AnimationController _controller;

  @override
  void initState() {

    super.initState();

    _controller = AnimationController(

      vsync: this,

      duration: const Duration(
        milliseconds: 1500,
      ),

    )..repeat(reverse: true);

  }

  @override
  void dispose() {

    _controller.dispose();

    super.dispose();

  }

  @override
  Widget build(BuildContext context) {

    return Padding(

      padding:
      const EdgeInsets.all(20),

      child: Column(

        crossAxisAlignment:
        CrossAxisAlignment.start,

        children: [

          //--------------------------------
          // Top Row
          //--------------------------------

          Row(

            children: [

              Expanded(

                child: Column(

                  crossAxisAlignment:
                  CrossAxisAlignment.start,

                  children: [

                    Text(

                      "🌞 Baga Nagaan Dhufte, ${widget.userName}!",

                      style: const TextStyle(

                        fontSize: 24,

                        fontWeight:
                        FontWeight.bold,

                      ),

                    ),

                    const SizedBox(height: 6),

                    Text(

                      widget.userName,

                      style: const TextStyle(

                        fontSize: 18,

                        color: Colors.black54,

                      ),

                    ),

                  ],

                ),

              ),

              IconButton(

                onPressed: () {},

                icon: const Icon(
                  Icons.notifications,
                ),

              ),

              CircleAvatar(

                radius: 24,

                backgroundColor:
                Colors.orange.shade200,

                child: const Icon(
                  Icons.person,
                ),

              )

            ],

          ),

          const SizedBox(height: 20),

          //--------------------------------
          // Raji Card
          //--------------------------------

          Container(

            padding:
            const EdgeInsets.all(18),

            decoration: BoxDecoration(

              color: Colors.white,

              borderRadius:
              BorderRadius.circular(25),

              boxShadow: [

                BoxShadow(

                  color: Colors.black.withValues(alpha:.08),

                  blurRadius: 10,

                  offset:
                  const Offset(0,5),

                )

              ],

            ),

            child: Row(

              children: [

                AnimatedBuilder(

                  animation: _controller,

                  builder: (_, child) {

                    return Transform.translate(

                      offset: Offset(
                        0,
                        -5 * _controller.value,
                      ),

                      child: child,

                    );

                  },

                  child: Container(

                    width: 80,

                    height: 80,

                    decoration: BoxDecoration(

                      color:
                      Colors.orange.shade100,

                      shape: BoxShape.circle,

                    ),

                    child: const Center(

                      child: Text(

                        "😊",

                        style: TextStyle(
                          fontSize: 45,
                        ),

                      ),

                    ),

                  ),

                ),

                const SizedBox(width: 20),

                Expanded(

                  child: Column(

                    crossAxisAlignment:
                    CrossAxisAlignment.start,

                    children: const [

                      Text(

                        "Raji",

                        style: TextStyle(

                          fontSize: 22,

                          fontWeight:
                          FontWeight.bold,

                        ),

                      ),

                      SizedBox(height: 8),

                      Text(

                        "Har'a maal baranna?",

                        style: TextStyle(

                          fontSize: 16,

                        ),

                      ),

                    ],

                  ),

                )

              ],

            ),

          ),

          const SizedBox(height: 18),

          //--------------------------------
          // Statistics
          //--------------------------------

          Row(

            children: [

              Expanded(

                child: _stat(

                  "🔥",

                  widget.streak.toString(),

                  "Guyyaa",

                ),

              ),

              const SizedBox(width: 10),

              Expanded(

                child: _stat(

                  "⭐",

                  widget.xp.toString(),

                  "XP",

                ),

              ),

            ],

          ),

          const SizedBox(height: 10),

          Row(

            children: [

              Expanded(

                child: _stat(

                  "🪙",

                  widget.coins.toString(),

                  "Coins",

                ),

              ),

              const SizedBox(width: 10),

              Expanded(

                child: _stat(

                  "🏆",

                  widget.level.toString(),

                  "Level",

                ),

              ),

            ],

          ),

        ],

      ),

    );

  }

  Widget _stat(
      String emoji,
      String value,
      String label,
      ) {

    return Container(

      padding:
      const EdgeInsets.symmetric(
        vertical: 12,
      ),

      decoration: BoxDecoration(

        color: Colors.white,

        borderRadius:
        BorderRadius.circular(20),

      ),

      child: Column(

        children: [

          Text(
            emoji,
            style: const TextStyle(
              fontSize: 24,
            ),
          ),

          const SizedBox(height: 5),

          Text(

            value,

            style: const TextStyle(

              fontWeight:
              FontWeight.bold,

              fontSize: 18,

            ),

          ),

          Text(label),

        ],

      ),

    );

  }

}