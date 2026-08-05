class VideoQuestion {

  final String question;

  final List<String> options;

  final int correctIndex;

  final String? audio;

  final String? image;

  const VideoQuestion({

    required this.question,

    required this.options,

    required this.correctIndex,

    this.audio,

    this.image,

  });

}