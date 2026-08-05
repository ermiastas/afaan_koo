import 'package:flutter/material.dart';

import '../data/vegetable_data.dart';
import '../services/audio_service.dart';

import '../widgets/vegetable_card.dart';
import '../widgets/lesson_complete_button.dart';

import '../data/lesson_ids.dart';



class VegetableScreen extends StatelessWidget {


  VegetableScreen({

    super.key,

  });



  final AudioService _audioService =

  AudioService();





  @override
  Widget build(BuildContext context) {



    return Scaffold(



      backgroundColor:

      const Color(0xffF4FFF2),






      appBar:

      AppBar(



        title:

        const Text(

          "🥕 Kuduraa Koo",

        ),



        centerTitle:

        true,



        backgroundColor:

        Colors.green,



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

              Colors.green,



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



                  "🥕 Kuduraa Koo",



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



                  "Kuduraalee adda addaa baradhu fi sagalee isaanii dhaggeeffadhu.",



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

              vegetableData.length,







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



                final vegetable =

                vegetableData[index];







                return VegetableCard(



                  vegetable:

                  vegetable,







                  onTap:() async{






                    await _audioService.playSound(



                      vegetable.sound,



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



                            vegetable.nameOromo,



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



                                vegetable.image,



                                height:

                                170,



                                errorBuilder:

                                (context,error,stack){



                                  return const Icon(



                                    Icons.eco,



                                    size:120,



                                  );



                                },



                              ),








                              const SizedBox(

                                height:20,

                              ),








                              Text(



                                vegetable.nameEnglish,



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



                                "😊 Raajii:\nKun ${vegetable.nameOromo} dha!",



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



              lessonId:

              LessonIds.vegetables,



            ),



          ),






        ],



      ),



    );



  }



}