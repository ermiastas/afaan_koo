import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../../providers/lesson_provider.dart';
import 'lesson_category_card.dart';
import '../../utils/responsive.dart';



class LessonGrid extends StatelessWidget {

  const LessonGrid({
    super.key,
  });


  @override
  Widget build(BuildContext context) {


    final lessonProvider =
        context.watch<LessonProvider>();


    final categories =
        lessonProvider.categories;


    if (categories.isEmpty) {

      return const SliverToBoxAdapter(

        child: Padding(

          padding:
              EdgeInsets.all(40),

          child: Center(

            child:
                CircularProgressIndicator(),

          ),

        ),

      );

    }



    return SliverPadding(

      padding: EdgeInsets.symmetric(
        horizontal: Responsive.pagePadding(context),
        vertical: 10,
      ),


      sliver: SliverGrid(

        delegate:
            SliverChildBuilderDelegate(

          (context,index){


            return LessonCategoryCard(

              category:
                  categories[index],

            );

          },


          childCount:
              categories.length,

        ),


        gridDelegate:
            Responsive.homeGridDelegate(
          context,

          crossAxisSpacing:18,

          mainAxisSpacing:18,

          childAspectRatio:.90,

        ),

      ),

    );

  }

}
