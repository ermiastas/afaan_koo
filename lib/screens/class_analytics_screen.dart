import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../providers/class_provider.dart';
import '../providers/progress_provider.dart';
import '../providers/reward_provider.dart';



class ClassAnalyticsScreen extends StatelessWidget {

  final String classId;


  const ClassAnalyticsScreen({

    super.key,

    required this.classId,

  });



  @override
  Widget build(BuildContext context) {


    final classroom =
        context.watch<ClassProvider>();


    final progress =
        context.watch<ProgressProvider>();


    final rewards =
        context.watch<RewardProvider>();



    return Scaffold(


      appBar: AppBar(

        title:

        const Text(
          "Gabaasa Barnootaa 📊",
        ),

      ),




      body:

      SingleChildScrollView(


        padding:

        const EdgeInsets.all(16),



        child:

        Column(

          children:[




            _summaryCard(

              "👧 Barattoota",

              classroom.totalStudents.toString(),

            ),




            _summaryCard(

              "📚 Barnoota Xumurame",

              progress.completedCount.toString(),

            ),




            _summaryCard(

              "⭐ Stars",

              rewards.stars.toString(),

            ),




            _summaryCard(

              "🏆 XP",

              rewards.xp.toString(),

            ),





            const SizedBox(height:20),





            Card(


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

                      "Guddina Barataa",

                      style:

                      TextStyle(

                        fontSize:20,

                        fontWeight:

                        FontWeight.bold,

                      ),

                    ),




                    const SizedBox(height:20),




                    LinearProgressIndicator(

                      value:

                      classroom.averageProgress,

                      minHeight:

                      15,

                    ),




                    const SizedBox(height:10),




                    Text(

                      "${(classroom.averageProgress * 100).toInt()}% giddugaleessa",

                    ),



                  ],


                ),


              ),



            ),





          ],


        ),


      ),


    );


  }







  Widget _summaryCard(

      String title,

      String value,

      ){


    return Card(



      child:

      ListTile(


        leading:

        const Icon(

          Icons.analytics,

        ),




        title:

        Text(title),




        trailing:

        Text(

          value,

          style:

          const TextStyle(

            fontSize:22,

            fontWeight:

            FontWeight.bold,

          ),

        ),



      ),


    );


  }


}