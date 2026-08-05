import 'dart:io';

import 'package:dio/dio.dart';
import 'package:path_provider/path_provider.dart';

import '../models/video_item.dart';



class VideoDownloadService {


  final Dio dio = Dio();



  Future<String?> downloadVideo({

    required VideoItem video,

    required Function(double progress) onProgress,

  }) async {


    try {


      final directory =
          await getApplicationDocumentsDirectory();



      final videoDirectory =
          Directory(
            "${directory.path}/AfaanKooVideos",
          );



      if(!await videoDirectory.exists()){

        await videoDirectory.create(
          recursive:true,
        );

      }



      final savePath =
          "${videoDirectory.path}/${video.id}.mp4";



      await dio.download(

        video.videoUrl,

        savePath,


        onReceiveProgress:
        (received,total){


          if(total != -1){

            final progress =
                received / total;


            onProgress(progress);

          }


        },


      );



      return savePath;


    }

    catch(e){

      return null;

    }


  }





  Future<bool> deleteVideo(
      String path) async{


    final file =
        File(path);



    if(await file.exists()){

      await file.delete();

      return true;

    }


    return false;


  }




  Future<bool> exists(
      String path) async{


    return File(path).exists();

  }



}