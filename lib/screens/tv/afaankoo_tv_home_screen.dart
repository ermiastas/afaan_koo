import 'package:flutter/material.dart';

import '../../data/sample_videos.dart';
import '../../data/video_categories.dart';


import '../../widgets/tv/featured_video_banner.dart';
import '../../widgets/tv/video_card.dart';
import '../../widgets/tv/video_category_card.dart';
import '../../widgets/tv/continue_watching_card.dart';
import 'video_player_screen.dart';


class AfaanKooTVHomeScreen extends StatefulWidget {

  const AfaanKooTVHomeScreen({
    super.key,
  });


  @override
  State<AfaanKooTVHomeScreen> createState() =>
      _AfaanKooTVHomeScreenState();

}



class _AfaanKooTVHomeScreenState
    extends State<AfaanKooTVHomeScreen> {


  String search = "";


  @override
  Widget build(BuildContext context) {


    final featured =
        sampleVideos
            .where((video)=>video.featured)
            .toList();



    final videos =
        sampleVideos.where((video){

      if(search.isEmpty){
        return true;
      }

      return video.title
          .toLowerCase()
          .contains(
            search.toLowerCase(),
          );

    }).toList();



    return Scaffold(


      backgroundColor:
          const Color(0xffEAF7FF),



      body: SafeArea(

        child: SingleChildScrollView(


          padding:
              const EdgeInsets.all(20),



          child: Column(

            crossAxisAlignment:
                CrossAxisAlignment.start,

            children: [



              _header(),



              const SizedBox(height:20),



              _searchBox(),



              const SizedBox(height:25),



              if(featured.isNotEmpty)

              FeaturedVideoBanner(

                video:
                    featured.first,


onPlay: (){

 Navigator.push(

   context,

   MaterialPageRoute(

     builder: (_) =>
       VideoPlayerScreen(
         video: featured.first,
       ),

   ),

 );

},


              ),



              const SizedBox(height:30),



              _title(
                "▶ Continue Watching",
              ),



              ContinueWatchingCard(

                video:
                    sampleVideos.first,

                progress:
                    .65,

                onTap: (){},

              ),



              const SizedBox(height:30),



              _title(
                "📂 Categories",
              ),



              GridView.builder(


                shrinkWrap:true,


                physics:
                    const NeverScrollableScrollPhysics(),


                itemCount:
                    videoCategories.length,


                gridDelegate:
                    const SliverGridDelegateWithFixedCrossAxisCount(

                  crossAxisCount:3,

                  crossAxisSpacing:12,

                  mainAxisSpacing:12,

                  childAspectRatio:.7,

                ),



                itemBuilder:(context,index){


                  final category =
                      videoCategories[index];



                  return VideoCategoryCard(

                    category:
                        category,

                    onTap:(){

                      // Open a simple category screen instead of VideoPlayerScreen
                      Navigator.push(

                        context,

                        MaterialPageRoute(

                          builder: (_)=> Scaffold(

                            appBar: AppBar(
                              title: Text(category.toString()),
                            ),

                            body: Center(
                              child: Text('Category: $category'),
                            ),

                          ),

                        ),

                      );

                    },

                  );


                },

              ),



              const SizedBox(height:30),



              _title(
                "🔥 Recommended",
              ),



              GridView.builder(

                shrinkWrap:true,

                physics:
                    const NeverScrollableScrollPhysics(),


                itemCount:
                    videos.length,


                gridDelegate:
                    const SliverGridDelegateWithFixedCrossAxisCount(

                  crossAxisCount:2,

                  crossAxisSpacing:15,

                  mainAxisSpacing:15,

                  childAspectRatio:.75,

                ),



                itemBuilder:(context,index){


                  final video =
                      videos[index];


                  return VideoCard(

                    video:
                        video,

                    onTap:(){


                      // open video player later


                    },

                  );


                },

              ),



              const SizedBox(height:30),



              _quickButtons(),



              const SizedBox(height:20),



              _rajiCard(),



            ],

          ),

        ),

      ),

    );

  }




  Widget _header(){


    return Row(

      children:[


        const Text(
          "📺",
          style:
              TextStyle(
                fontSize:45,
              ),
        ),


        const SizedBox(width:12),


        Column(

          crossAxisAlignment:
              CrossAxisAlignment.start,


          children:[


            const Text(

              "AfaanKoo TV+",

              style:
                  TextStyle(

                    fontSize:30,

                    fontWeight:
                        FontWeight.bold,

                  ),

            ),



            Text(

              "Baradhu • Ilaali • Taphadhu",

              style:

                  TextStyle(

                    color:
                        Colors.grey.shade700,

                  ),

            ),


          ],

        ),


      ],

    );


  }





  Widget _searchBox(){


    return TextField(


      onChanged:(value){

        setState((){

          search=value;

        });

      },


      decoration:
          InputDecoration(

        filled:true,

        fillColor:
            Colors.white,

        hintText:
            "🔍 Viidiyoo barbaadi...",


        prefixIcon:
            const Icon(Icons.search),


        border:
            OutlineInputBorder(

          borderRadius:
              BorderRadius.circular(25),

          borderSide:
              BorderSide.none,

        ),


      ),


    );


  }




  Widget _title(String text){


    return Padding(

      padding:
          const EdgeInsets.only(
            bottom:12,
          ),


      child: Text(

        text,

        style:
            const TextStyle(

              fontSize:22,

              fontWeight:
                  FontWeight.bold,

            ),

      ),

    );


  }




  Widget _quickButtons(){

    return Row(
      children: [
        Expanded(
          child: InkWell(
            onTap: () {
              Navigator.pushNamed(context, "/offline-library");
            },
            child: _button("⬇ Downloads"),
          ),
        ),
        const SizedBox(width: 12),
        Expanded(
          child: _button("❤️ Favorites"),
        ),
      ],
    );
  }




  Widget _button(String text){


    return Container(

      padding:
          const EdgeInsets.all(16),


      decoration:
          BoxDecoration(

        color:
            Colors.white,

        borderRadius:
            BorderRadius.circular(20),

      ),


      child:
          Center(

            child:
                Text(

                  text,

                  style:
                      const TextStyle(

                        fontWeight:
                            FontWeight.bold,

                      ),

                ),

          ),

    );


  }




  Widget _rajiCard(){


    return Container(

      padding:
          const EdgeInsets.all(18),


      decoration:
          BoxDecoration(

        color:
            Colors.deepPurple.shade100,

        borderRadius:
            BorderRadius.circular(25),

      ),


      child:
          const Row(

            children:[


              Text(
                "🤖",
                style:
                    TextStyle(
                      fontSize:45,
                    ),
              ),


              SizedBox(width:15),


              Expanded(

                child:
                    Text(

                      "Ani Raji dha! Har'a maal ilaaluu barbaadda?",

                      style:
                          TextStyle(

                            fontSize:16,

                            fontWeight:
                                FontWeight.bold,

                          ),

                    ),

              ),


            ],

          ),

    );


  }


}