import 'package:flutter/material.dart';

import '../data/fruit_data.dart';
import '../data/lesson_ids.dart';

import '../services/audio_service.dart';

import '../widgets/fruit_card.dart';
import '../widgets/lesson_complete_button.dart';



class FruitScreen extends StatelessWidget {


  FruitScreen({

    super.key,

  });



  final AudioService audioService =

      AudioService();





  @override
  Widget build(BuildContext context) {



    return Scaffold(



      backgroundColor:

      const Color(0xffFFF8F2),





      appBar:

      AppBar(



        title:

        const Text(
          "🍎 Muduraa Koo",
        ),



        centerTitle:

        true,



        backgroundColor:

        Colors.red,



        foregroundColor:

        Colors.white,



        elevation:

        0,



      ),







      body:

      Column(



        children:[





          Container(



            width:

            double.infinity,



            padding:

            const EdgeInsets.all(20),





            decoration:

            const BoxDecoration(



              color:

              Colors.red,



              borderRadius:

              BorderRadius.only(



                bottomLeft:

                Radius.circular(30),



                bottomRight:

                Radius.circular(30),



              ),



            ),





            child:

            const Column(



              children:[

/*

                Text(



                  "🍎 Firii Koo",



                  style:

                  TextStyle(



                    fontSize:30,

                    fontWeight:

                    FontWeight.bold,

                    color:

                    Colors.white,



                  ),



                ),

*/



                SizedBox(

                  height:8,

                ),







                Text(



                  "Firii adda addaa baradhu fi sagalee isaanii dhaggeeffadhu.",



                  textAlign:

                  TextAlign.center,



                  style:

                  TextStyle(



                    fontSize:16,

                    color:

                    Colors.white,



                  ),



                ),



              ],



            ),



          ),







          Expanded(



            child:

            GridView.builder(



              padding:

              const EdgeInsets.all(16),





              itemCount:

              fruitData.length,





              gridDelegate:

              const SliverGridDelegateWithFixedCrossAxisCount(



                crossAxisCount:

                2,



                childAspectRatio:

                .78,



                crossAxisSpacing:

                12,



                mainAxisSpacing:

                12,



              ),






              itemBuilder:(context,index){



                final fruit =

                fruitData[index];







                return FruitCard(



                  fruit:

                  fruit,







                  onTap:() async{





                    await audioService.playSound(

                      fruit.sound,

                    );







                    if(!context.mounted) return;











                    showDialog(



                      context:

                      context,



                      builder:(dialogContext){



                        return AlertDialog(



                          shape:

                          RoundedRectangleBorder(



                            borderRadius:

                            BorderRadius.circular(25),



                          ),







                          title:

                          Text(



                            fruit.nameOromo,



                            textAlign:

                            TextAlign.center,



                            style:

                            const TextStyle(



                              fontSize:28,

                              fontWeight:

                              FontWeight.bold,



                            ),



                          ),







                          content:

                          Column(



                            mainAxisSize:

                            MainAxisSize.min,







                            children:[





                              Image.asset(



                                fruit.image,



                                height:

                                170,



                                errorBuilder:

                                (context,error,stack){



                                  return const Icon(



                                    Icons.apple,



                                    size:120,



                                  );



                                },



                              ),








                              const SizedBox(

                                height:20,

                              ),








                              Text(



                                fruit.nameEnglish,



                                style:

                                const TextStyle(



                                  fontSize:22,

                                  color:

                                  Colors.grey,



                                ),



                              ),







                              const SizedBox(

                                height:20,

                              ),








                              Text(



                                "😊 Raajii:\nKun ${fruit.nameOromo} dha!",



                                textAlign:

                                TextAlign.center,



                                style:

                                const TextStyle(



                                  fontSize:18,

                                  fontWeight:

                                  FontWeight.w600,



                                ),



                              ),



                            ],



                          ),









                          actions:[



                            TextButton(



                              onPressed:(){



                                Navigator.pop(

                                  dialogContext,

                                );



                              },



                              child:

                              const Text(

                                "Cufi",

                              ),



                            ),



                          ],




                        );



                      },



                    );



                  },



                );



              },



            ),



          ),







          Padding(



            padding:

            const EdgeInsets.all(16),





            child:

            LessonCompleteButton(



              // Uniform lesson tracking ID

              lessonId:

              LessonIds.fruit,



            ),



          ),





        ],



      ),



    );



  }



}