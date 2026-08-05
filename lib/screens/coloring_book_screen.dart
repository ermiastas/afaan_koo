import 'package:flutter/material.dart';

class ColoringBookScreen extends StatefulWidget {

  const ColoringBookScreen({
    super.key,
  });


  @override
  State<ColoringBookScreen> createState() =>
      _ColoringBookScreenState();
}



class _ColoringBookScreenState
    extends State<ColoringBookScreen> {


  final List<Color> colors = [

    Colors.red,
    Colors.orange,
    Colors.yellow,
    Colors.green,
    Colors.blue,
    Colors.purple,
    Colors.pink,
    Colors.brown,
    Colors.black,
    Colors.white,

  ];


  Color selectedColor = Colors.red;



  final List<String> drawings = [

    "assets/coloring/apple.png",
    "assets/coloring/lion.png",
    "assets/coloring/tree.png",
    "assets/coloring/house.png",
    "assets/coloring/bird.png",
    "assets/coloring/banana.png",
    "assets/coloring/cow.png",
    "assets/coloring/ball.png",

    "assets/coloring/a.png",
    "assets/coloring/b.png",
    "assets/coloring/c.png",
    "assets/coloring/d.png",
    "assets/coloring/e.png",

  ];



  int current = 0;



  @override
  Widget build(BuildContext context) {


    return Scaffold(

      backgroundColor:
      const Color(0xffEAF7FF),



      appBar: AppBar(

        title:
        const Text(
          "🎨 Halluu Dibuu",
        ),

        centerTitle:true,

      ),



      body: Column(

        children:[



          const SizedBox(height:20),



          Text(

            "Halluu filadhu, suuraa bareechi! 🌈",

            style:
            Theme.of(context)
                .textTheme
                .titleMedium,

          ),



          const SizedBox(height:10),



          Text(

            "${current + 1} / ${drawings.length}",

            style:
            const TextStyle(
              fontWeight:FontWeight.bold,
            ),

          ),



          Expanded(

            child:

            Container(

              margin:
              const EdgeInsets.all(20),


              padding:
              const EdgeInsets.all(20),



              decoration:
              BoxDecoration(

                color:
                Colors.white.withValues(alpha: .85),

                borderRadius:
                BorderRadius.circular(30),

              ),



              child:

              Image.asset(

                drawings[current],


                fit:
                BoxFit.contain,


                errorBuilder:
                (context,error,stack){

                  return const Column(

                    mainAxisAlignment:
                    MainAxisAlignment.center,

                    children:[

                      Text(
                        "🖼️",
                        style:
                        TextStyle(
                          fontSize:80,
                        ),
                      ),

                      Text(
                        "Suuraa hin argamne",
                      ),

                    ],

                  );

                },

              ),

            ),

          ),



          SizedBox(

            height:80,


            child:

            ListView.builder(

              scrollDirection:
              Axis.horizontal,


              itemCount:
              colors.length,


              itemBuilder:
              (_,index){


                final color =
                colors[index];


                return GestureDetector(

                  onTap:(){

                    setState((){

                      selectedColor=color;

                    });

                  },


                  child:

                  AnimatedContainer(

                    duration:
                    const Duration(
                      milliseconds:300,
                    ),


                    margin:
                    const EdgeInsets.all(10),


                    width:55,


                    decoration:
                    BoxDecoration(

                      color:color,


                      shape:
                      BoxShape.circle,


                      border:
                      Border.all(

                        width:
                        selectedColor==color
                            ? 5
                            : 2,


                        color:
                        Colors.white,

                      ),

                    ),

                  ),

                );

              },

            ),

          ),



          Padding(

            padding:
            const EdgeInsets.all(15),


            child:

            Row(

              children:[



                Expanded(

                  child:

                  ElevatedButton.icon(

                    onPressed:

                    current==0

                    ? null

                    :

                    (){

                      setState((){

                        current--;

                      });

                    },


                    icon:
                    const Icon(
                      Icons.arrow_back,
                    ),

                    label:
                    const Text(
                      "Duubatti",
                    ),

                  ),

                ),



                const SizedBox(
                  width:15,
                ),



                Expanded(

                  child:

                  ElevatedButton.icon(

                    onPressed:

                    current ==
                    drawings.length-1

                    ?

                    (){

                      _complete();

                    }


                    :

                    (){

                      setState((){

                        current++;

                      });

                    },


                    icon:
                    const Icon(
                      Icons.arrow_forward,
                    ),


                    label:
                    Text(

                      current ==
                      drawings.length-1

                      ?

                      "Xumuri ⭐"

                      :

                      "Itti Aanu",

                    ),

                  ),

                ),



              ],

            ),

          ),


        ],

      ),

    );

  }



  void _complete(){

    showDialog(

      context:context,

      builder:(context){

        return AlertDialog(

          title:
          const Text(
            "🎉 Galatoomi!",
          ),


          content:
          const Text(
            "Suuraalee hunda bareechite.",
          ),


          actions:[

            TextButton(

              onPressed:(){

                Navigator.pop(context);

              },

              child:
              const Text(
                "Tole",
              ),

            )

          ],

        );

      },

    );

  }


}