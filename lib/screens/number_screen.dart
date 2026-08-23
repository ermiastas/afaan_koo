import 'package:flutter/material.dart';

import '../services/content_service.dart';
import '../models/number_item.dart';

import 'number_detail_screen.dart';
import 'tracing_practice_screen.dart';

import '../widgets/lesson_complete_button.dart';
import '../utils/responsive.dart';



class NumberScreen extends StatefulWidget {


  const NumberScreen({
    super.key,
  });



  @override
  State<NumberScreen> createState()
      => _NumberScreenState();

}








class _NumberScreenState
    extends State<NumberScreen> {



  final ContentService contentService =
      ContentService();



  late Future<List<NumberItem>> numbers;







  @override
  void initState(){

    super.initState();

    loadNumbers();

  }






  void loadNumbers(){

    numbers =
        contentService.getNumbers();

  }







  Future<void> refreshNumbers() async {


    setState(() {

      loadNumbers();

    });


  }








  @override
  Widget build(BuildContext context){


    return Scaffold(



      appBar:

      AppBar(

        title:

        const Text(
          "🔢 Lakkoofsa Koo",
        ),


        centerTitle:true,


        actions:[



          IconButton(

            icon:

            const Icon(
              Icons.gesture,
            ),


            tooltip:

            "Lakkoofsa barreessi",


            onPressed:(){


              Navigator.push(

                context,

                MaterialPageRoute(

                  builder:(_)=>

                  const TracingPracticeScreen(

                    mode:

                    TracingMode.numbers,

                  ),

                ),

              );


            },

          ),




          IconButton(

            icon:

            const Icon(
              Icons.refresh,
            ),


            onPressed:

            refreshNumbers,


          ),



        ],


      ),






      body:


      FutureBuilder<List<NumberItem>>(



        future:

        numbers,



        builder:

        (context,snapshot){





          if(snapshot.connectionState ==

              ConnectionState.waiting){


            return const Center(

              child:

              CircularProgressIndicator(),

            );


          }






          if(snapshot.hasError){


            return Center(

              child:

              Text(

                "Dogoggora: ${snapshot.error}",

              ),

            );


          }








          if(!snapshot.hasData ||

              snapshot.data!.isEmpty){


            return const Center(

              child:

              Text(

                "Lakkoofsi hin jiru",

                style:

                TextStyle(

                  fontSize:20,

                ),

              ),

            );


          }





          final numberList =
              snapshot.data!;







          return Column(

            children:[







              // Raji Welcome Card

              Container(

                margin:

                const EdgeInsets.all(16),


                padding:

                const EdgeInsets.all(20),



                decoration:

                BoxDecoration(


                  gradient:

                  const LinearGradient(


                    colors:[

                      Colors.blue,

                      Colors.lightBlueAccent,

                    ],


                  ),



                  borderRadius:

                  BorderRadius.circular(25),


                ),



                child:

                const Column(


                  children:[



                    Text(

                      "😊 Ana,Raji, waliin Lakkoofsa haa barannu!",


                      textAlign:

                      TextAlign.center,


                      style:

                      TextStyle(

                        color:

                        Colors.white,

                        fontSize:

                        22,

                        fontWeight:

                        FontWeight.bold,

                      ),


                    ),




                    SizedBox(height:8),




                    Text(

                      "Lakkoofsa dubbisi, lakkaa'i fi barreessi ⭐",

                      textAlign:

                      TextAlign.center,


                      style:

                      TextStyle(

                        color:

                        Colors.white,

                        fontSize:

                        16,

                      ),


                    ),



                  ],


                ),


              ),










              Expanded(


                child:

                GridView.builder(


                  padding:

                  EdgeInsets.all(Responsive.pagePadding(context)),



                  gridDelegate:

                  Responsive.homeGridDelegate(
                    context,


                    crossAxisSpacing:

                    15,


                    mainAxisSpacing:

                    15,


                    childAspectRatio:

                    .78,


                  ),





                  itemCount:

                  numberList.length,






                  itemBuilder:

                  (context,index){



                    final number =
                    numberList[index];





                    return _NumberCard(


                      number:

                      number,



                      onTap:(){



                        Navigator.push(

                          context,

                          MaterialPageRoute(

                            builder:(_)=>

                            NumberDetailScreen(

                              numbers:

                              numberList,


                              initialIndex:

                              index,

                            ),

                          ),

                        );


                      },



                    );



                  },


                ),


              ),








              Padding(


                padding:

                const EdgeInsets.all(16),



                child:


                LessonCompleteButton(



                  lessonId:

                  "numbers",



                ),



              ),




            ],


          );



        },


      ),



    );


  }


}













class _NumberCard extends StatelessWidget {


  final NumberItem number;


  final VoidCallback onTap;




  const _NumberCard({

    required this.number,

    required this.onTap,

  });






  @override
  Widget build(BuildContext context){



    return InkWell(


      borderRadius:

      BorderRadius.circular(25),



      onTap:

      onTap,





      child:


      Container(


        padding:

        const EdgeInsets.all(12),





        decoration:

        BoxDecoration(



          gradient:

          const LinearGradient(


            colors:[


              Colors.white,

              Color(0xffE3F2FD),

            ],


            begin:

            Alignment.topLeft,


            end:

            Alignment.bottomRight,


          ),





          borderRadius:

          BorderRadius.circular(25),




          boxShadow:[



            BoxShadow(


              blurRadius:

              8,


              offset:

              const Offset(0,5),



              color:

              Colors.black12,



            ),



          ],


        ),






        child:

        Column(



          mainAxisAlignment:

          MainAxisAlignment.center,




          children:[






            // Number Circle Badge

            Container(

              padding:

              const EdgeInsets.all(10),


              decoration:

              const BoxDecoration(

                color:

                Colors.blue,


                shape:

                BoxShape.circle,

              ),



              child:

              Text(


                number.number.toString(),



                style:

                const TextStyle(



                  color:

                  Colors.white,


                  fontSize:

                  35,


                  fontWeight:

                  FontWeight.bold,


                ),


              ),



            ),







            const SizedBox(height:10),








            Image.asset(



              number.image,


              height:

              65,



              errorBuilder:

              (context,error,stack){



                return const Icon(



                  Icons.image,


                  size:60,


                );


              },


            ),







            const SizedBox(height:8),







            Text(



              number.nameOromo,



              textAlign:

              TextAlign.center,



              style:

              const TextStyle(



                fontSize:

                22,


                fontWeight:

                FontWeight.bold,


              ),


            ),







            Text(



              number.nameEnglish,



              style:

              const TextStyle(



                fontSize:

                14,


                color:

                Colors.grey,


              ),


            ),




          ],



        ),



      ),



    );


  }


}
