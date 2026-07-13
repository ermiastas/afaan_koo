import 'package:flutter/material.dart';

import '../services/content_service.dart';
import '../services/audio_service.dart';
import '../models/animal.dart';



class AnimalScreen extends StatefulWidget {

  const AnimalScreen({super.key});


  @override
  State<AnimalScreen> createState()
  => _AnimalScreenState();

}



class _AnimalScreenState extends State<AnimalScreen> {


final ContentService contentService =
ContentService();


final AudioService audio =
AudioService();


late Future<List<Animal>> animals;



@override
void initState(){

  super.initState();


  animals =
  contentService.getAnimals();

}





@override
Widget build(BuildContext context){


return Scaffold(

appBar:

AppBar(

title:
const Text(
"Bineensa Koo"
),

),



body:

FutureBuilder<List<Animal>>(


future:
animals,


builder:
(context,snapshot){



// Loading

if(snapshot.connectionState ==
ConnectionState.waiting){

return const Center(

child:
CircularProgressIndicator(),

);

}



// Error handling

if(snapshot.hasError){

return Center(

child:
Text(
"Dogoggora: ${snapshot.error}"
),

);

}



// Empty data

if(!snapshot.hasData ||
snapshot.data!.isEmpty){

return const Center(

child:
Text(
"Bineensa hin argamne"
),

);

}




final animalList =
snapshot.data!;



return ListView.builder(


itemCount:
animalList.length,



itemBuilder:
(context,index){


final animal =
animalList[index];



return Card(

margin:
const EdgeInsets.all(12),

elevation:5,


child:

Column(

children:[



Image.asset(

animal.image,

height:150,

),




Text(

animal.nameOromo,

style:

const TextStyle(

fontSize:25,

fontWeight:
FontWeight.bold,

),

),





Text(

animal.nameEnglish,

style:

const TextStyle(

fontSize:18,

),

),





ElevatedButton.icon(


onPressed:(){


audio.playSound(
animal.sound
);


},



icon:

const Icon(
Icons.volume_up,
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