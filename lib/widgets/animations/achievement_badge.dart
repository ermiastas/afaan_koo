import 'package:flutter/material.dart';

class AchievementBadge extends StatelessWidget {

  final bool unlocked;


  const AchievementBadge({
    super.key,
    required this.unlocked,
  });


  @override
  Widget build(BuildContext context) {


    if(!unlocked){
      return const SizedBox();
    }


    return Container(

      padding:
      const EdgeInsets.all(8),

      decoration: BoxDecoration(

        shape: BoxShape.circle,

        gradient:
        const LinearGradient(
          colors:[
            Colors.yellow,
            Colors.orange,
          ],
        ),

        boxShadow:[
          BoxShadow(
            color:
            Colors.orange.withValues(alpha: 0.5),
            blurRadius:15,
          )
        ],
      ),


      child:
      const Icon(
        Icons.emoji_events,
        color:Colors.white,
        size:28,
      ),
    );
  }
}