import 'package:flutter/material.dart';

import '../models/number_item.dart';
import '../services/audio_service.dart';

import '../widgets/counting_widget.dart';
import '../widgets/lesson_complete_button.dart';

import '../data/lesson_ids.dart';



class NumberDetailScreen extends StatefulWidget {


  final List<NumberItem> numbers;

  final int initialIndex;



  const NumberDetailScreen({

    super.key,

    required this.numbers,

    required this.initialIndex,

  });



  @override
  State<NumberDetailScreen> createState()

      => _NumberDetailScreenState();

}







class _NumberDetailScreenState

    extends State<NumberDetailScreen> {



  final AudioService audioService =

      AudioService();



  late int currentIndex;





  @override
  void initState(){


    super.initState();


    currentIndex =
        widget.initialIndex;


  }







  NumberItem get numberItem =>

      widget.numbers[currentIndex];







  void playSound(String sound){


    if(sound.isEmpty){

      return;

    }



    audioService.playSound(sound);


  }







  void previousNumber(){


    if(currentIndex == 0){

      return;

    }



    setState((){

      currentIndex--;

    });


  }







  void nextNumber(){


    if(currentIndex ==
        widget.numbers.length - 1){

      return;

    }



    setState((){

      currentIndex++;

    });


  }







  @override
  void dispose(){


    audioService.dispose();


    super.dispose();


  }









  @override
  Widget build(BuildContext context){



    return Scaffold(



      appBar:

      AppBar(



        title:

        Text(

          "Lakkoofsa ${numberItem.number}",

        ),



        centerTitle:true,


      ),







      body:

      SingleChildScrollView(



        padding:

        const EdgeInsets.all(20),




        child:

        Column(



          children:[






            Text(



              numberItem.number.toString(),



              style:

              const TextStyle(



                fontSize:100,

                fontWeight:

                FontWeight.bold,


              ),



            ),







            const SizedBox(height:20),







            CountingWidget(


              count:

              numberItem.number,


              icon:

              Icons.star,


              color:

              Colors.amber,


              size:

              28,


            ),







            const SizedBox(height:20),







            Image.asset(



              numberItem.image,



              height:200,



              errorBuilder:

              (context,error,stack){



                return const Icon(



                  Icons.image_not_supported,


                  size:100,


                );


              },


            ),







            const SizedBox(height:20),







            Text(



              numberItem.nameOromo,



              style:

              const TextStyle(



                fontSize:35,

                fontWeight:

                FontWeight.bold,


              ),


            ),







            Text(



              numberItem.nameEnglish,



              style:

              const TextStyle(



                fontSize:22,

                color:

                Colors.grey,


              ),


            ),







            const SizedBox(height:20),






            Text(



              "Raji:\n"

              "Lakkoofsa kana haa barannu! "

              "Lakkaa'uu shaakali.",



              textAlign:

              TextAlign.center,



              style:

              const TextStyle(



                fontSize:18,

                fontWeight:

                FontWeight.w600,


              ),


            ),







            const SizedBox(height:20),







            ElevatedButton.icon(



              onPressed:(){


                playSound(

                  numberItem.sound,

                );


              },



              icon:

              const Icon(

                Icons.volume_up,

              ),



              label:

              const Text(

                "Lakkoofsa dhaggeeffadhu",

              ),



            ),







            const SizedBox(height:30),







            if(numberItem.examples.isNotEmpty)...[



              const Align(



                alignment:

                Alignment.centerLeft,



                child:

                Text(



                  "Fakkeenya",



                  style:

                  TextStyle(



                    fontSize:24,

                    fontWeight:

                    FontWeight.bold,


                  ),


                ),



              ),





              const SizedBox(height:10),





              ...numberItem.examples.map(



                (example){



                  return Card(



                    child:

                    ListTile(



                      leading:

                      const Icon(

                        Icons.star,

                        color:

                        Colors.orange,

                      ),



                      title:

                      Text(

                        example,

                        style:

                        const TextStyle(

                          fontSize:20,

                        ),

                      ),


                    ),


                  );


                },


              ),



            ],







            const SizedBox(height:30),







            // ==========================
            // COMPLETE LESSON
            // ==========================


            LessonCompleteButton(



              lessonId:

              LessonIds.number,



            ),







            const SizedBox(height:30),







            Row(



              children:[





                Expanded(



                  child:

                  ElevatedButton.icon(



                    onPressed:

                    currentIndex > 0

                    ? previousNumber

                    : null,



                    icon:

                    const Icon(

                      Icons.arrow_back,

                    ),



                    label:

                    const Text(

                      "Dura",

                    ),



                  ),


                ),







                const SizedBox(width:20),







                Expanded(



                  child:

                  ElevatedButton.icon(



                    onPressed:

                    currentIndex <
                    widget.numbers.length - 1

                    ? nextNumber

                    : null,



                    icon:

                    const Icon(

                      Icons.arrow_forward,

                    ),



                    label:

                    const Text(

                      "Itti fufi",

                    ),



                  ),


                ),



              ],



            ),







          ],



        ),



      ),



    );



  }


}