import 'package:flutter/material.dart';

import '../../models/brush_type.dart';


class BrushPicker extends StatelessWidget {

  final BrushType selectedBrush;

  final Function(BrushType) onBrushSelected;


  const BrushPicker({

    super.key,

    required this.selectedBrush,

    required this.onBrushSelected,

  });



  @override
  Widget build(BuildContext context) {


    final brushes = [

      {
        "type": BrushType.normal,
        "emoji": "🖌️",
        "name": "Idilee"
      },

      {
        "type": BrushType.glow,
        "emoji": "✨",
        "name": "Ifa"
      },

      {
        "type": BrushType.rainbow,
        "emoji": "🌈",
        "name": "Rooba"
      },

      {
        "type": BrushType.magic,
        "emoji": "⭐",
        "name": "Ajaa'iba"
      },

    ];



    return SizedBox(

      height: 75,


      child: ListView.builder(

        scrollDirection: Axis.horizontal,


        itemCount: brushes.length,


        itemBuilder: (context,index){


          final brush =
              brushes[index];


          final type =
              brush["type"] as BrushType;



          final selected =
              selectedBrush == type;



          return GestureDetector(


            onTap: () {

              onBrushSelected(type);

            },


            child: AnimatedContainer(

              duration:
                  const Duration(milliseconds:300),


              margin:
                  const EdgeInsets.all(8),


              padding:
                  const EdgeInsets.symmetric(
                    horizontal:14,
                    vertical:8,
                  ),


              decoration: BoxDecoration(

                color: selected
                    ? Colors.blue.shade100
                    : Colors.white,


                borderRadius:
                    BorderRadius.circular(20),


                border: Border.all(

                  width: selected ? 3 : 1,

                  color: selected
                      ? Colors.blue
                      : Colors.grey.shade300,

                ),

              ),


              child: Column(

                mainAxisAlignment:
                    MainAxisAlignment.center,


                children: [


                  Text(

                    brush["emoji"] as String,

                    style:
                        const TextStyle(
                          fontSize:26,
                        ),

                  ),


                  Text(

                    brush["name"] as String,

                    style:
                        const TextStyle(
                          fontSize:12,
                        ),

                  ),


                ],

              ),

            ),

          );

        },

      ),

    );

  }

}