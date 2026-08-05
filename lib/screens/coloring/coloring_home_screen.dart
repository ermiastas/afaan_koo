import 'package:flutter/material.dart';

import '../../data/coloring_categories.dart';
import '../../models/coloring_category.dart';
import '../../widgets/coloring/coloring_category_card.dart';
import '../../widgets/coloring/coloring_category_screen.dart';
import 'coloring_gallery_screen.dart';
import '../../utils/responsive.dart';



class ColoringHomeScreen extends StatefulWidget {

  const ColoringHomeScreen({
    super.key,
  });


  @override
  State<ColoringHomeScreen> createState() =>
      _ColoringHomeScreenState();

}



class _ColoringHomeScreenState
    extends State<ColoringHomeScreen> {


  String search = "";



  @override
  Widget build(BuildContext context) {


    final columns = Responsive.gridColumns(
      context,
      minimumTileWidth: 180,
      min: 2,
      max: 5,
    );



    final List<ColoringCategory> filtered =

        coloringCategories.where((category) {


      if(search.isEmpty){

        return true;

      }



      return category.title
              .toLowerCase()
              .contains(search.toLowerCase())

          ||

          category.description
              .toLowerCase()
              .contains(search.toLowerCase());


    }).toList();




    return Scaffold(


      backgroundColor:

          const Color(0xffEAF7FF),



      body:

      SafeArea(


        child:

        Column(


          children: [



            _header(),



            _searchBox(),



            const SizedBox(

              height:18,

            ),



            Expanded(


              child:

              GridView.builder(



                padding:

                EdgeInsets.symmetric(

                  horizontal: Responsive.pagePadding(context),

                  vertical:8,

                ),



                itemCount:

                filtered.length,


gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
  crossAxisCount: columns,
  crossAxisSpacing: 16,
  mainAxisSpacing: 16,
childAspectRatio: 0.72,
),

                itemBuilder:

                    (context,index){



                  final category =

                      filtered[index];



                  return ColoringCategoryCard(


                    category:

                    category,



                    onTap:(){



                      Navigator.push(


                        context,


                        MaterialPageRoute(


                          builder:(_)=>

                              ColoringCategoryScreen(


                                category:

                                category,


                              ),


                        ),


                      );


                    },


                  );


                },


              ),


            ),



          ],


        ),


      ),


    );

  }







  Widget _header(){


    return Container(



      width:

      double.infinity,



      padding:

      const EdgeInsets.fromLTRB(

        20,

        20,

        20,

        10,

      ),



      child:

      Column(



        crossAxisAlignment:

        CrossAxisAlignment.start,



        children:[



          Row(



            children:[



              const Text(


                "🎨",


                style:

                TextStyle(

                  fontSize:42,

                ),


              ),



              const SizedBox(

                width:12,

              ),




              const Expanded(


                child:

                Text(


                  "Halluu Dibuu",



                  style:

                  TextStyle(



                    fontSize:30,



                    fontWeight:

                    FontWeight.bold,


                  ),



                ),



              ),





              GestureDetector(



                onTap:(){



                  Navigator.push(



                    context,



                    MaterialPageRoute(



                      builder:(_)=>

                          const ColoringGalleryScreen(),



                    ),



                  );



                },



                child:

                Container(



                  padding:

                  const EdgeInsets.all(10),



                  decoration:

                  BoxDecoration(



                    color:

                    Colors.white,



                    shape:

                    BoxShape.circle,



                    boxShadow:[



                      BoxShadow(



                        color:

                        Colors.black.withValues(alpha: .08),



                        blurRadius:8,



                        offset:

                        const Offset(0,3),



                      ),



                    ],



                  ),



                  child:

                  const Text(



                    "🖼️",



                    style:

                    TextStyle(



                      fontSize:28,



                    ),



                  ),



                ),



              ),



            ],



          ),




          const SizedBox(

            height:8,

          ),




          Text(



            "Halluu dibuun baradhu, taphadhu fi kalaqi.",



            style:



            TextStyle(



              color:

              Colors.grey.shade700,



              fontSize:16,



            ),



          ),



        ],



      ),



    );


  }








  Widget _searchBox(){



    return Padding(



      padding:

      const EdgeInsets.symmetric(

        horizontal:20,

      ),



      child:

      TextField(



        onChanged:(value){



          setState((){



            search=value;



          });



        },



        decoration:

        InputDecoration(



          hintText:

          "🔍 Barbaadi...",



          filled:true,



          fillColor:

          Colors.white,



          prefixIcon:

          const Icon(

            Icons.search,

          ),



          border:

          OutlineInputBorder(



            borderRadius:

            BorderRadius.circular(20),



            borderSide:

            BorderSide.none,



          ),



          enabledBorder:

          OutlineInputBorder(



            borderRadius:

            BorderRadius.circular(20),



            borderSide:

            BorderSide.none,



          ),



          focusedBorder:

          OutlineInputBorder(



            borderRadius:

            BorderRadius.circular(20),



            borderSide:

            BorderSide(



              color:

              Colors.orange,



              width:2,



            ),



          ),



        ),



      ),



    );



  }



}
