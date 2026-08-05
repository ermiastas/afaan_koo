import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../providers/class_provider.dart';
import '../providers/teacher_provider.dart';
import '../screens/teacher_classes_screen.dart';



class TeacherDashboardScreen extends StatelessWidget {


  const TeacherDashboardScreen({
    super.key,
  });





  @override
  Widget build(BuildContext context) {



    final classroom =
        context.watch<ClassProvider>();


    final teacher =
        context.watch<TeacherProvider>()
            .teacher;




    return Scaffold(



      appBar: AppBar(

        title:

        const Text(
          "Daashboordii Barsiisaa 👩‍🏫",
        ),

        centerTitle:true,

      ),





      backgroundColor:
      const Color(0xffF7FBFF),






      body:


      Padding(


        padding:
        const EdgeInsets.all(16),




        child:

        Column(



          crossAxisAlignment:
          CrossAxisAlignment.start,



          children:[




            // ======================
            // Teacher Profile
            // ======================


            _teacherCard(
              teacher?.name ?? "Barsiisaa",
              teacher?.school ?? "Mana Barumsaa",
            ),






            const SizedBox(height:20),






            // ======================
            // Summary
            // ======================


            _summaryCard(

              classroom,

            ),





            const SizedBox(height:20),






            // ======================
            // Management Actions
            // ======================


            Row(

              children:[


                Expanded(

                  child:
                  _actionCard(

                    icon:
                    Icons.class_,

                    title:
                    "Kutaalee",
onTap:(){

Navigator.push(

context,

MaterialPageRoute(

builder:(_)=>
const TeacherClassesScreen(),

),

);

},
                  ),

                ),



                const SizedBox(width:10),





                Expanded(

                  child:
                  _actionCard(

                    icon:
                    Icons.assignment,

                    title:
                    "Ramaddii",

                    onTap:(){


                    },

                  ),

                ),


              ],


            ),





            const SizedBox(height:10),





            Row(

              children:[


                Expanded(

                  child:
                  _actionCard(

                    icon:
                    Icons.analytics,

                    title:
                    "Guddina",

                    onTap:(){


                    },

                  ),

                ),





                const SizedBox(width:10),





                Expanded(

                  child:
                  _actionCard(

                    icon:
                    Icons.card_giftcard,

                    title:
                    "Badhaasa",

                    onTap:(){


                    },

                  ),

                ),



              ],


            ),






            const SizedBox(height:20),







            const Text(

              "Barattoota koo 👧👦",

              style:

              TextStyle(

                fontSize:20,

                fontWeight:
                FontWeight.bold,

              ),

            ),






            const SizedBox(height:10),







            Expanded(



              child:


              ListView.builder(


                itemCount:

                classroom.students.length,



                itemBuilder:


                (context,index){



                  final student =
                      classroom.students[index];





                  return Card(




                    elevation:2,



                    shape:

                    RoundedRectangleBorder(

                      borderRadius:
                      BorderRadius.circular(18),

                    ),





                    child:


                    ListTile(





                      leading:


                      const CircleAvatar(

                        child:

                        Icon(

                          Icons.person,

                        ),

                      ),






                      title:

                      Text(

                        student.name,

                      ),





                      subtitle:


                      Text(

                        "📚 ${student.completedLessons} barnoota   ⭐ ${student.xp} XP",

                      ),





                      trailing:


                      Column(

                        mainAxisAlignment:
                        MainAxisAlignment.center,

                        children:[


                          Text(

                            "${(student.progress*100).toInt()}%",

                            style:

                            const TextStyle(

                              fontWeight:
                              FontWeight.bold,

                            ),

                          ),



                        ],

                      ),





                    ),



                  );



                },


              ),


            )




          ],


        ),


      ),


    );

  }








  Widget _teacherCard(

      String name,

      String school,

      ){


    return Container(


      padding:
      const EdgeInsets.all(18),



      decoration:

      BoxDecoration(


        color:
        Colors.white,


        borderRadius:
        BorderRadius.circular(25),


      ),




      child:

      Row(

        children:[



          const CircleAvatar(

            radius:28,

            child:

            Icon(

              Icons.school,

              size:30,

            ),

          ),




          const SizedBox(width:15),




          Column(

            crossAxisAlignment:
            CrossAxisAlignment.start,

            children:[


              Text(

                name,

                style:

                const TextStyle(

                  fontSize:20,

                  fontWeight:
                  FontWeight.bold,

                ),

              ),




              Text(

                school,

              ),


            ],

          )


        ],


      ),


    );

  }







  Widget _summaryCard(
      ClassProvider classroom
      ){



    return Container(


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

      Row(

        mainAxisAlignment:
        MainAxisAlignment.spaceAround,



        children:[



          _item(

            "👧 Barattoota",

            "${classroom.totalStudents}",

          ),




          _item(

            "📈 Giddugaleessa",

            "${(classroom.averageProgress*100).toInt()}%",

          ),



        ],


      ),


    );

  }









  Widget _actionCard({

    required IconData icon,

    required String title,

    required VoidCallback onTap,

  }){


    return InkWell(


      onTap:onTap,


      child:

      Container(


        padding:
        const EdgeInsets.all(15),



        decoration:

        BoxDecoration(


          color:
          Colors.white,


          borderRadius:
          BorderRadius.circular(20),


        ),




        child:

        Column(

          children:[



            Icon(

              icon,

              size:30,

            ),




            const SizedBox(height:8),




            Text(title),


          ],


        ),


      ),


    );


  }









  Widget _item(

      String title,

      String value

      ){



    return Column(

      children:[



        Text(

          value,

          style:

          const TextStyle(

            fontSize:22,

            fontWeight:
            FontWeight.bold,

          ),

        ),



        Text(title),


      ],


    );

  }


}