import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../utils/responsive.dart';
import '../providers/age_provider.dart';



class AgeSelectionScreen extends StatelessWidget {


  const AgeSelectionScreen({
    super.key,
  });



  @override
  Widget build(BuildContext context) {

    return Scaffold(


      backgroundColor:
      const Color(0xffEAF7FF),



      appBar:

      AppBar(

        title:

        const Text(

          "Umrii kee filadhu 🎯",

          style:

          TextStyle(

            fontWeight:
            FontWeight.bold,

          ),

        ),

        centerTitle:true,

      ),





      body:


      Padding(


        padding:

        EdgeInsets.all(Responsive.pagePadding(context)),



        child:

        Column(



          children:[



            const Text(


              "Raji barnoota siif mijatu qopheessa 😊",


              textAlign:
              TextAlign.center,


              style:

              TextStyle(

                fontSize:20,

                fontWeight:
                FontWeight.bold,

              ),

            ),





            const SizedBox(height:30),





            Expanded(


              child:


              GridView.builder(



                itemCount:10,



                gridDelegate:


                Responsive.homeGridDelegate(
                  context,
                  childAspectRatio: 1,
                  crossAxisSpacing: 15,
                  mainAxisSpacing: 15,
                ),





                itemBuilder:(context,index){



                  final age =
                  index + 3;




                  return GestureDetector(



                    onTap:() async {



                      await context

                          .read<AgeProvider>()

                          .setAge(age);





                      if(context.mounted){



                        Navigator.pop(context);



                      }



                    },




                    child:

                    Container(



                      decoration:

                      BoxDecoration(


                        color:

                        _ageColor(age),



                        borderRadius:

                        BorderRadius.circular(25),



                        boxShadow:[



                          const BoxShadow(


                            color:
                            Colors.black12,


                            blurRadius:8,


                            offset:
                            Offset(0,4),


                          ),



                        ],



                      ),




                      child:

                      Column(


                        mainAxisAlignment:

                        MainAxisAlignment.center,



                        children:[




                          Text(



                            _ageEmoji(age),



                            style:

                            const TextStyle(

                              fontSize:35,

                            ),



                          ),





                          const SizedBox(height:8),





                          Text(



                            "$age",



                            style:

                            const TextStyle(



                              fontSize:28,


                              fontWeight:
                              FontWeight.bold,


                              color:
                              Colors.white,


                            ),



                          ),




                        ],



                      ),



                    ),



                  );



                },


              ),



            ),



          ],



        ),



      ),


    );


  }






  String _ageEmoji(int age){



    if(age <=5){

      return "👶";

    }


    if(age <=8){

      return "🧒";

    }


    return "🚀";


  }





  Color _ageColor(int age){


    if(age <=5){

      return Colors.orange;

    }


    if(age <=8){

      return Colors.green;

    }


    return Colors.blue;


  }



}
