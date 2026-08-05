import 'package:flutter/material.dart';

import '../models/body_item.dart';


class BodyCard extends StatelessWidget {


  final BodyItem bodyItem;

  final VoidCallback onTap;


  const BodyCard({

    super.key,

    required this.bodyItem,

    required this.onTap,

  });



  @override
  Widget build(BuildContext context){


    return GestureDetector(

      onTap:onTap,


      child: Card(

        elevation:5,

        shape:RoundedRectangleBorder(

          borderRadius:BorderRadius.circular(20),

        ),


        child:Column(

          mainAxisAlignment:MainAxisAlignment.center,

          children:[


            Expanded(

              child:Image.asset(

                bodyItem.image,

                fit:BoxFit.contain,

              ),

            ),


            Text(

              bodyItem.nameOromo,

              style:const TextStyle(

                fontSize:20,

                fontWeight:FontWeight.bold,

              ),

            ),


            Text(

              bodyItem.nameEnglish,

              style:const TextStyle(

                color:Colors.grey,

              ),

            ),

          ],

        ),

      ),

    );

  }

}