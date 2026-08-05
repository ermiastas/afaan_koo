import 'package:flutter/material.dart';
import 'package:video_player/video_player.dart';
import 'package:chewie/chewie.dart';

import '../../models/video_item.dart';
import '../../services/video_download_service.dart';



class VideoPlayerScreen extends StatefulWidget {


  final VideoItem video;

  final downloadService =
    VideoDownloadService();

  VideoPlayerScreen({

    super.key,

    required this.video,

  });



  @override
  State<VideoPlayerScreen> createState() =>
      _VideoPlayerScreenState();

}





class _VideoPlayerScreenState
    extends State<VideoPlayerScreen> {


  VideoPlayerController?
      videoController;


  ChewieController?
      chewieController;



  @override
  void initState(){

    super.initState();

    _initializeVideo();

  }





  Future<void> _initializeVideo() async {


    videoController =
        VideoPlayerController.asset(
          widget.video.videoUrl,
        );


    await videoController!.initialize();



    chewieController =
        ChewieController(

      videoPlayerController:
          videoController!,


      autoPlay:
          false,


      looping:
          false,


      allowFullScreen:
          true,


      showControls:
          true,


    );



    setState((){});


  }






  @override
  Widget build(BuildContext context){


    return Scaffold(


      backgroundColor:
          Colors.black,


      appBar:
          AppBar(

        title:
            Text(
              widget.video.title,
            ),

        backgroundColor:
            Colors.black,

      ),



      body:

      Column(

        children:[



          Expanded(

            child:

            chewieController == null

            ?

            const Center(

              child:
                  CircularProgressIndicator(),

            )


            :

            Chewie(

              controller:
                  chewieController!,

            ),

          ),





          _bottomPanel(),



        ],

      ),

    );


  }






  Widget _bottomPanel(){


    return Container(


      padding:
          const EdgeInsets.all(15),


      color:
          Colors.white,


      child:

      Row(

        children:[



          Text(

            widget.video.emoji,

            style:
                const TextStyle(
                  fontSize:35,
                ),

          ),



          const SizedBox(width:12),




          Expanded(

            child:

            Column(

              crossAxisAlignment:
                  CrossAxisAlignment.start,


              children:[


                Text(

                  widget.video.title,

                  style:
                      const TextStyle(

                        fontWeight:
                            FontWeight.bold,

                      ),

                ),



                Text(

                  "+${widget.video.rewardXP} XP",

                  style:

                      TextStyle(

                        color:
                            Colors.green.shade700,

                      ),

                ),



              ],

            ),

          ),




IconButton(

icon:
const Icon(
 Icons.download,
),

onPressed:() async {


double progress = 0;


await widget.downloadService.downloadVideo(

video: widget.video,


onProgress:(value){


setState((){

progress=value;

});


},


);



ScaffoldMessenger.of(context)
.showSnackBar(

SnackBar(

content: Text(

"Download ${(
progress*100
).round()}% xumureera",

),

),

);


},

),



          IconButton(

            icon:
                const Icon(
                  Icons.favorite_border,
                ),

            onPressed:(){},


          ),



        ],

      ),


    );


  }






  @override
  void dispose(){


    videoController?.dispose();


    chewieController?.dispose();


    super.dispose();

  }

}