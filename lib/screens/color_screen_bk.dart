import 'package:flutter/material.dart';

import '../models/color_item.dart';

import '../services/content_service.dart';
import '../services/audio_service.dart';

import '../data/lesson_ids.dart';

import '../widgets/lesson_complete_button.dart';



class ColorScreen extends StatefulWidget {


  const ColorScreen({

    super.key,

  });



  @override
  State<ColorScreen> createState()

  => _ColorScreenState();


}







class _ColorScreenState extends State<ColorScreen> {



  final ContentService service =

      ContentService();



  final AudioService audio =

      AudioService();




  late Future<List<ColorItem>> colors;







  @override
  void initState() {

    super.initState();


    colors =

    service.getColors();


  }









  @override
  Widget build(BuildContext context) {


    return Scaffold(



      appBar:

      AppBar(



        title:

        const Text(

          "Halluu Koo 🎨",

        ),


        centerTitle:true,


      ),







      body:

      FutureBuilder<List<ColorItem>>(



        future:

        colors,





        builder:

        (context, snapshot) {




          if(snapshot.connectionState ==

              ConnectionState.waiting) {



            return const Center(


              child:

              CircularProgressIndicator(),


            );


          }








          if(snapshot.hasError) {



            return Center(


              child:

              Text(


                "Dogoggora: ${snapshot.error}",


              ),


            );


          }









          if(!snapshot.hasData ||

              snapshot.data!.isEmpty) {



            return const Center(



              child:

              Text(


                "Halluun hin jiru 🎨",


                style:

                TextStyle(

                  fontSize:20,

                ),

              ),


            );


          }








          final list =

          snapshot.data!;







          return Column(



            children:[





              Expanded(



                child:

                ListView.builder(



                  padding:

                  const EdgeInsets.all(12),




                  itemCount:

                  list.length,





                  itemBuilder:

                  (context,index) {





                    final color =

                    list[index];







                    return Card(



                      margin:

                      const EdgeInsets.only(

                        bottom:12,

                      ),






                      shape:

                      RoundedRectangleBorder(



                        borderRadius:

                        BorderRadius.circular(20),



                      ),







                      elevation:5,








                      child:

                      ListTile(








                        leading:

                        Container(



                          width:55,



                          height:55,







                          decoration:

                          BoxDecoration(



                            color:

                            Color(



                              int.parse(



                                color.colorCode

                                .replaceFirst(

                                    "#",

                                    "0xff"

                                ),



                              ),



                            ),





                            borderRadius:

                            BorderRadius.circular(15),



                          ),



                        ),







                        title:

                        Text(



                          color.nameOromo,



                          style:

                          const TextStyle(



                            fontSize:24,



                            fontWeight:

                            FontWeight.bold,



                          ),



                        ),







                        subtitle:

                        Text(



                          color.nameEnglish,



                          style:

                          const TextStyle(

                            fontSize:16,

                          ),

                        ),







                        trailing:

                        IconButton(



                          icon:

                          const Icon(



                            Icons.volume_up,



                            size:32,



                          ),





                          onPressed:(){



                            audio.playSound(



                              color.sound,



                            );



                          },



                        ),





                      ),



                    );





                  },





                ),


              ),







              // ===========================
              // Lesson Complete
              // ===========================


              Padding(



                padding:

                const EdgeInsets.all(16),





                child:

                LessonCompleteButton(



                  lessonId:

                  LessonIds.colors,



                ),



              ),






            ],



          );





        },



      ),



    );


  }



}