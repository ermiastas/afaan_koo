import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../providers/progress_provider.dart';
import '../providers/reward_provider.dart';
import '../../widgets/badge_grid.dart';



class ParentDashboardScreen extends StatelessWidget {


  const ParentDashboardScreen({
    super.key,
  });



  @override
  Widget build(BuildContext context) {


    final progress =
        context.watch<ProgressProvider>();


    final rewards =
        context.watch<RewardProvider>();



    return Scaffold(


      backgroundColor:
          const Color(0xffF7FBFF),



      appBar: AppBar(

        title:
            const Text(
              "Daashboordii Maatii",
            ),

        centerTitle:true,

      ),



      body:
      SingleChildScrollView(


        padding:
        const EdgeInsets.all(16),



        child: Column(


          children:[



            _childCard(),



            const SizedBox(height:20),



            _progressSummary(

              progress,

            ),



            const SizedBox(height:20),



            _rewardSummary(

              rewards,

            ),

          const SizedBox(
  height:25,
),


const Align(

alignment:
Alignment.centerLeft,

child:

Text(

"Badhaasa koo 🏅",

style:
TextStyle(

fontSize:22,

fontWeight:
FontWeight.bold,

),

),

),


const SizedBox(
height:15,
),


const BadgeGrid(),

          ],


        ),

      ),

    );

  }








  Widget _childCard(){


    return Container(


      padding:
      const EdgeInsets.all(20),



      decoration:
      BoxDecoration(


        color:
        Colors.white,


        borderRadius:
        BorderRadius.circular(25),



      ),



      child: const Row(


        children:[


          CircleAvatar(

            radius:35,

            child:
            Icon(

              Icons.child_care,

              size:45,

            ),

          ),



          SizedBox(width:20),



          Column(

            crossAxisAlignment:
            CrossAxisAlignment.start,


            children:[


              Text(

                "Barataa Afaan Koo",

                style:
                TextStyle(

                  fontSize:20,

                  fontWeight:
                  FontWeight.bold,

                ),

              ),


              Text(
                "Guddina barnootaa",
              ),


            ],

          )


        ],


      ),


    );


  }









  Widget _progressSummary(

      ProgressProvider progress,

      ){


    return _dashboardCard(


      title:
      "📚 Guddina Barnootaa",



      child:
      Column(

        children:[



          LinearProgressIndicator(

            value:
            progress.completionPercentage,

            minHeight:12,

            borderRadius:
            BorderRadius.circular(10),

          ),



          const SizedBox(height:15),



          Row(

            mainAxisAlignment:
            MainAxisAlignment.spaceAround,


            children:[


              _stat(

                "Barnoota",

                "${progress.completedCount}",

              ),



              _stat(

                "Daqiiqaa",

                "${progress.learningMinutes}",

              ),



              _stat(

                "Xumura",

                "${(progress.completionPercentage*100).toInt()}%",

              ),


            ],

          )

        ],

      ),

    );


  }









  Widget _rewardSummary(

      RewardProvider rewards,

      ){


    return _dashboardCard(


      title:
      "🏆 Badhaasa",



      child:
      Row(

        mainAxisAlignment:
        MainAxisAlignment.spaceAround,


        children:[


          _stat(

            "⭐ XP",

            "${rewards.xp}",

          ),



          _stat(

            "🪙 Saantima",

            "${rewards.coins}",

          ),



          _stat(

            "🏅 Sadarkaa",

            "${rewards.level}",

          ),


        ],

      ),

    );


  }









  Widget _dashboardCard({

    required String title,

    required Widget child,

  }){


    return Container(


      padding:
      const EdgeInsets.all(20),


      decoration:
      BoxDecoration(

        color:
        Colors.white,


        borderRadius:
        BorderRadius.circular(25),


        boxShadow:[

          BoxShadow(

            color:
            Colors.black.withValues(alpha:.08),

            blurRadius:10,

          )

        ],


      ),



      child:Column(


        crossAxisAlignment:
        CrossAxisAlignment.start,


        children:[


          Text(

            title,

            style:
            const TextStyle(

              fontSize:20,

              fontWeight:
              FontWeight.bold,

            ),

          ),



          const SizedBox(height:15),



          child,


        ],

      ),


    );


  }







  Widget _stat(

      String title,

      String value,

      ){


    return Column(


      children:[


        Text(

          value,

          style:
          const TextStyle(

            fontSize:22,

            fontWeight:
            FontWeight.bold,

          ),

        ),



        Text(title),


      ],


    );


  }



}