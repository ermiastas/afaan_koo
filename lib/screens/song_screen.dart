import 'package:flutter/material.dart';

import '../models/song.dart';
import '../services/content_service.dart';
import '../services/audio_service.dart';



class SongScreen extends StatefulWidget {


const SongScreen({super.key});


@override
State<SongScreen> createState()
=> _SongScreenState();


}



class _SongScreenState extends State<SongScreen>{


final ContentService service =
ContentService();


final AudioService audio =
AudioService();


late Future<List<Song>> songs;



@override
void initState(){

super.initState();

songs =
service.getSongs();

}




@override
Widget build(BuildContext context){


return Scaffold(

appBar:

AppBar(

title:
const Text(
"Sirba Koo"
),

),



body:

FutureBuilder<List<Song>>(


future:
songs,


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


final song =
list[index];



return Card(

margin:
const EdgeInsets.all(12),


child:

Column(

children:[



Image.asset(

song.image,

height:150,

),



Text(

song.titleOromo,

style:

const TextStyle(

fontSize:25,

fontWeight:
FontWeight.bold,

),

),



Text(
song.titleEnglish
),



Text(
"🎤 ${song.singer}"
),



Padding(

padding:
const EdgeInsets.all(12),


child:

Text(

song.lyricsOromo,

style:

const TextStyle(

fontSize:18,

),

),

),



ElevatedButton.icon(

onPressed:(){

audio.playSound(
song.sound
);

},


icon:

const Icon(
Icons.play_arrow
),


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