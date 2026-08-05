import 'package:flutter/material.dart';

import '../models/word_item.dart';

import '../services/content_service.dart';

import '../widgets/word_card.dart';
import '../widgets/lesson_complete_button.dart';

import '../data/lesson_ids.dart';

import 'word_detail_screen.dart';





class WordScreen extends StatefulWidget {


  const WordScreen({

    super.key,

  });



  @override
  State<WordScreen> createState()

  => _WordScreenState();



}









class _WordScreenState

extends State<WordScreen>{



  final ContentService contentService =

  ContentService();





  late Future<List<WordItem>> words;








  @override
  void initState(){


    super.initState();


    loadWords();


  }








  void loadWords(){


    words =

    contentService.getWords();


  }








  Future<void> refreshWords() async {



    setState((){



      loadWords();



    });



  }









  @override
  Widget build(BuildContext context){



    return Scaffold(





      backgroundColor:

      const Color(0xfffffaf2),







      appBar:

      AppBar(



        title:

        const Text(

          "📝 Jechoota Koo",

        ),



        centerTitle:true,



        actions:[



          IconButton(



            icon:

            const Icon(

              Icons.refresh,

            ),



            onPressed:

            refreshWords,



          ),



        ],



      ),







      body:

      FutureBuilder<List<WordItem>>(





        future:

        words,






        builder:

        (context,snapshot){






          if(snapshot.connectionState ==

              ConnectionState.waiting){



            return const Center(



              child:

              CircularProgressIndicator(),



            );



          }








          if(snapshot.hasError){



            return Center(



              child:

              Text(

                "Dogoggora: ${snapshot.error}",

              ),



            );



          }









          final wordList =

          snapshot.data ?? [];









          if(wordList.isEmpty){



            return const Center(



              child:

              Text(



                "Jechoota hin argamne",



                style:

                TextStyle(

                  fontSize:20,

                ),



              ),



            );



          }









          return Column(





            children:[







              Container(



                width:

                double.infinity,



                padding:

                const EdgeInsets.all(18),





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





                    Text(



                      "📚 Jechoota Afaan Oromoo",



                      style:

                      TextStyle(



                        color:

                        Colors.white,



                        fontSize:28,



                        fontWeight:

                        FontWeight.bold,



                      ),



                    ),






                    SizedBox(

                      height:8,

                    ),







                    Text(



                      "Jechoota haaraa baradhu, dubbisi, sagalee dhaggeeffadhu!",



                      textAlign:

                      TextAlign.center,



                      style:

                      TextStyle(



                        color:

                        Colors.white,



                        fontSize:16,



                      ),



                    ),



                  ],



                ),



              ),







              Expanded(



                child:

                GridView.builder(



                  padding:

                  const EdgeInsets.all(15),








                  gridDelegate:

                  const SliverGridDelegateWithFixedCrossAxisCount(



                    crossAxisCount:

                    2,



                    crossAxisSpacing:

                    12,



                    mainAxisSpacing:

                    12,



                    childAspectRatio:

                    0.8,



                  ),









                  itemCount:

                  wordList.length,









                  itemBuilder:

                  (context,index){



                    final word =

                    wordList[index];









                    return WordCard(



                      word:

                      word.wordOromo,





                      image:

                      word.image,









                      onTap:

                      (){



                        Navigator.push(



                          context,



                          MaterialPageRoute(



                            builder:(context)



                            =>



                            WordDetailScreen(



                              word:

                              word,



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

                  LessonIds.words,



                ),



              ),






            ],



          );





        },



      ),



    );



  }



}