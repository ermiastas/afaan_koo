import 'package:flutter/material.dart';

import 'audio_service.dart';



class RajiService {



static Future<void> speakSuccess() async {

  final service = AudioService();
await service.play(

"audio/raji/good_job.mp3",

);


}




static String successMessage(){


final messages=[


"Baay'ee gaarii! ⭐",

"Ati nama cimaa dha! 👏",

"Barachuu kee itti fufi! 🚀",

"Raji si dinqisiifata! 😊",

];


return messages[

DateTime.now().second %

messages.length

];


}





static void showMessage(

BuildContext context,

){


ScaffoldMessenger.of(context)

.showSnackBar(


SnackBar(


behavior:

SnackBarBehavior.floating,


backgroundColor:

Colors.green,


content:

Text(

successMessage(),

style:

const TextStyle(

fontSize:18,

),

),


),


);



}



}