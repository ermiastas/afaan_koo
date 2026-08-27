import 'package:flutter/material.dart';

import 'alphabet_screen.dart';
import 'lowercase_screen.dart';
import 'vowel_screen.dart';
import 'consonant_screen.dart';
import 'double_letter_screen.dart';
import 'tracing_practice_screen.dart';
import '../utils/responsive.dart';
import '../widgets/background/moving_clouds.dart';



class AlphabetMenuScreen extends StatelessWidget {

  const AlphabetMenuScreen({super.key});


  @override
  Widget build(BuildContext context) {


    return Scaffold(

      appBar: AppBar(

        title: const Text("Qubee 🔤"),

        centerTitle: true,

      ),


      body: Stack(
        children: [
          Positioned.fill(
            child: Container(
              decoration: const BoxDecoration(
                gradient: LinearGradient(
                  begin: Alignment.topCenter,
                  end: Alignment.bottomCenter,
                  colors: [
                    Color(0xff8ED6FF),
                    Color(0xffCDEEFF),
                    Color(0xffF7FCFF),
                  ],
                ),
              ),
            ),
          ),
          const MovingClouds(),
          SafeArea(

        child: LayoutBuilder(

          builder:(context,constraints){


            final width = constraints.maxWidth;



            final cardWidth =
            width < Responsive.tinyBreakpoint
                ? width - (Responsive.pagePadding(context) * 2)
                : width < 400
                ? (width - 40) / 2
                : width < 800
                ? (width - 60) / 3
                : width < 1200
                ? (width - 90) / 4
                : 230.0;



            final cards = [

              _AlphabetCard(
                title:"Qubee Guguddaa 🔠",
                subtitle:"A B C D E ...",
                emoji:"🔠",
                color:Colors.blue,
                onTap:()=>_go(
                  context,
                  const AlphabetScreen(),
                ),
              ),


              _AlphabetCard(
                title:"Qubee Xiqqaa 🔡",
                subtitle:"a b c d e ...",
                emoji:"🔡",
                color:Colors.green,
                onTap:()=>_go(
                  context,
                  const LowercaseScreen(),
                ),
              ),


              _AlphabetCard(
                title:"Dubbachiiftuu 🟢",
                subtitle:"A E I O U",
                emoji:"🗣️",
                color:Colors.orange,
                onTap:()=>_go(
                  context,
                  const VowelScreen(),
                ),
              ),


              _AlphabetCard(
                title:"Dubbifamaa 🔵",
                subtitle:"B C D F ...",
                emoji:"🔤",
                color:Colors.deepPurple,
                onTap:()=>_go(
                  context,
                  const ConsonantScreen(),
                ),
              ),


              _AlphabetCard(
                title:"Qubee Dachaa ✨",
                subtitle:"Ch Dh Ny Ph Sh",
                emoji:"✨",
                color:Colors.indigo,
                onTap:()=>_go(
                  context,
                  const DoubleLetterScreen(),
                ),
              ),


              _AlphabetCard(
                title:"Qubee Barreessi ✍️",
                subtitle:"Harkaan barreessuu shaakali",
                emoji:"✍️",
                color:Colors.teal,
                onTap:()=>_go(
                  context,
                  const TracingPracticeScreen(
                    mode:TracingMode.alphabet,
                  ),
                ),
              ),


            ];



            return SingleChildScrollView(

              physics:
              const BouncingScrollPhysics(),


              child: Padding(

                padding:
                EdgeInsets.all(Responsive.pagePadding(context)),


                child: Column(

                  crossAxisAlignment: CrossAxisAlignment.start,

                  children: [

                    const Text(
                      "🔤 Qubee Afaan Oromoo",
                      style: TextStyle(
                        fontSize: 25,
                        fontWeight: FontWeight.bold,
                      ),
                    ),

                    const SizedBox(height: 6),

                    const Text(
                      "Kutaa barnootaa filadhu",
                      style: TextStyle(fontSize: 16),
                    ),

                    const SizedBox(height: 20),

                    Wrap(

                  spacing:16,

                  runSpacing:16,


                  children:

                  cards.map((card){

                    return SizedBox(

                      width:cardWidth,

                      child:card,

                    );

                  }).toList(),


                    ),
                  ],
                ),


              ),


            );


          },

        ),

          ),
        ],
      ),

    );

  }





  void _go(
      BuildContext context,
      Widget page,
      ){

    Navigator.push(

      context,

      MaterialPageRoute(

        builder:(_)=>page,

      ),

    );

  }

}







class _AlphabetCard extends StatelessWidget {


  final String title;

  final String subtitle;

  final String emoji;

  final Color color;

  final VoidCallback onTap;



  const _AlphabetCard({

    required this.title,

    required this.subtitle,

    required this.emoji,

    required this.color,

    required this.onTap,

  });



  @override
  Widget build(BuildContext context) {


    return IntrinsicHeight(

      child:InkWell(

        borderRadius:
        BorderRadius.circular(24),


        onTap:onTap,


        child:Container(

          padding:
          const EdgeInsets.all(14),


          decoration:BoxDecoration(


            borderRadius:
            BorderRadius.circular(24),


            border:
            Border.all(

              color:
              color.withValues(alpha:.35),

              width:2,

            ),


            boxShadow:[

              BoxShadow(

                color:
                color.withValues(alpha:.12),

                blurRadius:12,

                offset:
                const Offset(0,6),

              )

            ],


          ),




          child:Column(

            mainAxisSize:
            MainAxisSize.min,


            children:[



              Container(

                width:70,

                height:70,


                decoration:BoxDecoration(

                  shape:
                  BoxShape.circle,


                  border:
                  Border.all(

                    color:
                    color.withValues(alpha:.35),

                    width:2,

                  ),

                ),



                child:Center(

                  child:Text(

                    emoji,

                    style:
                    const TextStyle(

                      fontSize:40,

                    ),

                  ),

                ),


              ),



              const SizedBox(height:10),



              Text(

                title,

                maxLines:2,

                overflow:
                TextOverflow.ellipsis,


                textAlign:
                TextAlign.center,


                style:
                const TextStyle(

                  fontSize:17,

                  fontWeight:
                  FontWeight.bold,

                ),

              ),



              const SizedBox(height:6),



              Text(

                subtitle,


                maxLines:2,

                overflow:
                TextOverflow.ellipsis,


                textAlign:
                TextAlign.center,


                style:
                TextStyle(

                  fontSize:13,

                  color:
                  Colors.grey,

                ),

              ),



              const SizedBox(height:8),



              Icon(

                Icons.arrow_forward_ios_rounded,

                size:16,

                color:color,

              ),


            ],


          ),


        ),


      ),

    );


  }

}
