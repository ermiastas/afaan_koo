import 'package:flutter/material.dart';

import '../models/number_item.dart';
import '../services/content_service.dart';
import '../services/audio_service.dart';



class NumberScreen extends StatefulWidget {


const NumberScreen({super.key});


@override
State<NumberScreen> createState()
=> _NumberScreenState();


}



class _NumberScreenState extends State<NumberScreen>{


final ContentService service =
ContentService();


final AudioService audio =
AudioService();


late Future<List<NumberItem>> numbers;



@override
void initState(){

super.initState();

numbers =
service.getNumbers();

}




@override
Widget build(BuildContext context){


return Scaffold(

appBar:

AppBar(

title:
const Text(
"Lakkoofsa Koo"
),

),



body:

FutureBuilder<List<NumberItem>>(


future:
numbers,


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
"Lakkoofsi hin jiru"
),

);

}



final list =
snapshot.data!;



return GridView.builder(


padding:
const EdgeInsets.all(15),



gridDelegate:

const SliverGridDelegateWithFixedCrossAxisCount(

crossAxisCount:2,

),



itemCount:

list.length,



itemBuilder:(context,index){


final number =
list[index];



return Card(

elevation:5,


child:

InkWell(

onTap:(){

audio.playSound(
number.sound
);

},


child:

Column(

mainAxisAlignment:
MainAxisAlignment.center,


children:[



Text(

number.number.toString(),

style:

const TextStyle(

fontSize:60,

fontWeight:
FontWeight.bold,

),

),



Text(

number.nameOromo,

style:

const TextStyle(

fontSize:25,

),

),



Text(

number.nameEnglish,

),



],


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