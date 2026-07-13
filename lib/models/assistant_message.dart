class AssistantMessage {


  final String message;
  final String emotion;
  final String audio;



  AssistantMessage({

    required this.message,
    required this.emotion,
    required this.audio,

  });



  factory AssistantMessage.fromJson(
      Map<String,dynamic> json
      ){

    return AssistantMessage(

      message:
      json["message"],

      emotion:
      json["emotion"],

      audio:
      json["audio"],

    );

  }


}