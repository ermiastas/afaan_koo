import 'package:flutter/material.dart';

import '../models/letter.dart';
import '../services/audio_service.dart';


class LetterDetailScreen extends StatelessWidget {


  final Letter letter;


  final AudioService audioService = AudioService();



  LetterDetailScreen({

    super.key,

    required this.letter,

  });





  void playSound(String sound) {


    if(sound.isEmpty){

      return;

    }


    audioService.play(sound);


  }






  @override
  Widget build(BuildContext context){


    return Scaffold(


      appBar:

      AppBar(

        title:

        Text(

          letter.display,

        ),

      ),





      body:

      SingleChildScrollView(


        padding:

        const EdgeInsets.all(20),



        child:

        Column(


          children:[




            Text(

              letter.display,

              style:

              const TextStyle(

                fontSize:80,

                fontWeight:

                FontWeight.bold,

              ),

            ),





            const SizedBox(height:20),





            Image.asset(

              letter.image,

              height:180,


              errorBuilder:

              (context,error,stack){


                return const Icon(

                  Icons.image_not_supported,

                  size:100,

                );


              },


            ),





            const SizedBox(height:20),





            ElevatedButton.icon(


              onPressed:(){


                playSound(

                  letter.sound,

                );


              },



              icon:

              const Icon(

                Icons.volume_up,

              ),



              label:

              const Text(

                "Qubee dhaggeeffadhu",

              ),


            ),






            const SizedBox(height:30),






            const Align(

              alignment:

              Alignment.centerLeft,


              child:

              Text(

                "Jechoota Fakkeenyaa",

                style:

                TextStyle(

                  fontSize:24,

                  fontWeight:

                  FontWeight.bold,

                ),

              ),


            ),






            const SizedBox(height:10),






            ...letter.allExamples.map(

              (example){



                return Card(



                  child:

                  ListTile(



                    leading:


                    Image.asset(

                      example.image,

                      width:55,

                      height:55,



                      errorBuilder:

                      (context,error,stack){


                        return const Icon(

                          Icons.image,

                        );


                      },


                    ),





                    title:


                    Text(

                      example.wordOromo,

                      style:

                      const TextStyle(

                        fontSize:22,

                        fontWeight:

                        FontWeight.bold,

                      ),

                    ),





                    subtitle:


                    Text(

                      example.wordEnglish ?? "",

                    ),






                    trailing:


                    IconButton(


                      icon:

                      const Icon(

                        Icons.volume_up,

                      ),





                      onPressed:(){



                        if(example.sound != null){



                          playSound(

                            example.sound!,

                          );


                        }



                      },



                    ),





                  ),


                );



              },

            ),




          ],


        ),


      ),


    );


  }


}