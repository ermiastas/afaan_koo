class DownloadItem {

  final String id;

  final String videoId;

  final String title;

  final String emoji;

  final String localPath;

  final int totalBytes;

  final int downloadedBytes;

  final bool completed;


  const DownloadItem({

    required this.id,

    required this.videoId,

    required this.title,

    required this.emoji,

    required this.localPath,

    required this.totalBytes,

    required this.downloadedBytes,

    required this.completed,

  });



  double get progress {

    if(totalBytes == 0){
      return 0;
    }

    return downloadedBytes / totalBytes;

  }



  factory DownloadItem.fromJson(
      Map<String,dynamic> json){

    return DownloadItem(

      id:
      json["id"] ?? "",


      videoId:
      json["videoId"] ?? "",


      title:
      json["title"] ?? "",


      emoji:
      json["emoji"] ?? "📺",


      localPath:
      json["localPath"] ?? "",


      totalBytes:
      json["totalBytes"] ?? 0,


      downloadedBytes:
      json["downloadedBytes"] ?? 0,


      completed:
      json["completed"] ?? false,

    );

  }



  Map<String,dynamic> toJson(){

    return {

      "id":id,

      "videoId":videoId,

      "title":title,

      "emoji":emoji,

      "localPath":localPath,

      "totalBytes":totalBytes,

      "downloadedBytes":downloadedBytes,

      "completed":completed,

    };

  }

}