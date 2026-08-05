import 'package:flutter/material.dart';

class CompletionGlow extends StatelessWidget {

  final bool completed;
  final Widget child;


  const CompletionGlow({
    super.key,
    required this.completed,
    required this.child,
  });


  @override
  Widget build(BuildContext context) {

    return AnimatedContainer(

      duration:
      const Duration(milliseconds:600),

      padding:
      completed
          ? const EdgeInsets.all(8)
          : EdgeInsets.zero,


      decoration: BoxDecoration(

        borderRadius:
        BorderRadius.circular(25),


        boxShadow:

        completed ?

        [
          BoxShadow(
            color:
            Colors.greenAccent
                .withValues(alpha: 0.5),

            blurRadius:25,

            spreadRadius:5,
          )
        ]

            :
        [],

      ),

      child: child,
    );
  }
}