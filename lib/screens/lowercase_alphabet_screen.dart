import 'package:flutter/material.dart';

import '../data/alphabet_data.dart';
import '../widgets/letter_card.dart';
import 'letter_detail_screen.dart';
import '../utils/responsive.dart';


class LowercaseAlphabetScreen extends StatelessWidget {


  const LowercaseAlphabetScreen({
    super.key,
  });



  @override
  Widget build(BuildContext context){


    return Scaffold(


      appBar:

      AppBar(

        title:

        const Text(
          "Qubee Xiqqaa 🔡",
        ),

      ),



      body:

      GridView.builder(


        padding:

        EdgeInsets.all(Responsive.pagePadding(context)),



        gridDelegate:

        Responsive.homeGridDelegate(
          context,

          crossAxisSpacing:12,

          mainAxisSpacing:12,

          childAspectRatio:0.85,

        ),



        itemCount:

        letters.length,



        itemBuilder:

        (context,index){


          final letter =
              letters[index];



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
