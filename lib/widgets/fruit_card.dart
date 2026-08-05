import 'package:flutter/material.dart';

import '../models/fruit_item.dart';


class FruitCard extends StatelessWidget {


  final FruitItem fruit;

  final VoidCallback onTap;


  const FruitCard({

    super.key,

    required this.fruit,

    required this.onTap,

  });



  @override
  Widget build(BuildContext context){


    return GestureDetector(

      onTap:onTap,


      child:Card(

        elevation:5,

        shape:RoundedRectangleBorder(

          borderRadius:BorderRadius.circular(20),

        ),


        child:Column(

          mainAxisAlignment:MainAxisAlignment.center,

          children:[


            Expanded(

              child:Image.asset(

                fruit.image,

                fit:BoxFit.contain,

              ),

            ),



            Text(

              fruit.nameOromo,

              style:const TextStyle(

                fontSize:20,

                fontWeight:FontWeight.bold,

              ),

            ),


            Text(

              fruit.nameEnglish,

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