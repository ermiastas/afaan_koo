import 'package:flutter/material.dart';

import '../data/alphabet_data.dart';
import '../models/letter.dart';
import '../widgets/letter_card.dart';
import 'letter_detail_screen.dart';
import '../utils/responsive.dart';



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

        EdgeInsets.all(Responsive.pagePadding(context)),




        gridDelegate:

        Responsive.homeGridDelegate(
          context,


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
