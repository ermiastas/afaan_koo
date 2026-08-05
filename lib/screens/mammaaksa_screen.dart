import 'package:flutter/material.dart';
import 'package:provider/provider.dart';


import '../services/audio_service.dart';
import '../providers/mammaaksa_provider.dart';
import '../widgets/mammaaksa_card.dart';
import '../widgets/lesson_complete_button.dart';
import '../data/lesson_ids.dart';



class MammaaksaScreen extends StatefulWidget {


  const MammaaksaScreen({
    super.key,
  });



  @override
  State<MammaaksaScreen> createState() =>
      _MammaaksaScreenState();

}





class _MammaaksaScreenState
extends State<MammaaksaScreen>
with SingleTickerProviderStateMixin {



  final PageController pageController =
      PageController();



  final AudioService audioService =
      AudioService();



  late AnimationController animationController;


  late Animation<double> scaleAnimation;



  bool showReward = false;



  @override
  void initState(){

    super.initState();


    animationController =
        AnimationController(

          vsync: this,

          duration:
          const Duration(
            milliseconds:600,
          ),

        );


    scaleAnimation =
        CurvedAnimation(

          parent:
          animationController,

          curve:
          Curves.elasticOut,

        );

  }





  void showXP(){

    setState((){

      showReward = true;

    });



    animationController.forward(
      from:0,
    );



    Future.delayed(

      const Duration(seconds:2),

          (){

        if(mounted){

          setState((){

            showReward=false;

          });

        }

      },

    );

  }





  @override
  Widget build(BuildContext context){



    return Scaffold(


      backgroundColor:
      const Color(0xfffff8e7),



      appBar:

      AppBar(

        title:
        const Text(
          "🗣️ Mammaaksa Koo",
        ),


        centerTitle:true,


        backgroundColor:
        Colors.brown,


        foregroundColor:
        Colors.white,


      ),





      body:


      Consumer<MammaaksaProvider>(



        builder:

        (
            context,
            provider,
            child
        ){



          return Stack(



            children:[



              Column(

                children:[



                  // Raji Header

                  Container(

                    margin:
                    const EdgeInsets.all(16),


                    padding:
                    const EdgeInsets.all(18),



                    decoration:

                    BoxDecoration(

                      color:
                      Colors.brown.shade100,


                      borderRadius:
                      BorderRadius.circular(25),

                    ),



                    child:

                    const Row(


                      children:[


                        CircleAvatar(

                          radius:30,

                          child:Text(
                            "🤖",
                            style:
                            TextStyle(
                              fontSize:24,
                            ),
                          ),

                        ),



                        SizedBox(
                          width:15,
                        ),



                        Expanded(

                          child:Text(

                            "Raji:\n"
                                "Mammaaksa Oromoo irraa "
                                "ogummaa haa barannu!",


                            style:
                            TextStyle(

                              fontSize:17,

                              fontWeight:
                              FontWeight.w600,

                            ),

                          ),

                        )

                      ],

                    ),

                  ),






                  Expanded(

                    child:

                    PageView.builder(


                      controller:
                      pageController,


                      itemCount:
                      (provider as dynamic).mammaaksaList.length,



                      onPageChanged:
                          (index){

                        provider.currentIndex = index;

                      },



                      itemBuilder:
                          (context,index){



                        final item =
                        (provider as dynamic).mammaaksaList[index];




                        return SingleChildScrollView(

                          child:

                          MammaaksaCard(


                            mammaaksa:item,



                            onAudioPressed:
                                () async{


                              await audioService
                                  .playSound(
                                item.audio,
                              );

                            },


                          ),

                        );

                      },

                    ),

                  ),






                  Padding(

                    padding:
                    const EdgeInsets.all(16),


                    child:

                    Column(

                      children:[



                        Text(

                          "${provider.currentIndex +1} / ${(provider as dynamic).mammaaksaList.length}",


                          style:
                          const TextStyle(

                            fontWeight:
                            FontWeight.bold,

                          ),

                        ),





                        const SizedBox(
                          height:10,
                        ),






                        ElevatedButton.icon(


                          onPressed:

                              (){

                                provider.completeMammaaksa();

                                showXP();

                              },



                          icon:
                          const Icon(
                            Icons.star,
                          ),



                          label:
                          const Text(
                            "Xumuri Mammaaksa ⭐",
                          ),


                        ),




                        const SizedBox(
                          height:10,
                        ),





                        LessonCompleteButton(

                          lessonId:
                          LessonIds.mammaaksa,

                        ),



                      ],

                    ),

                  ),



                ],

              ),





              // XP Animation


              if(showReward)


                Center(

                  child:

                  ScaleTransition(

                    scale:
                    scaleAnimation,


                    child:

                    Container(


                      padding:
                      const EdgeInsets.all(25),


                      decoration:

                      BoxDecoration(

                        color:
                        Colors.white,


                        borderRadius:
                        BorderRadius.circular(30),


                        boxShadow:

                        const [

                          BoxShadow(

                            blurRadius:15,

                            color:
                            Colors.black26,

                          )

                        ],

                      ),




                      child:

                      const Column(

                        mainAxisSize:
                        MainAxisSize.min,


                        children:[



                          Text(

                            "🎉",

                            style:
                            TextStyle(
                              fontSize:60,
                            ),

                          ),



                          Text(

                            "+10 XP",

                            style:
                            TextStyle(

                              fontSize:30,

                              fontWeight:
                              FontWeight.bold,

                            ),

                          ),



                          Text(

                            "Raji: Baay'ee gaarii! 👏",

                          ),


                        ],

                      ),



                    ),

                  ),

                ),




            ],

          );

        },

      ),



    );

  }





  @override
  void dispose(){

    pageController.dispose();

    animationController.dispose();

    super.dispose();

  }


}