import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../../providers/progress_provider.dart';
import '../../providers/reward_provider.dart';
import '../../utils/responsive.dart';



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



      appBar: AppBar(

        title:
        const Text(
          "Maatii Koo 👨‍👩‍👧",
        ),

        centerTitle:true,

      ),






      body:

      SingleChildScrollView(


        padding:
        EdgeInsets.all(Responsive.pagePadding(context)),



        child:Column(



          children:[





            _welcomeCard(),






            const SizedBox(
              height:20,
            ),





            _statisticsGrid(

              context,

              progress,

              rewards,

            ),






            const SizedBox(
              height:25,
            ),





            _progressCard(

              progress,

            ),






            const SizedBox(
              height:25,
            ),





            _rewardCard(

              rewards,

            ),





          ],



        ),



      ),



    );


  }









  Widget _welcomeCard(){


    return Container(


      width:
      double.infinity,



      padding:
      const EdgeInsets.all(20),



      decoration:
      BoxDecoration(


        gradient:
        const LinearGradient(

          colors:[

            Color(0xff6DD5FA),

            Color(0xff2980B9),

          ],

        ),



        borderRadius:
        BorderRadius.circular(25),


      ),




      child:

      const Column(


        crossAxisAlignment:
        CrossAxisAlignment.start,



        children:[



          Text(

            "Baga nagaan dhuftan 👋",

            style:
            TextStyle(

              color:Colors.white,

              fontSize:22,

              fontWeight:
              FontWeight.bold,

            ),

          ),




          SizedBox(height:8),





          Text(

            "Guddina barnootaa mucaa keessanii hordofi.",

            style:
            TextStyle(

              color:Colors.white,

              fontSize:15,

            ),

          ),




        ],



      ),



    );


  }









  Widget _statisticsGrid(

      BuildContext context,

      ProgressProvider progress,

      RewardProvider rewards,

      ){



    return GridView.count(


      shrinkWrap:true,


      physics:
      const NeverScrollableScrollPhysics(),



      crossAxisCount:Responsive.homeColumns(context, max: 4),



      crossAxisSpacing:15,



      mainAxisSpacing:15,



      children:[




        _statCard(

          "📚",

          "Barnoota",

          "${progress.completedCount}",

          Colors.blue,

        ),





        _statCard(

          "⏱",

          "Yeroo",

          "${progress.learningMinutes} min",

          Colors.green,

        ),





        _statCard(

          "⭐",

          "XP",

          "${rewards.xp}",

          Colors.orange,

        ),





        _statCard(

          "🏆",

          "Tapha",

          "${rewards.gamesCompleted}",

          Colors.purple,

        ),




      ],


    );


  }









  Widget _statCard(

      String emoji,

      String title,

      String value,

      Color color,

      ){



    return Container(



      decoration:
      BoxDecoration(


        color:
        Colors.white,


        borderRadius:
        BorderRadius.circular(20),



        boxShadow:[


          BoxShadow(

            color:
            Colors.grey.shade300,

            blurRadius:8,

          )


        ],


      ),





      child:
      Column(


        mainAxisAlignment:
        MainAxisAlignment.center,



        children:[



          Text(

            emoji,

            style:
            const TextStyle(

              fontSize:35,

            ),

          ),




          Text(

            value,

            style:
            TextStyle(

              color:color,

              fontSize:22,

              fontWeight:
              FontWeight.bold,

            ),

          ),




          Text(title),




        ],



      ),



    );


  }









  Widget _progressCard(

      ProgressProvider progress,

      ){



    final percent =
        progress.completionPercentage;



    return Card(



      child:
      Padding(


        padding:
        const EdgeInsets.all(20),



        child:
        Column(


          crossAxisAlignment:
          CrossAxisAlignment.start,



          children:[



            const Text(

              "Adeemsa Barnootaa",

              style:
              TextStyle(

                fontSize:20,

                fontWeight:
                FontWeight.bold,

              ),

            ),




            const SizedBox(
              height:15,
            ),





            LinearProgressIndicator(

              value:
              percent,

              minHeight:12,


            ),




            const SizedBox(
              height:10,
            ),




            Text(

              "${(percent*100).toStringAsFixed(0)}% xumurame",

            ),



          ],



        ),



      ),



    );



  }








Widget _rewardCard(
    RewardProvider rewards,
) {


return Card(

child:Padding(

padding:
const EdgeInsets.all(16),

child:Column(

crossAxisAlignment:
CrossAxisAlignment.start,


children:[


const Text(

"Sadarkaa Barataa 🎓",

style:
TextStyle(

fontSize:20,

fontWeight:
FontWeight.bold,

),

),


const SizedBox(height:10),


Text(

"Level ${rewards.level}",

style:
const TextStyle(

fontSize:18,

),

),


const SizedBox(height:10),


LinearProgressIndicator(

value:
rewards.levelProgress,

),


const SizedBox(height:10),


Text(

"⭐ ${rewards.xp} XP",

),


Text(

"🪙 ${rewards.coins} Coins",

),


Text(

"🏆 ${rewards.stars} Stars",

),


],


),


),

);

}

}
