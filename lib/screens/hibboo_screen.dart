import 'package:flutter/material.dart';

import '../data/hibboo_data.dart';
import '../data/lesson_ids.dart';

import '../widgets/hibboo_card.dart';
import '../services/audio_service.dart';
import '../widgets/lesson_complete_button.dart';
import '../utils/responsive.dart';





class HibbooScreen extends StatelessWidget {


  const HibbooScreen({

    super.key,

  });






  @override
  Widget build(BuildContext context){



    return Scaffold(





      backgroundColor:

      const Color(0xfffff8e1),






      appBar:

      AppBar(



        title:

        const Text(

          "💡 Hibboo Koo",

        ),





        backgroundColor:

        Colors.amber,



      ),










      body:

      Column(



        children:[







          Expanded(



            child:

            GridView.builder(



              padding:

              EdgeInsets.all(Responsive.pagePadding(context)),






              gridDelegate:

              Responsive.homeGridDelegate(
                context,



                childAspectRatio:

                .75,



              ),







              itemCount:

              hibbooData.length,








              itemBuilder:(context,index){





                final hibboo =

                hibbooData[index];










                return HibbooCard(



                  hibboo:

                  hibboo,







                  onTap:() async{






                    await AudioService()

                        .playSound(

                      hibboo.audio,

                    );







                    if(!context.mounted){

                      return;

                    }









                    showDialog(



                      context:

                      context,



                      builder:(dialogContext){



                        return AlertDialog(



                          title:

                          const Text(

                            "💡 Hibboo",

                          ),






                          content:

                          Column(



                            mainAxisSize:

                            MainAxisSize.min,







                            children:[






                              Text(



                                hibboo.question,



                                style:

                                const TextStyle(



                                  fontSize:18,

                                  fontWeight:

                                  FontWeight.bold,



                                ),

                              ),








                              const SizedBox(

                                height:20,

                              ),







                              Text(



                                "💭 Yaada:\n${hibboo.hint}",



                              ),








                              const SizedBox(

                                height:20,

                              ),









                              ElevatedButton(



                                onPressed:(){





                                  Navigator.pop(

                                      dialogContext

                                  );







                                  showDialog(



                                    context:

                                    context,





                                    builder:(answerContext){





                                      return AlertDialog(





                                        title:

                                        const Text(

                                          "✅ Deebii",

                                        ),









                                        content:

                                        Text(



                                          hibboo.answer,



                                          style:

                                          const TextStyle(



                                            fontSize:18,



                                          ),

                                        ),









                                        actions:[





                                          TextButton(



                                            onPressed:(){



                                              Navigator.pop(

                                                  answerContext

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







                                child:

                                const Text(

                                  "Deebii ilaali",

                                ),





                              ),





                            ],





                          ),







                          actions:[





                            TextButton(



                              onPressed:(){



                                Navigator.pop(

                                    dialogContext

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



              // Uniform lesson ID

              lessonId:

              LessonIds.hibboo,



            ),



          ),






        ],



      ),



    );



  }



}
