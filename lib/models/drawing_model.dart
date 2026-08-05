class DrawingModel {

  final String id;

  final String name;

  final String imagePath;

  final DateTime createdAt;

  final int rewardXP;


  DrawingModel({

    required this.id,

    required this.name,

    required this.imagePath,

    required this.createdAt,

    this.rewardXP = 20,

  });


}