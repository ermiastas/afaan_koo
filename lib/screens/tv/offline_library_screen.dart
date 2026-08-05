import 'package:flutter/material.dart';

import '../../models/video_item.dart';
import '../../services/video_download_service.dart';
import 'video_player_screen.dart';



class OfflineLibraryScreen extends StatefulWidget {

  const OfflineLibraryScreen({
    super.key,
  });


  @override
  State<OfflineLibraryScreen> createState() =>
      _OfflineLibraryScreenState();

}



class _OfflineLibraryScreenState
    extends State<OfflineLibraryScreen> {


  final VideoDownloadService service =
      VideoDownloadService();



  List<VideoItem> offlineVideos = [];



  @override
  void initState(){

    super.initState();

    _loadOfflineVideos();

  }



  Future<void> _loadOfflineVideos() async {


    // Later this will read from local database
    // For now it is a placeholder


    setState((){

      offlineVideos = [];

    });


  }





  @override
  Widget build(BuildContext context){


    return Scaffold(


      backgroundColor:
          const Color(0xffEAF7FF),



      appBar:
          AppBar(

        title:
            const Text(
              "⬇ AfaanKoo Offline",
            ),

      ),



      body:

      offlineVideos.isEmpty

      ?

      _emptyState()


      :

      GridView.builder(

        padding:
            const EdgeInsets.all(18),


        itemCount:
            offlineVideos.length,


        gridDelegate:
            const SliverGridDelegateWithFixedCrossAxisCount(

          crossAxisCount:2,

          crossAxisSpacing:15,

          mainAxisSpacing:15,

          childAspectRatio:.75,

        ),



        itemBuilder:(context,index){


          final video =
              offlineVideos[index];


          return _offlineCard(video);


        },


      ),


    );


  }







  Widget _offlineCard(VideoItem video){


    return InkWell(

      borderRadius:
          BorderRadius.circular(25),


      onTap:(){


        Navigator.push(

          context,

          MaterialPageRoute(

            builder:(_)=>

              VideoPlayerScreen(

                video:video,

              ),

          ),

        );


      },



      child: Container(

        padding:
            const EdgeInsets.all(16),


        decoration:
            BoxDecoration(

          color:
              Colors.white,

          borderRadius:
              BorderRadius.circular(25),

        ),



        child:
        Column(

          mainAxisAlignment:
              MainAxisAlignment.center,


          children:[



            Text(

              video.emoji,

              style:
              const TextStyle(

                fontSize:55,

              ),

            ),



            const SizedBox(height:15),



            Text(

              video.title,

              textAlign:
                  TextAlign.center,

              style:
              const TextStyle(

                fontWeight:
                    FontWeight.bold,

              ),

            ),



            const SizedBox(height:10),



            const Chip(

              label:
              Text(
                "Offline",
              ),

              avatar:
              Icon(
                Icons.download_done,
                size:18,
              ),

            ),


          ],

        ),

      ),

    );


  }







  Widget _emptyState(){


    return Center(


      child:
      Column(

        mainAxisAlignment:
            MainAxisAlignment.center,


        children:[


          const Text(

            "📂",

            style:
            TextStyle(

              fontSize:80,

            ),

          ),



          const SizedBox(height:15),



          const Text(

            "Viidiyoon offline hin jiru",

            style:
            TextStyle(

              fontSize:18,

              fontWeight:
              FontWeight.bold,

            ),

          ),



          const SizedBox(height:8),



          Text(

            "Viidiyoo buufadhu, yeroo booda internet malee ilaali.",

            textAlign:
            TextAlign.center,

            style:
            TextStyle(

              color:
              Colors.grey.shade700,

            ),

          ),



        ],

      ),

    );


  }


}