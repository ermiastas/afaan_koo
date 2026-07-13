import 'package:flutter/material.dart';

import '../models/color_item.dart';
import '../services/content_service.dart';
import '../services/audio_service.dart';



class ColorScreen extends StatefulWidget {


const ColorScreen({super.key});


@override
State<ColorScreen> createState()
=> _ColorScreenState();


}



class _ColorScreenState extends State<ColorScreen>{


final ContentService service =
ContentService();


final AudioService audio =
AudioService();


late Future<List<ColorItem>> colors;



@override
void initState(){

super.initState();

colors =
service.getColors();

}




@override
Widget build(BuildContext context){


return Scaffold(

appBar:

AppBar(

title:
const Text(
"Halluu Koo"
),

),



body:

FutureBuilder<List<ColorItem>>(


future:
colors,


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



if(!snapshot.hasData){

return const Center(

child:
Text(
"Halluun hin jiru"
),

);

}



final list =
snapshot.data!;



return ListView.builder(

itemCount:
list.length,


itemBuilder:(context,index){


final color =
list[index];


return Card(

margin:
const EdgeInsets.all(12),


child:

ListTile(


leading:

Container(

width:50,

height:50,

decoration:

BoxDecoration(

color:

Color(

int.parse(

color.colorCode
.replaceFirst("#","0xff")

),

),

borderRadius:
BorderRadius.circular(10),

),

),



title:

Text(

color.nameOromo,

style:

const TextStyle(

fontSize:25,

fontWeight:
FontWeight.bold,

),

),



subtitle:

Text(
color.nameEnglish
),



trailing:

IconButton(

icon:
const Icon(Icons.volume_up),


onPressed:(){

audio.playSound(
color.sound
);

},

),



),


);


},


);


},


),


);


}


}