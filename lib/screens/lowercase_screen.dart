import 'package:flutter/material.dart';

import '../data/alphabet_data.dart';
import '../models/letter.dart';
import '../widgets/letter_card.dart';
import 'letter_detail_screen.dart';



class LowercaseScreen extends StatelessWidget {


  const LowercaseScreen({
    super.key,
  });



  @override
  Widget build(BuildContext context){



    final List<Letter> alphabet =
        letters;



    return Scaffold(



      appBar:

      AppBar(

        title:

        const Text(
          "Qubee Xiqqaa 🔡",
        ),

        centerTitle:true,

      ),




      body:

      GridView.builder(



        padding:

        const EdgeInsets.all(15),




        gridDelegate:

        const SliverGridDelegateWithFixedCrossAxisCount(


          crossAxisCount:2,


          crossAxisSpacing:12,


          mainAxisSpacing:12,


          childAspectRatio:0.85,


        ),




        itemCount:

        alphabet.length,





        itemBuilder:

        (context,index){



          final letter =
              alphabet[index];




          return LetterCard(



            letter:

            letter.lowercase,



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


    );


  }

}