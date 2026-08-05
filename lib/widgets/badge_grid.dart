import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../providers/reward_provider.dart';
import 'badge_card.dart';



class BadgeGrid extends StatelessWidget {


  const BadgeGrid({
    super.key,
  });




  @override
  Widget build(BuildContext context) {


    final reward =
        context.watch<RewardProvider>();




    return GridView.builder(



      shrinkWrap:true,



      physics:
      const NeverScrollableScrollPhysics(),




      itemCount:
      reward.badges.length,




      gridDelegate:

      const SliverGridDelegateWithFixedCrossAxisCount(

        crossAxisCount:2,

        childAspectRatio:.85,

        crossAxisSpacing:15,

        mainAxisSpacing:15,

      ),




      itemBuilder:(context,index){



        final badge =
            reward.badges[index];



        final unlocked =
            reward.unlockedBadges
                .contains(
                  badge.id,
                );




        return BadgeCard(

          badge:badge,

          unlocked:unlocked,

        );


      },

    );


  }


}