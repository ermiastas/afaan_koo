import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../providers/assignment_provider.dart';



class AssignedLessonsScreen extends StatelessWidget {


  final String classId;



  const AssignedLessonsScreen({

    super.key,

    required this.classId,

  });





  @override
  Widget build(BuildContext context) {


    final assignments =

    context.watch<AssignmentProvider>()

        .getClassAssignments(classId);





    return Scaffold(


      appBar:

      AppBar(

        title:

        const Text(
          "Barnoota Ramadame 📚",
        ),

      ),





      body:

      assignments.isEmpty


      ?


      const Center(


        child:

        Column(


          mainAxisAlignment:

          MainAxisAlignment.center,



          children:[


            Icon(

              Icons.menu_book_outlined,

              size:70,

            ),



            SizedBox(height:15),



            Text(

              "Barnoonni hin ramadamne",

              style:

              TextStyle(

                fontSize:18,

              ),

            ),



          ],


        ),



      )



      :



      ListView.builder(



        padding:

        const EdgeInsets.all(16),




        itemCount:

        assignments.length,




        itemBuilder:(context,index){



          final assignment =

          assignments[index];





          return Card(



            child:

            ListTile(




              leading:

              const CircleAvatar(



                child:

                Icon(

                  Icons.book,

                ),



              ),




              title:

              Text(

                assignment.lessonTitle,

              ),




              subtitle:

              Text(

                "Guyyaa: ${assignment.assignedDate.day}/"
                "${assignment.assignedDate.month}/"
                "${assignment.assignedDate.year}",

              ),




              trailing:

              IconButton(



                icon:

                const Icon(

                  Icons.delete,

                  color:Colors.red,

                ),




                onPressed:(){



                  context

                  .read<AssignmentProvider>()

                  .removeAssignment(

                    assignment.id,

                  );



                },



              ),




            ),



          );



        },



      ),



    );


  }


}