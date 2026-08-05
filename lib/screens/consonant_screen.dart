import 'package:flutter/material.dart';

import '../data/alphabet_data.dart';
import '../data/lesson_ids.dart';

import '../models/letter.dart';

import '../widgets/letter_card.dart';
import '../widgets/lesson_complete_button.dart';

import 'letter_detail_screen.dart';



class ConsonantScreen extends StatelessWidget {


  const ConsonantScreen({

    super.key,

  });





  @override
  Widget build(BuildContext context) {


    final width =
        MediaQuery.of(context).size.width;




    // Responsive columns
    final columns =

    width < 500

        ? 2

        : width < 900

            ? 3

            : 5;






    // =====================================
    // Only true consonants
    // Remove Qubee Dachaa
    // =====================================

    final consonants = letters

        .where(

          (letter) =>

              letter.type == LetterType.consonant

              &&

              ![
                "CH",
                "DH",
                "NY",
                "PH",
                "SH",

              ]

              .contains(

                letter.uppercase.toUpperCase(),

              ),

        )

        .toList();






    return Scaffold(



      appBar:

      AppBar(



        title:

        const Text(

          "Dubbifamaa 🔵",

        ),



        centerTitle:true,



      ),







      body:

      SafeArea(



        child:

        Column(



          children:[





            const Padding(



              padding:

              EdgeInsets.only(

                top:16,

                bottom:8,

              ),




              child:

              Text(



                "Dubbifamaa Afaan Oromoo",



                style:

                TextStyle(



                  fontSize:26,



                  fontWeight:

                  FontWeight.bold,



                ),



              ),



            ),







            Expanded(



              child:

              GridView.builder(





                padding:

                EdgeInsets.all(

                  width > 900

                      ? 30

                      : 16,

                ),






                gridDelegate:



                SliverGridDelegateWithFixedCrossAxisCount(



                  crossAxisCount:

                  columns,



                  crossAxisSpacing:

                  width > 900

                      ? 20

                      : 12,



                  mainAxisSpacing:

                  width > 900

                      ? 20

                      : 12,



                  childAspectRatio:



                  width < 500

                      ? 0.85

                      : width < 900

                          ? 1.0

                          : 1.15,



                ),







                itemCount:

                consonants.length,








                itemBuilder:

                (context,index){





                  final letter =

                  consonants[index];







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



                            letter:

                            letter,



                          ),



                        ),



                      );





                    },



                  );






                },



              ),



            ),










            // ==========================
            // COMPLETE LESSON
            // ==========================


            Padding(



              padding:

              const EdgeInsets.all(16),





              child:

              LessonCompleteButton(



                lessonId:

                LessonIds.consonant,



              ),



            ),





          ],



        ),



      ),



    );



  }



}