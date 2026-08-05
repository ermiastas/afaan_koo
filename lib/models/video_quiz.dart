import 'video_question.dart';

class VideoQuiz {

  final String id;

  final String videoId;

  final String title;

  final List<VideoQuestion> questions;

  final int rewardXP;

  final int rewardCoins;

  const VideoQuiz({

    required this.id,

    required this.videoId,

    required this.title,

    required this.questions,

    this.rewardXP = 20,

    this.rewardCoins = 10,

  });

}