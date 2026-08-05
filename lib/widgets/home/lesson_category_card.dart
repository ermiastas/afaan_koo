import 'package:flutter/material.dart';

import '../../models/lesson_category.dart';
import '../../screens/category_lessons_screen.dart';


class LessonCategoryCard extends StatelessWidget {

  final LessonCategory category;


  const LessonCategoryCard({
    super.key,
    required this.category,
  });


  @override
  Widget build(BuildContext context) {

    return InkWell(

      borderRadius:
          BorderRadius.circular(25),


      onTap: () {

        Navigator.push(

          context,

          MaterialPageRoute(

            builder: (_) => CategoryLessonsScreen(
              category: category,
            ),

          ),

        );

      },


      child: Container(

        padding:
            const EdgeInsets.all(16),


        decoration: BoxDecoration(

          color: Colors.white,


          borderRadius:
              BorderRadius.circular(25),


          boxShadow: [

            BoxShadow(

              color:
                  Colors.black.withValues(alpha:.08),

              blurRadius: 10,

              offset:
                  const Offset(0, 5),

            ),

          ],

        ),



        child: Column(

          mainAxisAlignment:
              MainAxisAlignment.center,


          children: [

            Container(

              width: 70,

              height: 70,


              decoration: BoxDecoration(

                color:
                    category.color.withValues(alpha:.15),

                shape:
                    BoxShape.circle,

              ),


              child: Center(

                child: Text(

                  category.emoji,

                  style:
                      const TextStyle(

                    fontSize: 40,

                  ),

                ),

              ),

            ),



            const SizedBox(height: 12),



            Text(

              category.title,

              textAlign:
                  TextAlign.center,


              maxLines: 2,

              overflow:
                  TextOverflow.ellipsis,


              style:
                  const TextStyle(

                fontWeight:
                    FontWeight.bold,

                fontSize: 16,

              ),

            ),



            const SizedBox(height: 5),



            Text(

              "${category.lessons.length} barnoota",

              style:
                  TextStyle(

                color:
                    Colors.grey.shade600,

                fontSize: 12,

              ),

            ),

          ],

        ),

      ),

    );

  }

}
