import 'package:flutter/material.dart';

import '../models/story.dart';
import '../services/content_service.dart';
import '../services/audio_service.dart';



class StoryScreen extends StatefulWidget {


const StoryScreen({super.key});


@override
State<StoryScreen> createState()
=> _StoryScreenState();


}



class _StoryScreenState extends State<StoryScreen>{


final ContentService service =
ContentService();


final AudioService audio =
AudioService();


late Future<List<Story>> stories;



@override
void initState(){

super.initState();

stories =
service.getStories();

}



@override
Widget build(BuildContext context){


return Scaffold(

appBar:

AppBar(

title:
const Text(
"Seenaa Koo"
),

),



body:

FutureBuilder<List<Story>>(


future:
stories,


builder:(context,snapshot){


if(snapshot.connectionState ==
ConnectionState.waiting){

return const Center(

child:
CircularProgressIndicator(),

);

}



if(snapshot.hasError){

return Center(

child:

Text(
"Dogoggora: ${snapshot.error}"
),

);

}



final list =
snapshot.data ?? [];



return ListView.builder(

itemCount:
list.length,


itemBuilder:(context,index){


final story =
list[index];



return Card(

margin:
const EdgeInsets.all(12),


child:

ExpansionTile(

leading:

Image.asset(

story.image,

width:60,

height:60,

fit:BoxFit.cover,

),



title:

Text(

story.titleOromo,

style:

const TextStyle(

fontSize:22,

fontWeight:
FontWeight.bold,

),

),



subtitle:

Text(
story.titleEnglish
),



children:[



Padding(

padding:
const EdgeInsets.all(15),


child:

Text(

story.storyOromo,

style:

const TextStyle(

fontSize:18,

),

),

),



ElevatedButton.icon(

onPressed:(){

audio.playSound(
story.sound
);

},


icon:

const Icon(Icons.volume_up),


label:

const Text(
"Dhaggeeffadhu"
),


),



],


),


);


},


);


},


),


);


}


}