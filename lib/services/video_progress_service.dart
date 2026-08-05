import '../models/video_progress.dart';


class VideoProgressService {


  final List<VideoProgress> _history = [];



  List<VideoProgress> get history =>
      _history;



  void updateProgress({

    required String videoId,

    required double percent,

  }){


    final completed =
        percent >= 0.9;



    final item =
        VideoProgress(

          videoId: videoId,

          watchedPercent: percent,

          completed: completed,

          lastWatched:
              DateTime.now(),

        );



    _history.removeWhere(
      (v)=>v.videoId == videoId,
    );


    _history.add(item);


  }




  VideoProgress?
  getProgress(String videoId){


    try{

      return _history.firstWhere(
        (v)=>v.videoId == videoId,
      );

    }

    catch(e){

      return null;

    }


  }



}