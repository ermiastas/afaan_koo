import 'package:flutter/material.dart';



// ===============================
// Category Card
// ===============================


class CategoryCard extends StatelessWidget {


  final String title;

  final String subtitle;

  final String emoji;

  final Color color;

  final VoidCallback onTap;



  const CategoryCard({


    super.key,


    required this.title,


    required this.subtitle,


    required this.emoji,


    required this.color,


    required this.onTap,


  });



  @override
  Widget build(BuildContext context){



    return InkWell(



      onTap:onTap,



      borderRadius:

      BorderRadius.circular(25),




      child:


      Container(



        padding:

        const EdgeInsets.all(12),



        decoration:

        BoxDecoration(



          color:color,



          borderRadius:

          BorderRadius.circular(25),




          boxShadow:[



            BoxShadow(

              blurRadius:8,

              offset:

              const Offset(0,4),

              color:

              Colors.black.withValues(alpha: 0.15),

            )



          ],



        ),





        child:


        Column(



          mainAxisAlignment:

          MainAxisAlignment.center,



          children:[





            Text(


              emoji,


              style:

              const TextStyle(

                fontSize:45,

              ),


            ),





            const SizedBox(height:10),





            Text(



              title,



              textAlign:

              TextAlign.center,



              maxLines:2,



              overflow:

              TextOverflow.ellipsis,



              style:


              const TextStyle(

                color:

                Colors.white,


                fontSize:18,


                fontWeight:

                FontWeight.bold,


              ),



            ),






            const SizedBox(height:5),





            Text(



              subtitle,



              textAlign:

              TextAlign.center,



              maxLines:2,



              overflow:

              TextOverflow.ellipsis,



              style:


              const TextStyle(

                color:

                Colors.white70,


                fontSize:12,


              ),



            ),





          ],



        ),



      ),



    );



  }


}









// ===============================
// Daily Challenge Card
// ===============================


class DailyChallengeCard extends StatelessWidget {



  const DailyChallengeCard({

    super.key,

  });



  @override

  Widget build(BuildContext context){



    return Container(



      width:

      double.infinity,



      padding:

      const EdgeInsets.all(20),




      decoration:

      BoxDecoration(



        color:

        Colors.orange.shade100,



        borderRadius:

        BorderRadius.circular(25),



      ),




      child:


      Row(



        children:[



          const Text(

            "🎯",

            style:

            TextStyle(

              fontSize:45,

            ),

          ),




          const SizedBox(width:15),





          Expanded(


            child:

            Column(



              crossAxisAlignment:

              CrossAxisAlignment.start,



              children:[



                const Text(

                  "Gaaffii guyyaa",

                  style:

                  TextStyle(

                    fontSize:20,

                    fontWeight:

                    FontWeight.bold,

                  ),

                ),





                const SizedBox(height:5),





                const Text(

                  "Quiz tokko xumuriitii urjii argadhu ⭐",

                ),



              ],


            ),


          ),



        ],



      ),



    );



  }


}









// ===============================
// Achievement Card
// ===============================


class AchievementCard extends StatelessWidget {



  final int stars;

  final int badges;



  const AchievementCard({

    super.key,

    required this.stars,

    required this.badges,

  });





  @override

  Widget build(BuildContext context){



    return Container(



      width:

      double.infinity,



      padding:

      const EdgeInsets.all(20),



      decoration:

      BoxDecoration(



        color:

        Colors.amber.shade100,



        borderRadius:

        BorderRadius.circular(25),



      ),




      child:


      Row(



        mainAxisAlignment:

        MainAxisAlignment.spaceAround,



        children:[



          Column(



            children:[



              const Text(

                "⭐",

                style:

                TextStyle(

                  fontSize:40,

                ),

              ),



              Text(

                "$stars",

                style:

                const TextStyle(

                  fontSize:22,

                  fontWeight:

                  FontWeight.bold,

                ),

              ),



              const Text(

                "Urjii",

              ),



            ],


          ),






          Column(



            children:[



              const Text(

                "🏅",

                style:

                TextStyle(

                  fontSize:40,

                ),

              ),




              Text(

                "$badges",

                style:

                const TextStyle(

                  fontSize:22,

                  fontWeight:

                  FontWeight.bold,

                ),

              ),





              const Text(

                "Baajii",

              ),



            ],



          ),





        ],



      ),



    );



  }



}