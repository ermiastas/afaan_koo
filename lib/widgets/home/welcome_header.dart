import 'package:flutter/material.dart';

class WelcomeHeader extends StatelessWidget {
  final String userName;
  final int coins;
  final int streak;
  final int level;
  final int currentXP;
  final int nextLevelXP;
  final String? profileImage;

  const WelcomeHeader({
    super.key,
    required this.userName,
    required this.coins,
    required this.streak,
    required this.level,
    required this.currentXP,
    required this.nextLevelXP,
    this.profileImage,
  });

  @override
  Widget build(BuildContext context) {
    final progress = currentXP / nextLevelXP;

    return Padding(
      padding: const EdgeInsets.fromLTRB(20, 20, 20, 10),
      child: Column(
        children: [

          /// Coins & Streak
          Row(
            children: [

              Expanded(
                child: _TopBadge(
                  color: Colors.amber,
                  icon: Icons.monetization_on_rounded,
                  title: "$coins",
                  subtitle: "Qubannoo",
                ),
              ),

              const SizedBox(width: 12),

              Expanded(
                child: _TopBadge(
                  color: Colors.deepOrange,
                  icon: Icons.local_fire_department,
                  title: "$streak",
                  subtitle: "Guyyaa",
                ),
              ),
            ],
          ),

          const SizedBox(height: 25),

          Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [

              /// Avatar
              Column(
                children: [

                  Stack(
                    alignment: Alignment.center,
                    children: [

                      Container(
                        width: 95,
                        height: 95,
                        decoration: const BoxDecoration(
                          shape: BoxShape.circle,
                          gradient: SweepGradient(
                            colors: [
                              Colors.red,
                              Colors.orange,
                              Colors.yellow,
                              Colors.green,
                              Colors.blue,
                              Colors.purple,
                              Colors.red,
                            ],
                          ),
                        ),
                      ),

                      Container(
                        width: 88,
                        height: 88,
                        decoration: BoxDecoration(
                          color: Colors.white,
                          shape: BoxShape.circle,
                          image: profileImage != null
                              ? DecorationImage(
                                  image: AssetImage(profileImage!),
                                  fit: BoxFit.cover,
                                )
                              : null,
                        ),
                        child: profileImage == null
                            ? const Icon(
                                Icons.person,
                                size: 45,
                                color: Colors.grey,
                              )
                            : null,
                      ),
                    ],
                  ),

                  const SizedBox(height: 10),

                  Text(
                    userName,
                    style: const TextStyle(
                      fontWeight: FontWeight.bold,
                      fontSize: 18,
                    ),
                  ),
                ],
              ),

              const SizedBox(width: 18),

              /// XP Card
              Expanded(
                child: Container(
                  padding: const EdgeInsets.all(18),
                  decoration: BoxDecoration(
                    color: Colors.white.withValues(alpha: .92),
                    borderRadius: BorderRadius.circular(25),
                    boxShadow: const [
                      BoxShadow(
                        blurRadius: 15,
                        color: Colors.black12,
                        offset: Offset(0, 5),
                      ),
                    ],
                  ),

                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [

                      Text(
                        "Akkam! 👋",
                        style: Theme.of(context)
                            .textTheme
                            .headlineSmall
                            ?.copyWith(
                              fontWeight: FontWeight.bold,
                            ),
                      ),

                      const SizedBox(height: 6),

                      const Text(
                        "Mee haa barannu! ⭐",
                        style: TextStyle(
                          fontSize: 18,
                        ),
                      ),

                      const SizedBox(height: 18),

                      Text(
                        "Sadarkaa $level",
                        style: const TextStyle(
                          fontWeight: FontWeight.bold,
                        ),
                      ),

                      const SizedBox(height: 10),

                      ClipRRect(
                        borderRadius: BorderRadius.circular(20),
                        child: LinearProgressIndicator(
                          value: progress,
                          minHeight: 12,
                          backgroundColor: Colors.grey.shade300,
                          color: Colors.green,
                        ),
                      ),

                      const SizedBox(height: 8),

                      Text(
                        "$currentXP / $nextLevelXP XP",
                      ),
                    ],
                  ),
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }
}

class _TopBadge extends StatelessWidget {

  final Color color;
  final IconData icon;
  final String title;
  final String subtitle;

  const _TopBadge({
    required this.color,
    required this.icon,
    required this.title,
    required this.subtitle,
  });

  @override
  Widget build(BuildContext context) {

    return Container(
      padding: const EdgeInsets.symmetric(
        horizontal: 16,
        vertical: 12,
      ),
      decoration: BoxDecoration(
        color: Colors.white.withValues(alpha: .92),
        borderRadius: BorderRadius.circular(25),
      ),
      child: Row(
        children: [

          CircleAvatar(
            backgroundColor: color,
            child: Icon(
              icon,
              color: Colors.white,
            ),
          ),

          const SizedBox(width: 10),

          Column(
            crossAxisAlignment:
                CrossAxisAlignment.start,
            children: [

              Text(
                title,
                style: const TextStyle(
                  fontWeight: FontWeight.bold,
                ),
              ),

              Text(subtitle),
            ],
          ),
        ],
      ),
    );
  }
}