import 'package:flutter/material.dart';

import '../data/alphabet_data.dart';
import '../models/letter.dart';

import '../widgets/letter_card.dart';
import '../widgets/lesson_complete_button.dart';

import '../data/lesson_ids.dart';

import 'letter_detail_screen.dart';
import '../utils/responsive.dart';



class VowelScreen extends StatelessWidget {


  const VowelScreen({

    super.key,

  });




  @override
  Widget build(BuildContext context) {



    final vowels = letters

        .where(

          (letter) =>

              letter.type == LetterType.vowel,

        )

        .toList();







    return Scaffold(



      backgroundColor:

      const Color(0xfffffff3),






      appBar:

      AppBar(



        title:

        const Text(

          "Dubbachiiftuu 🟢",

        ),



        centerTitle:

        true,



        backgroundColor:

        Colors.orange,



        foregroundColor:

        Colors.white,



      ),







      body:

      Column(



        children:[





          Container(



            width:

            double.infinity,



            padding:

            const EdgeInsets.all(18),





            decoration:

            const BoxDecoration(



              color:

              Colors.orange,



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



                Text(



                  "🟢 A E I O U",



                  style:

                  TextStyle(



                    color:

                    Colors.white,



                    fontSize:30,



                    fontWeight:

                    FontWeight.bold,



                  ),



                ),






                SizedBox(

                  height:8,

                ),







                Text(



                  "Dubbachiiftuu Afaan Oromoo haa barannu!",



                  textAlign:

                  TextAlign.center,



                  style:

                  TextStyle(



                    color:

                    Colors.white,



                    fontSize:17,



                  ),



                ),



              ],



            ),



          ),








          Expanded(



            child:

            vowels.isEmpty

                ?

            const Center(



              child:

              Text(



                "Dubbachiiftuun hin argamne",



                style:

                TextStyle(

                  fontSize:20,

                ),



              ),



            )



                :



            GridView.builder(



              padding:

              EdgeInsets.all(Responsive.pagePadding(context)),





              gridDelegate:

              Responsive.homeGridDelegate(
                context,



                crossAxisSpacing:

                12,



                mainAxisSpacing:

                12,



                childAspectRatio:

                0.85,



              ),







              itemCount:

              vowels.length,







              itemBuilder:

              (context,index){





                final letter =

                vowels[index];








                return LetterCard(



                  letter:

                  letter.uppercase,





                  word:

                  letter.example,





                  image:

                  letter.image,







                  onTap:(){





                    Navigator.push(



                      context,



                      MaterialPageRoute(



                        builder:(context)=>



                        LetterDetailScreen(



                          letter:letter,



                        ),



                      ),



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

              LessonIds.vowels,



            ),



          ),





        ],



      ),



    );



  }



}
