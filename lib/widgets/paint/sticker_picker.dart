import 'package:flutter/material.dart';

import '../../data/sticker_data.dart';

import '../../models/sticker_item.dart';



class StickerPicker extends StatelessWidget {


  final Function(StickerItem) onStickerSelected;


  const StickerPicker({

    super.key,

    required this.onStickerSelected,

  });



  @override
  Widget build(BuildContext context) {


    return SizedBox(

      height:70,


      child: ListView.builder(

        scrollDirection:
            Axis.horizontal,


        itemCount:
            stickers.length,


        itemBuilder:(context,index){


          final sticker =
              stickers[index];



          return GestureDetector(

            onTap:(){

              onStickerSelected(
                sticker,
              );

            },


            child: Container(

              margin:
                  const EdgeInsets.all(8),


              padding:
                  const EdgeInsets.all(8),


              decoration:BoxDecoration(

                color:Colors.white,

                borderRadius:
                    BorderRadius.circular(20),

                boxShadow:[

                  BoxShadow(

                    blurRadius:8,

                    color:
                    Colors.black12,

                  )

                ],

              ),


              child:Text(

                sticker.emoji,

                style:
                const TextStyle(

                  fontSize:32,

                ),

              ),

            ),

          );

        },

      ),

    );

  }

}