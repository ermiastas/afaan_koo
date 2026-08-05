import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../models/student.dart';

import '../providers/progress_provider.dart';
import '../providers/reward_provider.dart';

import 'give_reward_screen.dart';



class StudentProfileScreen extends StatelessWidget {


  final Student student;



  const StudentProfileScreen({

    super.key,

    required this.student,

  });






  @override
  Widget build(BuildContext context) {



    final progress =
        context.watch<ProgressProvider>();


    final reward =
        context.watch<RewardProvider>();




    final studentRewards =

    reward.studentRewards

        .where(

          (r) => r.studentId == student.id,

    )

        .toList();





    return Scaffold(



      appBar:

      AppBar(

        title:

        Text(

          student.name,

        ),

      ),





      body:

      SingleChildScrollView(



        padding:

        const EdgeInsets.all(16),




        child:

        Column(


          children:[






            // =========================
            // STUDENT HEADER
            // =========================



            Container(


              width:

              double.infinity,



              padding:

              const EdgeInsets.all(20),




              decoration:

              BoxDecoration(


                color:

                Colors.white,



                borderRadius:

                BorderRadius.circular(25),



              ),




              child:

              Column(



                children:[



                  const CircleAvatar(



                    radius:45,



                    child:

                    Icon(

                      Icons.person,

                      size:50,

                    ),



                  ),




                  const SizedBox(height:15),





                  Text(


                    student.name,



                    style:

                    const TextStyle(

                      fontSize:24,

                      fontWeight:

                      FontWeight.bold,

                    ),



                  ),





                  const SizedBox(height:10),





                  Text(


                    "⭐ ${student.xp} XP",



                    style:

                    const TextStyle(

                      fontSize:18,

                    ),



                  ),





                  const SizedBox(height:15),





                  // =====================
                  // GIVE REWARD BUTTON
                  // =====================


                  SizedBox(


                    width:

                    double.infinity,



                    child:

                    ElevatedButton.icon(



                      icon:

                      const Icon(

                        Icons.card_giftcard,

                      ),




                      label:

                      const Text(

                        "Badhaasa Kenni 🎁",

                      ),




                      onPressed:(){



                        Navigator.push(



                          context,



                          MaterialPageRoute(



                            builder:(_)=>

                            GiveRewardScreen(



                              studentId:

                              student.id,



                            ),



                          ),



                        );



                      },



                    ),



                  ),




                ],


              ),



            ),






            const SizedBox(height:20),






            // =========================
            // STATISTICS
            // =========================



            Row(



              children:[




                Expanded(



                  child:

                  _statCard(


                    "📚",

                    "${student.completedLessons}",

                    "Barnoota",



                  ),


                ),





                const SizedBox(width:10),





                Expanded(



                  child:

                  _statCard(


                    "⭐",

                    "${student.xp}",

                    "XP",



                  ),


                ),





                const SizedBox(width:10),





                Expanded(



                  child:

                  _statCard(


                    "🏆",

                    "${reward.stars}",

                    "Stars",



                  ),


                ),




              ],



            ),






            const SizedBox(height:20),






            // =========================
            // PROGRESS
            // =========================



            Card(



              child:

              Padding(



                padding:

                const EdgeInsets.all(20),




                child:

                Column(



                  crossAxisAlignment:

                  CrossAxisAlignment.start,




                  children:[



                    const Text(



                      "Guddina Barnootaa 📈",



                      style:

                      TextStyle(

                        fontSize:20,

                        fontWeight:

                        FontWeight.bold,

                      ),



                    ),





                    const SizedBox(height:15),






                    LinearProgressIndicator(



                      value:

                      student.progress,



                      minHeight:12,



                    ),






                    const SizedBox(height:8),






                    Text(



                      "${(student.progress * 100).toInt()}% xumurame",



                    ),




                  ],



                ),



              ),



            ),







            const SizedBox(height:20),






            // =========================
            // ACTIVITY
            // =========================



            Card(



              child:

              Column(



                children:[




                  const ListTile(



                    leading:

                    Icon(

                      Icons.check_circle,

                      color:

                      Colors.green,

                    ),




                    title:

                    Text(

                      "Qubee barate",

                    ),




                  ),






                  const ListTile(



                    leading:

                    Icon(

                      Icons.star,

                      color:

                      Colors.amber,

                    ),




                    title:

                    Text(

                      "Badhaasa argate",

                    ),




                  ),






                  ListTile(



                    leading:

                    const Icon(

                      Icons.menu_book,

                    ),





                    title:

                    Text(

                      "${progress.completedCount} barnoota xumurame",

                    ),



                  ),



                ],



              ),



            ),






            const SizedBox(height:20),







            // =========================
            // REWARD HISTORY
            // =========================



            if(studentRewards.isNotEmpty)

            Card(



              child:

              Padding(



                padding:

                const EdgeInsets.all(16),




                child:

                Column(



                  crossAxisAlignment:

                  CrossAxisAlignment.start,




                  children:[



                    const Text(



                      "Badhaasa Argate 🎁",



                      style:

                      TextStyle(

                        fontSize:20,

                        fontWeight:

                        FontWeight.bold,

                      ),



                    ),





                    const SizedBox(height:10),





                    ...studentRewards.map(



                          (r)=>ListTile(



                        leading:

                        const Icon(

                          Icons.emoji_events,

                          color:

                          Colors.amber,

                        ),





                        title:

                        Text(

                          r.title,

                        ),




                        subtitle:

                        Text(

                          "${r.description}\n+${r.xp} XP ⭐ ${r.stars}",

                        ),




                        trailing:

                        Text(

                          r.badge,

                        ),




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








  Widget _statCard(


      String icon,


      String value,


      String title,


      ){



    return Container(



      padding:

      const EdgeInsets.all(12),




      decoration:

      BoxDecoration(



        color:

        Colors.white,



        borderRadius:

        BorderRadius.circular(18),



      ),




      child:

      Column(



        children:[



          Text(


            icon,



            style:

            const TextStyle(

              fontSize:25,

            ),



          ),





          Text(



            value,



            style:

            const TextStyle(

              fontSize:18,

              fontWeight:

              FontWeight.bold,

            ),



          ),





          Text(title),




        ],



      ),



    );



  }



}