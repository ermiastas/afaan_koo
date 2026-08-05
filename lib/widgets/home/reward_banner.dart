import 'package:flutter/material.dart';

class RewardBanner extends StatelessWidget {
  final int stars;
  final int coins;
  final int badges;
  final VoidCallback? onTap;

  const RewardBanner({
    super.key,
    required this.stars,
    required this.coins,
    required this.badges,
    this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(
        horizontal: 20,
        vertical: 12,
      ),
      child: InkWell(
        borderRadius: BorderRadius.circular(28),
        onTap: onTap,
        child: Container(
          padding: const EdgeInsets.all(20),
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(28),
            gradient: const LinearGradient(
              colors: [
                Color(0xff8E24AA),
                Color(0xff5E35B1),
              ],
            ),
            boxShadow: [
              BoxShadow(
                color: Colors.deepPurple.withValues(alpha:.25),
                blurRadius: 18,
                offset: const Offset(0, 8),
              ),
            ],
          ),
          child: Column(
            children: [
              const Row(
                children: [
                  Icon(
                    Icons.workspace_premium,
                    color: Colors.white,
                    size: 30,
                  ),
                  SizedBox(width: 10),
                  Expanded(
                    child: Text(
                      "Milkaa'ina Kee",
                      style: TextStyle(
                        color: Colors.white,
                        fontSize: 22,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ),
                  Icon(
                    Icons.arrow_forward_ios,
                    color: Colors.white,
                    size: 18,
                  ),
                ],
              ),
              const SizedBox(height: 20),
              Row(
                children: [
                  Expanded(
                    child: _rewardItem(
                      emoji: "⭐",
                      value: stars.toString(),
                      label: "Stars",
                    ),
                  ),
                  Expanded(
                    child: _rewardItem(
                      emoji: "🪙",
                      value: coins.toString(),
                      label: "Coins",
                    ),
                  ),
                  Expanded(
                    child: _rewardItem(
                      emoji: "🏅",
                      value: badges.toString(),
                      label: "Badges",
                    ),
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _rewardItem({
    required String emoji,
    required String value,
    required String label,
  }) {
    return Column(
      children: [
        Text(
          emoji,
          style: const TextStyle(fontSize: 30),
        ),
        const SizedBox(height: 8),
        Text(
          value,
          style: const TextStyle(
            color: Colors.white,
            fontWeight: FontWeight.bold,
            fontSize: 22,
          ),
        ),
        const SizedBox(height: 4),
        Text(
          label,
          style: const TextStyle(
            color: Colors.white70,
          ),
        ),
      ],
    );
  }
}