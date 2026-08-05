import 'package:flutter/material.dart';

import '../models/lesson_category.dart';
import '../models/lesson_item.dart';



class CategoryLessonsScreen extends StatelessWidget {

  final LessonCategory category;


  const CategoryLessonsScreen({

    super.key,

    required this.category,

  });



  @override
  Widget build(BuildContext context) {


    return Scaffold(

      backgroundColor:
      const Color(0xffF7FBFF),



      appBar: AppBar(

        backgroundColor:
        category.color,

        elevation:0,


        title: Row(

          children:[


            Text(

              category.emoji,

              style:
              const TextStyle(

                fontSize:28,

              ),

            ),


            const SizedBox(width:10),


            Expanded(

              child:Text(

                category.title,

                style:
                const TextStyle(

                  fontWeight:
                  FontWeight.bold,

                ),

              ),

            )

          ],

        ),

      ),



      body: Column(

        children:[


          _categoryHeader(),



          Expanded(

            child: GridView.builder(

              padding:
              const EdgeInsets.all(16),


              itemCount:
              category.lessons.length,


              gridDelegate:
              const SliverGridDelegateWithFixedCrossAxisCount(

                crossAxisCount:2,

                childAspectRatio:.95,

                crossAxisSpacing:15,

                mainAxisSpacing:15,

              ),



              itemBuilder:(context,index){


                final lesson =
                category.lessons[index];


                return LessonCard(

                  lesson:lesson,

                );

              },

            ),

          )

        ],

      ),

    );

  }





  Widget _categoryHeader(){


    return Container(

      width:
      double.infinity,


      padding:
      const EdgeInsets.all(20),


      decoration:BoxDecoration(

        color:
        category.color.withValues(alpha:.15),


        borderRadius:
        const BorderRadius.only(

          bottomLeft:
          Radius.circular(30),

          bottomRight:
          Radius.circular(30),

        ),

      ),


      child:Column(

        children:[


          Text(

            category.subtitle,

            textAlign:
            TextAlign.center,


            style:
            const TextStyle(

              fontSize:16,

            ),

          ),



          const SizedBox(height:10),



          Text(

            "${category.lessonCount} barnoota qaba",

            style:
            const TextStyle(

              fontWeight:
              FontWeight.bold,

            ),

          )


        ],

      ),

    );


  }

}





class LessonCard extends StatelessWidget {


  final LessonItem lesson;



  const LessonCard({

    super.key,

    required this.lesson,

  });



  @override
  Widget build(BuildContext context) {


    return InkWell(

      borderRadius:
      BorderRadius.circular(25),



      onTap:(){


        Navigator.push(

          context,

          MaterialPageRoute(

            builder:(_)=>
            lesson.screen,

          ),

        );


      },



      child:Container(

        padding:
        const EdgeInsets.all(15),


        decoration:BoxDecoration(

          color:
          Colors.white,


          borderRadius:
          BorderRadius.circular(25),


          boxShadow:[

            BoxShadow(

              color:
              Colors.black.withValues(alpha:.08),

              blurRadius:8,

              offset:
              const Offset(0,4),

            )

          ]

        ),



        child:Column(

          mainAxisAlignment:
          MainAxisAlignment.center,


          children:[


            Container(

              height:65,

              width:65,


              decoration:BoxDecoration(

                color:
                lesson.color.withValues(alpha:.15),

                shape:
                BoxShape.circle,

              ),


              child:Center(

                child:Text(

                  lesson.emoji,

                  style:
                  const TextStyle(

                    fontSize:35,

                  ),

                ),

              ),

            ),



            const SizedBox(height:10),



            Text(

              lesson.title,

              textAlign:
              TextAlign.center,


              maxLines:2,


              overflow:
              TextOverflow.ellipsis,


              style:
              const TextStyle(

                fontWeight:
                FontWeight.bold,

                fontSize:15,

              ),

            ),



            const SizedBox(height:5),



            Text(

              lesson.description,

              textAlign:
              TextAlign.center,


              maxLines:2,


              overflow:
              TextOverflow.ellipsis,


              style:
              TextStyle(

                fontSize:12,

                color:
                Colors.grey.shade600,

              ),

            ),


          ],

        ),

      ),

    );

  }

}