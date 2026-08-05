import 'package:flutter/material.dart';

class CountingImageWidget extends StatelessWidget {
  final int count;

  /// Asset image
  final String image;

  final double size;

  const CountingImageWidget({
    super.key,
    required this.count,
    required this.image,
    this.size = 45,
  });

  @override
  Widget build(BuildContext context) {

    if (count <= 0) {
      return const SizedBox();
    }

    final displayCount = count > 20 ? 20 : count;

    return Column(
      children: [

        Wrap(
          alignment: WrapAlignment.center,
          spacing: 10,
          runSpacing: 10,

          children: List.generate(
            displayCount,
            (_) => Image.asset(
              image,
              width: size,
              height: size,
            ),
          ),
        ),

        if (count > 20)

          Padding(
            padding: const EdgeInsets.only(top: 10),

            child: Text(
              "... fi ${count - 20} dabalataa",
              style: const TextStyle(
                fontWeight: FontWeight.bold,
              ),
            ),
          ),

      ],
    );
  }
}