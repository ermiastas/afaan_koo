import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../models/class_room.dart';
import '../providers/class_provider.dart';

import 'add_student_screen.dart';
import 'class_analytics_screen.dart';
import 'student_profile_screen.dart';
import 'assign_lesson_screen.dart';
import 'assigned_lessons_screen.dart';



class ClassDetailsScreen extends StatelessWidget {

  final ClassRoom classroom;


  const ClassDetailsScreen({

    super.key,

    required this.classroom,

  });



  @override
  Widget build(BuildContext context) {


    final provider =
        context.watch<ClassProvider>();



    return Scaffold(


      appBar: AppBar(

        title: Text(
          classroom.name,
        ),

      ),




      floatingActionButton:

      FloatingActionButton.extended(


        icon:

        const Icon(
          Icons.person_add,
        ),



        label:

        const Text(
          "Barataa",
        ),




        onPressed: () {


          Navigator.push(

            context,

            MaterialPageRoute(

              builder: (_) =>
                  const AddStudentScreen(),

            ),

          );


        },

      ),





      body:

      Padding(


        padding:

        const EdgeInsets.all(16),



        child:

        Column(


          children: [





            // =========================
            // CLASS SUMMARY
            // =========================


            Card(


              elevation: 3,


              child:

              Padding(

                padding:

                const EdgeInsets.all(20),



                child:

                Row(



                  mainAxisAlignment:

                  MainAxisAlignment.spaceAround,



                  children: [



                    _stat(

                      "👧",

                      provider.totalStudents.toString(),

                      "Barattoota",

                    ),




                    _stat(

                      "📈",

                      "${(provider.averageProgress * 100).toInt()}%",

                      "Guddina",

                    ),




                    _stat(

                      "🏫",

                      classroom.grade,

                      "Kutaa",

                    ),



                  ],


                ),


              ),


            ),





            const SizedBox(height:16),






            // =========================
            // ASSIGN LESSON BUTTON
            // =========================


            SizedBox(

              width:

              double.infinity,



              child:

              ElevatedButton.icon(


                icon:

                const Icon(
                  Icons.assignment,
                ),



                label:

                const Text(
                  "Barnoota Ramadi 📚",
                ),




                onPressed: () {


                  Navigator.push(


                    context,


                    MaterialPageRoute(


                      builder: (_) =>

                      AssignLessonScreen(

                        classId:

                        classroom.id,

                      ),


                    ),


                  );


                },


              ),


            ),





            const SizedBox(height:10),





            // =========================
            // ASSIGNED LESSONS BUTTON
            // =========================


            SizedBox(

              width:

              double.infinity,



              child:

              OutlinedButton.icon(


                icon:

                const Icon(
                  Icons.list_alt,
                ),




                label:

                const Text(
                  "Barnoota Ramadame Ilaali",
                ),

                


                onPressed: () {


                  Navigator.push(


                    context,


                    MaterialPageRoute(


                      builder: (_) =>

                      AssignedLessonsScreen(

                        classId:

                        classroom.id,

                      ),


                    ),


                  );


                },


              ),


            ),


          const SizedBox(height:10),

SizedBox(

width: double.infinity,

child: ElevatedButton.icon(

icon:

const Icon(
Icons.analytics,
),


label:

const Text(
"Gabaasa Ilaali 📊",
),



onPressed:(){


Navigator.push(

context,


MaterialPageRoute(

builder: (_) =>

ClassAnalyticsScreen(

classId:

classroom.id,

),

),

);


},


),

),


            const SizedBox(height:16),





            // =========================
            // STUDENTS
            // =========================


            Expanded(


              child:

              ListView.builder(



                itemCount:

                provider.students.length,



                itemBuilder:(context,index){



                  final student =

                  provider.students[index];






                  return Card(



                    elevation:2,



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

                      Column(



                        crossAxisAlignment:

                        CrossAxisAlignment.start,



                        children:[




                          Text(

                            "⭐ ${student.xp} XP",

                          ),




                          const SizedBox(height:6),




                          LinearProgressIndicator(

                            value:

                            student.progress,

                          ),



                        ],


                      ),




                      trailing:

                      Text(

                        "${(student.progress * 100).toInt()}%",

                      ),




                      onTap:(){



                        Navigator.push(



                          context,



                          MaterialPageRoute(



                            builder: (_) =>

                            StudentProfileScreen(

                              student:

                              student,

                            ),



                          ),



                        );


                      },



                    ),



                  );


                },



              ),


            ),



          ],


        ),


      ),


    );


  }







  Widget _stat(

      String emoji,

      String value,

      String title,

      ) {


    return Column(


      children: [


        Text(

          emoji,

          style:

          const TextStyle(

            fontSize:28,

          ),

        ),



        const SizedBox(height:8),




        Text(

          value,

          style:

          const TextStyle(

            fontSize:22,

            fontWeight:

            FontWeight.bold,

          ),

        ),




        Text(

          title,

        ),


      ],


    );


  }


}