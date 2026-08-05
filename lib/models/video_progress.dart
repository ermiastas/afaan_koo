class VideoProgress {

  final String videoId;

  final double watchedPercent;

  final bool completed;

  final DateTime lastWatched;


  const VideoProgress({

    required this.videoId,

    required this.watchedPercent,

    required this.completed,

    required this.lastWatched,

  });



  Map<String,dynamic> toJson(){

    return {

      "videoId": videoId,

      "watchedPercent": watchedPercent,

      "completed": completed,

      "lastWatched":
          lastWatched.toIso8601String(),

    };

  }



  factory VideoProgress.fromJson(
      Map<String,dynamic> json){

    return VideoProgress(

      videoId:
          json["videoId"] ?? "",


      watchedPercent:
          json["watchedPercent"] ?? 0,


      completed:
          json["completed"] ?? false,


      lastWatched:
          DateTime.parse(
            json["lastWatched"],
          ),

    );

  }

}