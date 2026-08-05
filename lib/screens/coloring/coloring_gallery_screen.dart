import 'package:flutter/material.dart';


class ColoringGalleryScreen extends StatelessWidget {


  const ColoringGalleryScreen({
    super.key,
  });



  @override
  Widget build(BuildContext context) {


    return Scaffold(

      backgroundColor:
      const Color(0xffEAF7FF),


      appBar: AppBar(

        title:

        const Text(
          "🎨 Suuraawwan Koo",
        ),

        centerTitle:true,

      ),



      body:

      GridView.builder(


        padding:
        const EdgeInsets.all(16),



        gridDelegate:

        const SliverGridDelegateWithFixedCrossAxisCount(

          crossAxisCount:3,

          crossAxisSpacing:12,

          mainAxisSpacing:12,

        ),



        itemCount:10,



        itemBuilder:(context,index){


          return _galleryCard();


        },


      ),


    );


  }





  Widget _galleryCard(){


    return Container(

      decoration:

      BoxDecoration(

        color:Colors.white,


        borderRadius:

        BorderRadius.circular(20),


        boxShadow:[

          BoxShadow(

            color:

            Colors.black12,

            blurRadius:8,

          )

        ],

      ),



      child:

      Column(

        mainAxisAlignment:

        MainAxisAlignment.center,


        children:[



          const Text(

            "🦁",

            style:

            TextStyle(

              fontSize:60,

            ),

          ),



          const SizedBox(height:8),



          const Text(

            "Leenca Koo",

            style:

            TextStyle(

              fontWeight:

              FontWeight.bold,

            ),

          ),



          const SizedBox(height:5),



          const Text(

            "⭐ ⭐ ⭐",

          ),



        ],


      ),


    );


  }



}