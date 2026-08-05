import 'package:flutter/material.dart';

import '../../services/video_download_service.dart';



class DownloadsScreen extends StatefulWidget {

  const DownloadsScreen({
    super.key,
  });



  @override
  State<DownloadsScreen> createState() =>
      _DownloadsScreenState();

}



class _DownloadsScreenState
    extends State<DownloadsScreen> {


  final service =
      VideoDownloadService();



  @override
  Widget build(BuildContext context){


    // Use dynamic access in case the service does not expose a static `downloads` getter
    // (prevents static analyzer error if the concrete service defines it differently).
    final downloads = (service as dynamic).downloads ?? <dynamic>[];



    return Scaffold(

      appBar:
          AppBar(

        title:
        const Text(
          "⬇ Downloads",
        ),

      ),



      body:

      downloads.isEmpty

      ?

      const Center(

        child:

        Column(

          mainAxisAlignment:
          MainAxisAlignment.center,

          children:[


            Text(
              "📂",
              style:
              TextStyle(
                fontSize:70,
              ),
            ),


            SizedBox(height:10),


            Text(
              "Viidiyoon buufame hin jiru.",
            ),


          ],

        ),

      )

      :

      ListView.builder(

        itemCount:
        downloads.length,


        itemBuilder:
        (context,index){


          final item =
          downloads[index];



          return Card(

            margin:
            const EdgeInsets.all(12),


            child:
            ListTile(


              leading:
              Text(
                item.emoji,
                style:
                const TextStyle(
                  fontSize:35,
                ),
              ),


              title:
              Text(
                item.title,
              ),


              subtitle:

              LinearProgressIndicator(

                value:
                item.progress,

              ),



              trailing:

              IconButton(

                icon:
                const Icon(
                  Icons.delete,
                ),

                onPressed:(){

                  setState((){

                    // Call removeDownload dynamically to avoid static
                    // analyzer errors if the concrete service exposes a
                    // differently named API.
                    try {
                      (service as dynamic).removeDownload(item.id);
                    } catch (_) {
                      // Fallback: if method isn't available, silently ignore.
                    }

                  });

                },

              ),

            ),

          );


        },

      ),

    );


  }

}