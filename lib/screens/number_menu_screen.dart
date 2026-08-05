import 'package:flutter/material.dart';

import 'number_screen.dart';
import 'tracing_practice_screen.dart';





class NumberMenuScreen extends StatelessWidget {


  const NumberMenuScreen({

    super.key,

  });





  @override
  Widget build(BuildContext context) {



    return Scaffold(



      appBar:

      AppBar(



        title:

        const Text(

          "Lakkoofsa 🔢",

        ),



        centerTitle:true,


      ),







      body:

      SingleChildScrollView(



        padding:

        const EdgeInsets.all(16),





        child:

        Column(



          children:[







            Container(



              width:

              double.infinity,



              padding:

              const EdgeInsets.all(20),




              decoration:

              BoxDecoration(



                gradient:

                const LinearGradient(



                  colors:[

                    Colors.blue,

                    Colors.lightBlueAccent,

                  ],


                ),



                borderRadius:

                BorderRadius.circular(25),



              ),





              child:

              const Column(



                children:[





                  Text(



                    "😊 Ana Raji waliin Lakkoofsa haa barannu!",



                    textAlign:

                    TextAlign.center,



                    style:

                    TextStyle(



                      color:

                      Colors.white,

                      fontSize:

                      22,

                      fontWeight:

                      FontWeight.bold,


                    ),



                  ),






                  SizedBox(height:8),





                  Text(



                    "Lakkaa'i, barreessi, taphadhu ⭐",



                    style:

                    TextStyle(



                      color:

                      Colors.white,

                      fontSize:

                      17,


                    ),



                  ),




                ],



              ),



            ),







            const SizedBox(height:25),







            _NumberCard(



              title:

              "Lakkoofsa Baradhu 🔢",




              subtitle:

              "1 2 3 4 ...",

              


              color:

              Colors.blue,



              icon:

              Icons.numbers,




              onTap:(){



                Navigator.push(



                  context,



                  MaterialPageRoute(



                    builder:

                    (_)=>

                    const NumberScreen(),



                  ),



                );



              },



            ),







            const SizedBox(height:20),








            _NumberCard(



              title:

              "Lakkoofsa Taphadhu 🎮",




              subtitle:

              "Taphaan barumsaa dhufuuf jira",



              color:

              Colors.orange,



              icon:

              Icons.games,




              onTap:(){



                ScaffoldMessenger.of(context)

                    .showSnackBar(



                  const SnackBar(



                    content:

                    Text(



                      "🎮 Taphaan lakkoofsaa yeroo gabaabaa keessatti ni dhufa!",



                    ),



                  ),



                );



              },



            ),







            const SizedBox(height:20),







            _NumberCard(



              title:

              "Lakkoofsa Barreessi ✍️",




              subtitle:

              "Harkaan barreessuu shaakali",




              color:

              Colors.teal,



              icon:

              Icons.gesture,




              onTap:(){



                Navigator.push(



                  context,



                  MaterialPageRoute(



                    builder:

                    (_)=>

                    const TracingPracticeScreen(

                      mode:

                      TracingMode.numbers,

                    ),



                  ),



                );



              },



            ),







            const SizedBox(height:30),







            Card(



              elevation:

              4,



              shape:

              RoundedRectangleBorder(



                borderRadius:

                BorderRadius.circular(20),



              ),





              child:

              ListTile(



                leading:

                const CircleAvatar(



                  backgroundColor:

                  Colors.amber,



                  child:

                  Icon(

                    Icons.star,

                    color:

                    Colors.white,

                  ),



                ),





                title:

                const Text(



                  "Badhaasa argadhu ⭐",



                  style:

                  TextStyle(



                    fontWeight:

                    FontWeight.bold,

                    fontSize:

                    18,


                  ),



                ),





                subtitle:

                const Text(



                  "Barnoota xumuri, XP fi badge argadhu",



                ),



              ),



            ),




          ],



        ),



      ),



    );



  }



}









class _NumberCard extends StatelessWidget {



  final String title;

  final String subtitle;

  final Color color;

  final IconData icon;

  final VoidCallback onTap;




  const _NumberCard({



    required this.title,

    required this.subtitle,

    required this.color,

    required this.icon,

    required this.onTap,


  });







  @override
  Widget build(BuildContext context){



    return InkWell(



      borderRadius:

      BorderRadius.circular(25),



      onTap:

      onTap,





      child:

      Container(



        height:

        140,




        padding:

        const EdgeInsets.all(20),





        decoration:

        BoxDecoration(



          gradient:

          LinearGradient(



            colors:[

              color,

              color.withValues(alpha:.7),

            ],



          ),




          borderRadius:

          BorderRadius.circular(25),





          boxShadow:[



            BoxShadow(



              blurRadius:

              8,

              offset:

              const Offset(0,5),



              color:

              Colors.black26,



            ),



          ],




        ),






        child:

        Row(



          children:[






            CircleAvatar(



              radius:

              35,



              backgroundColor:

              Colors.white,




              child:

              Icon(



                icon,



                size:

                40,



                color:

                color,



              ),




            ),







            const SizedBox(width:20),







            Expanded(



              child:

              Column(



                mainAxisAlignment:

                MainAxisAlignment.center,



                crossAxisAlignment:

                CrossAxisAlignment.start,




                children:[





                  Text(



                    title,



                    style:

                    const TextStyle(



                      color:

                      Colors.white,

                      fontSize:

                      24,

                      fontWeight:

                      FontWeight.bold,


                    ),



                  ),






                  const SizedBox(height:8),





                  Text(



                    subtitle,



                    style:

                    const TextStyle(



                      color:

                      Colors.white,

                      fontSize:

                      16,


                    ),



                  ),




                ],



              ),



            ),




          ],



        ),



      ),



    );



  }


}