import 'package:flutter/material.dart';

import '../data/journey_data.dart';
import '../data/lesson_ids.dart';

import '../widgets/journey/journey_node.dart';
import '../widgets/lesson_complete_button.dart';



class JourneyScreen extends StatelessWidget {


  const JourneyScreen({

    super.key,

  });





  @override
  Widget build(BuildContext context) {


    return Scaffold(



      appBar:

      AppBar(


        title:

        const Text(

          "🗺️ Afaan Koo Journey",

        ),


        centerTitle:true,


      ),







      body:

      Column(



        children:[







          Expanded(



            child:

            ListView.builder(



              padding:

              const EdgeInsets.all(20),






              itemCount:

              journeyItems.length,







              itemBuilder:(context,index){





                final item =

                journeyItems[index];







                return Padding(



                  padding:

                  const EdgeInsets.symmetric(

                    vertical:20,

                  ),





                  child:

                  JourneyNode(



                    item:

                    item,





                    onTap:(){



                      // Open journey lesson here

                      // Navigator.push(...)



                    },



                  ),



                );



              },



            ),



          ),











          Padding(



            padding:

            const EdgeInsets.all(16),






            child:

            LessonCompleteButton(



              lessonId:

              LessonIds.journey,



            ),



          ),







        ],



      ),




    );



  }



}