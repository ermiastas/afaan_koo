class ColoringSvgItem {


  final String id;

  final String titleOromo;

  final String titleEnglish;

  final String svgAsset;

  final String category;

  final String emoji;

  final int rewardXP;



  const ColoringSvgItem({

    required this.id,

    required this.titleOromo,

    required this.titleEnglish,

    required this.svgAsset,

    required this.category,

    this.emoji = "🎨",

    this.rewardXP = 20,

  });


}