import 'package:flutter/material.dart';

import '../models/word_item.dart';
import '../services/audio_service.dart';



class WordDetailScreen extends StatelessWidget {


  final WordItem word;


  WordDetailScreen({

    super.key,

    required this.word,

  });



  final AudioService audio =

  AudioService();







  @override
  Widget build(BuildContext context){



    return Scaffold(



      backgroundColor:

      const Color(0xfffffaf0),






      appBar:

      AppBar(



        title:

        Text(

          word.wordOromo,

        ),



        centerTitle:true,



      ),







      body:

      SingleChildScrollView(



        padding:

        const EdgeInsets.all(20),





        child:

        Column(



          mainAxisAlignment:

          MainAxisAlignment.center,



          children:[







            Card(



              elevation:

              5,



              shape:

              RoundedRectangleBorder(



                borderRadius:

                BorderRadius.circular(25),



              ),





              child:

              Padding(



                padding:

                const EdgeInsets.all(20),





                child:

                Column(



                  children:[







                    Image.asset(



                      word.image,



                      height:

                      220,



                      errorBuilder:

                      (context,error,stack){



                        return const Icon(



                          Icons.image_not_supported,



                          size:

                          120,



                        );



                      },



                    ),







                    const SizedBox(

                      height:20,

                    ),







                    Text(



                      word.wordOromo,



                      textAlign:

                      TextAlign.center,



                      style:

                      const TextStyle(



                        fontSize:40,



                        fontWeight:

                        FontWeight.bold,



                      ),



                    ),







                    const SizedBox(

                      height:10,

                    ),







                    Text(



                      word.wordEnglish,



                      style:

                      const TextStyle(



                        fontSize:25,



                        color:

                        Colors.grey,



                      ),



                    ),







                    const SizedBox(

                      height:25,

                    ),







                    Text(



                      "😊 Raajii:\nKun jecha ${word.wordOromo} dha!",



                      textAlign:

                      TextAlign.center,



                      style:

                      const TextStyle(



                        fontSize:18,



                        fontWeight:

                        FontWeight.w600,



                      ),



                    ),







                    const SizedBox(

                      height:25,

                    ),







                    ElevatedButton.icon(



                      onPressed:(){



                        audio.playSound(



                          word.sound,



                        );



                      },



                      icon:

                      const Icon(



                        Icons.volume_up,



                      ),



                      label:

                      const Text(



                        "Sagalee dhaggeeffadhu 🔊",



                      ),



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



}