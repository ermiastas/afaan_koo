import 'package:flutter/material.dart';
import 'package:confetti/confetti.dart';

import '../models/learning_item.dart';
import '../services/audio_service.dart';
import '../services/progress_service.dart';
import '../services/badge_service.dart';
import '../widgets/reward_dialog.dart';
import '../widgets/lesson_complete_button.dart';
import '../utils/responsive.dart';



class LearningScreen extends StatefulWidget {


  final String title;

  final Color color;

  final List<LearningItem> items;

  final String rajiMessage;

  final String lessonId;



  const LearningScreen({

    super.key,

    required this.title,

    required this.color,

    required this.items,

    required this.rajiMessage,

    required this.lessonId,

  });



  @override
  State<LearningScreen> createState()
      => _LearningScreenState();


}







class _LearningScreenState 
    extends State<LearningScreen> {



late ConfettiController confettiController;


final AudioService audioService =
AudioService();






@override
void initState(){

super.initState();


confettiController =
ConfettiController(

duration:
const Duration(seconds:3),

);


}






@override
void dispose(){

confettiController.dispose();

audioService.dispose();

super.dispose();

}









Future<void> completeLesson() async {



confettiController.play();



await ProgressService.addStar(5);


await ProgressService.completeLesson();





String? badge;




if(widget.lessonId == "alphabet"){

badge = "alphabet";

}


else if(widget.lessonId == "animals"){

badge = "animals";

}


else if(

widget.lessonId == "plants" ||

widget.lessonId == "weather"

){

badge = "nature";

}







if(badge != null){

await BadgeService.unlockBadge(badge);

}







await audioService.playSound(

"assets/audio/reward.mp3",

);






if(!mounted) return;






showDialog(

context:context,


builder:(context){



return RewardDialog(

stars:5,

rajiMessage:

widget.rajiMessage,


badge:

badge,


);



},



);



}









@override
Widget build(BuildContext context){



return Scaffold(



appBar:

AppBar(


title:

Text(widget.title),


centerTitle:true,


backgroundColor:

widget.color,


),







body:

Stack(


children:[



Column(


children:[






Container(


width:

double.infinity,


padding:

  EdgeInsets.all(Responsive.pagePadding(context)),




decoration:

BoxDecoration(


color:

widget.color.withValues(

alpha:0.15,

),


),





child:

Column(


children:[




const Text(

"😊 Raajii",

style:

TextStyle(

fontSize:28,

fontWeight:

FontWeight.bold,

),

),





const SizedBox(height:8),






Text(

widget.rajiMessage,


textAlign:

TextAlign.center,


style:

const TextStyle(

fontSize:16,

),

),




],



),




),







Expanded(



child:

GridView.builder(



padding:

const EdgeInsets.all(16),




itemCount:

widget.items.length,





gridDelegate:

  Responsive.homeGridDelegate(
    context,



crossAxisSpacing:

12,



mainAxisSpacing:

12,



childAspectRatio:

0.75,



),







itemBuilder:

(context,index){



final item =

widget.items[index];






return GestureDetector(



onTap:() async {



await audioService.playSound(

item.sound,

);



},




child:

Card(



elevation:

5,



shape:

RoundedRectangleBorder(

borderRadius:

BorderRadius.circular(20),

),





child:

Column(



mainAxisAlignment:

MainAxisAlignment.center,



children:[






Expanded(



child:

Padding(


padding:

const EdgeInsets.all(12),



child:

Image.asset(


item.image,


fit:

BoxFit.contain,



errorBuilder:

(context,error,stack){


return const Icon(

Icons.image,

size:80,

);


},


),


),



),








Text(


item.nameOromo,



style:

const TextStyle(


fontSize:20,

fontWeight:

FontWeight.bold,


),



),





Text(


item.nameEnglish,



style:

const TextStyle(

fontSize:15,

),



),





const SizedBox(height:10),






Icon(

Icons.volume_up,

color:

widget.color,

),





],



),




),




);



},



),



),







// Lesson completion button

Padding(

padding:

const EdgeInsets.all(16),



child:

LessonCompleteButton(


lessonId:

widget.lessonId,


),



),







],



),







Align(

alignment:

Alignment.topCenter,



child:

ConfettiWidget(



confettiController:

confettiController,



blastDirectionality:

BlastDirectionality.explosive,


numberOfParticles:

40,


gravity:

0.3,


),



),





],



),




);



}



}
