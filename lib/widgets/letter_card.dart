import 'dart:io';

import 'package:flutter/material.dart';


class LetterCard extends StatelessWidget {


  final String letter;

  final String word;

  final String image;

  final VoidCallback onTap;


  // New optional fields
  final String? lowercase;

  final String? category;

  final bool showImage;

  final bool showWord;



  const LetterCard({

    super.key,

    required this.letter,

    this.word = "",

    this.image = "",

    required this.onTap,


    this.lowercase,

    this.category,

    this.showImage = true,

    this.showWord = true,

  });





  @override
  Widget build(BuildContext context){


    return InkWell(

      onTap: onTap,


      borderRadius:
      BorderRadius.circular(20),



      child: Card(


        elevation:5,


        shape:

        RoundedRectangleBorder(

          borderRadius:
          BorderRadius.circular(20),

        ),



        child:

        Padding(

          padding:
          const EdgeInsets.all(10),



          child:

          Column(


            mainAxisAlignment:
            MainAxisAlignment.center,



            children:[



              // Category (new)
              if(category != null)

                Text(

                  category!,

                  style:
                  const TextStyle(

                    fontSize:14,

                    color:Colors.blue,

                    fontWeight:
                    FontWeight.bold,

                  ),

                ),





              // Letter
              Text(

                letter,

                style:
                const TextStyle(

                  fontSize:50,

                  fontWeight:
                  FontWeight.bold,

                ),

              ),





              // Lowercase (new)

              if(lowercase != null)

                Text(

                  lowercase!,

                  style:
                  const TextStyle(

                    fontSize:40,

                    fontWeight:
                    FontWeight.w500,

                  ),

                ),




              const SizedBox(
                height:10,
              ),






              // Existing image support

              if(showImage)

                Expanded(

                  child:
                  buildImage(),

                ),






              const SizedBox(
                height:10,
              ),





              // Existing word support

              if(showWord && word.isNotEmpty)

                Text(

                  word,

                  textAlign:
                  TextAlign.center,


                  style:
                  const TextStyle(

                    fontSize:22,

                  ),

                ),





            ],

          ),

        ),

      ),

    );

  }









  Widget buildImage(){


    if(image.isEmpty){


      return const Icon(

        Icons.image,

        size:80,

      );


    }





    // Admin uploaded image

    if(image.startsWith("/")){


      return ClipRRect(

        borderRadius:
        BorderRadius.circular(15),



        child:

        Image.file(

          File(image),


          fit:
          BoxFit.cover,



          errorBuilder:
              (context,error,stack){


            return const Icon(

              Icons.broken_image,

              size:80,

            );


          },


        ),


      );


    }








    // JSON asset image

    return ClipRRect(


      borderRadius:
      BorderRadius.circular(15),



      child:

      Image.asset(

        image,

        fit:
        BoxFit.cover,



        errorBuilder:
            (context,error,stack){


          return const Icon(

            Icons.broken_image,

            size:80,

          );


        },

      ),


    );


  }



}