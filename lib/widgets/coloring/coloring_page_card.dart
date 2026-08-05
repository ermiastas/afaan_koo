import 'package:flutter/material.dart';

import '../../models/coloring_page.dart';


class ColoringPageCard extends StatefulWidget {

  final ColoringPage page;

  final VoidCallback onTap;


  const ColoringPageCard({

    super.key,

    required this.page,

    required this.onTap,

  });



  @override
  State<ColoringPageCard> createState() =>
      _ColoringPageCardState();

}



class _ColoringPageCardState
    extends State<ColoringPageCard>
    with SingleTickerProviderStateMixin {


  late AnimationController _controller;


  late Animation<double> _scale;



  @override
  void initState(){

    super.initState();


    _controller =
        AnimationController(

      vsync: this,

      duration:
      const Duration(milliseconds:150),

    );


    _scale =
        Tween<double>(

          begin:1,

          end:.94,

        ).animate(

          CurvedAnimation(

            parent:_controller,

            curve:Curves.easeOut,

          ),

        );

  }



  @override
  void dispose(){

    _controller.dispose();

    super.dispose();

  }



  Future<void> _tap() async {


    await _controller.forward();

    await _controller.reverse();


    widget.onTap();

  }




  @override
  Widget build(BuildContext context){


    return ScaleTransition(

      scale:_scale,


      child: GestureDetector(

        onTap:_tap,


        child: Container(

          decoration:BoxDecoration(

            color:Colors.white,


            borderRadius:
            BorderRadius.circular(24),


            boxShadow:[

              BoxShadow(

                color:
                Colors.black.withValues(alpha: .08),

                blurRadius:12,

                offset:
                const Offset(0,6),

              ),

            ],

          ),


          child:Padding(

            padding:
            const EdgeInsets.all(12),


            child:Column(

              mainAxisAlignment:
              MainAxisAlignment.center,


              children:[


                Expanded(

                  child:ClipRRect(

                    borderRadius:
                    BorderRadius.circular(18),


                    child:Image.asset(

                      widget.page.image,


                      fit:
                      BoxFit.contain,


                      errorBuilder:
                      (_,__,___){

                        return Center(

                          child:Text(

                            widget.page.emoji,

                            style:
                            const TextStyle(

                              fontSize:55,

                            ),

                          ),

                        );

                      },

                    ),

                  ),

                ),



                const SizedBox(height:10),



                Text(

                  widget.page.titleOromo,


                  textAlign:
                  TextAlign.center,


                  style:
                  const TextStyle(

                    fontWeight:
                    FontWeight.bold,

                    fontSize:16,

                  ),

                ),



                const SizedBox(height:5),



                Row(

                  mainAxisAlignment:
                  MainAxisAlignment.center,

                  children:[


                    Text(

                      widget.page.emoji,

                      style:
                      const TextStyle(

                        fontSize:18,

                      ),

                    ),


                    const SizedBox(width:5),


                    Text(

                      "+${widget.page.rewardXP} XP",

                      style:
                      TextStyle(

                        color:
                        Colors.orange.shade700,

                        fontWeight:
                        FontWeight.bold,

                        fontSize:12,

                      ),

                    ),

                  ],

                ),


              ],

            ),

          ),

        ),

      ),

    );


  }


}