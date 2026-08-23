import 'package:flutter/material.dart';

import 'alphabet_screen.dart';
import 'lowercase_screen.dart';
import 'vowel_screen.dart';
import 'consonant_screen.dart';
import 'double_letter_screen.dart';
import 'tracing_practice_screen.dart';
import '../utils/responsive.dart';


class AlphabetMenuScreen extends StatelessWidget {

  const AlphabetMenuScreen({
    super.key,
  });


  @override
  Widget build(BuildContext context) {


    final screenWidth =
        MediaQuery.of(context).size.width;


    final columns = Responsive.homeColumns(context, max: 4);



    return Scaffold(

      appBar: AppBar(

        title: const Text(
          "Qubee 🔤",
        ),

        centerTitle: true,

      ),



      body: SafeArea(

        child: Center(

          child: ConstrainedBox(

            constraints: const BoxConstraints(
              maxWidth: 1400,
            ),


            child: Column(

              children: [


                const Padding(

                  padding: EdgeInsets.only(
                    top:20,
                    bottom:10,
                  ),


                  child: Column(

                    children: [

                      Text(
                        "🔤 Qubee Afaan Oromoo",

                        style: TextStyle(
                          fontSize:30,
                          fontWeight:
                          FontWeight.bold,
                        ),
                      ),


                      SizedBox(height:6),


                      Text(
                        "Kutaa Barnootaa Filadhu",

                        style: TextStyle(
                          fontSize:16,
                          color:Colors.grey,
                        ),
                      ),

                    ],
                  ),
                ),




                Expanded(

                  child: GridView.builder(

                    padding: EdgeInsets.symmetric(

                      horizontal:
                      Responsive.pagePadding(context),


                      vertical:20,

                    ),


                    itemCount:6,


                    gridDelegate:

                    SliverGridDelegateWithFixedCrossAxisCount(

                      crossAxisCount:
                      columns,


                      crossAxisSpacing:
                      screenWidth > 900
                          ? 22
                          : 14,


                      mainAxisSpacing:
                      screenWidth > 900
                          ? 22
                          : 14,


                      childAspectRatio:

                      screenWidth < 500
                          ? 1.15
                          : screenWidth < 900
                              ? 1.30
                              : 1.45,

                    ),




                    itemBuilder:(context,index){


                      final cards = [



                        _AlphabetCard(

                          title:
                          "Qubee Guguddaa 🔠",

                          subtitle:
                          "A B C D E ...",

                          color:
                          Colors.blue,

                          emoji:
                          "🔠",


                          onTap:(){

                            Navigator.push(

                              context,

                              MaterialPageRoute(

                                builder:(_)=>
                                const AlphabetScreen(),

                              ),

                            );

                          },

                        ),





                        _AlphabetCard(

                          title:
                          "Qubee Xiqqaa 🔡",

                          subtitle:
                          "a b c d e ...",

                          color:
                          Colors.green,

                          emoji:
                          "🔡",


                          onTap:(){

                            Navigator.push(

                              context,

                              MaterialPageRoute(

                                builder:(_)=>
                                const LowercaseScreen(),

                              ),

                            );

                          },

                        ),





                        _AlphabetCard(

                          title:
                          "Dubbachiiftuu 🟢",

                          subtitle:
                          "A E I O U",

                          color:
                          Colors.orange,

                          emoji:
                          "🗣️",


                          onTap:(){

                            Navigator.push(

                              context,

                              MaterialPageRoute(

                                builder:(_)=>
                                const VowelScreen(),

                              ),

                            );

                          },

                        ),





                        _AlphabetCard(

                          title:
                          "Dubbifamaa",

                          subtitle:
                          "B C D F ...",

                          color:
                          Colors.deepPurple,

                          emoji:
                          "🔤",


                          onTap:(){

                            Navigator.push(

                              context,

                              MaterialPageRoute(

                                builder:(_)=>
                                const ConsonantScreen(),

                              ),

                            );

                          },

                        ),





                        _AlphabetCard(

                          title:
                          "Qubee Dachaa",

                          subtitle:
                          "Ch Dh Ny Ph Sh",

                          color:
                          Colors.indigo,

                          emoji:
                          "✨",


                          onTap:(){

                            Navigator.push(

                              context,

                              MaterialPageRoute(

                                builder:(_)=>
                                const DoubleLetterScreen(),

                              ),

                            );

                          },

                        ),





                        _AlphabetCard(

                          title:
                          "Qubee Barreessi ✍️",

                          subtitle:
                          "Harkaan barreessuu shaakali",

                          color:
                          Colors.teal,

                          emoji:
                          "✍️",


                          onTap:(){

                            Navigator.push(

                              context,

                              MaterialPageRoute(

                                builder:(_)=>

                                const TracingPracticeScreen(

                                  mode:
                                  TracingMode.alphabet,

                                ),

                              ),

                            );

                          },

                        ),



                      ];



                      return cards[index];

                    },


                  ),

                ),


              ],

            ),

          ),

        ),

      ),

    );

  }

}









class _AlphabetCard extends StatelessWidget {


  final String title;

  final String subtitle;

  final Color color;

  final String emoji;

  final VoidCallback onTap;



  const _AlphabetCard({

    required this.title,

    required this.subtitle,

    required this.color,

    required this.emoji,

    required this.onTap,

  });





  @override
  Widget build(BuildContext context) {


    final width =
        MediaQuery.of(context).size.width;


    final emojiSize =
        width > 900
            ? 55.0
            : 45.0;



    return InkWell(

      borderRadius:
      BorderRadius.circular(28),


      onTap:onTap,


      child: Container(

        padding:
        const EdgeInsets.all(18),


        decoration:BoxDecoration(


          borderRadius:
          BorderRadius.circular(28),


          color:
          Colors.transparent,



          border: Border.all(

            color:
            color.withValues(
              alpha:0.35,
            ),

            width:2,

          ),



          boxShadow:[

            BoxShadow(

              color:
              color.withValues(
                alpha:0.15,
              ),

              blurRadius:18,

              offset:
              const Offset(0,8),

            ),

          ],


        ),




        child:Column(

          crossAxisAlignment:
          CrossAxisAlignment.start,


          children:[



            Container(

              width:80,

              height:80,


              alignment:
              Alignment.center,


              decoration:BoxDecoration(

                shape:
                BoxShape.circle,


                border:Border.all(

                  color:
                  color.withValues(
                    alpha:0.35,
                  ),

                  width:2,

                ),

              ),


              child:Text(

                emoji,

                style:TextStyle(

                  fontSize:
                  emojiSize,

                ),

              ),

            ),




            const Spacer(),





            Text(

              title,

              maxLines:2,

              overflow:
              TextOverflow.ellipsis,


              style:const TextStyle(

                fontSize:20,

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


              style:TextStyle(

                fontSize:14,

                color:
                Colors.grey.shade600,

              ),

            ),




            const SizedBox(height:8),




            Align(

              alignment:
              Alignment.bottomRight,


              child:Icon(

                Icons.arrow_forward_ios_rounded,

                size:18,

                color:
                color,

              ),

            ),



          ],

        ),


      ),

    );


  }

}
