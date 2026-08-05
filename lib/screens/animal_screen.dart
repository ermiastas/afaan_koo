import 'dart:io';

import 'package:flutter/material.dart';

import '../services/content_service.dart';
import '../services/audio_service.dart';

import '../models/animal.dart';

import '../data/lesson_ids.dart';

import '../widgets/lesson_complete_button.dart';



class AnimalScreen extends StatefulWidget {


  const AnimalScreen({

    super.key,

  });



  @override
  State<AnimalScreen> createState()

  => _AnimalScreenState();



}









class _AnimalScreenState

extends State<AnimalScreen>{



final ContentService contentService =

ContentService();



final AudioService audioService =

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

"Bineensa Koo 🐾",

),



centerTitle:true,


),







body:

FutureBuilder<List<Animal>>(



future:

animals,




builder:

(context,snapshot){





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

"Dogoggora: ${snapshot.error}",

),

);



}







if(!snapshot.hasData ||

snapshot.data!.isEmpty){



return const Center(

child:

Text(

"Bineensa hin argamne",

style:

TextStyle(

fontSize:20,

),

),

);



}







final animalList =

snapshot.data!;









return Column(



children:[








Expanded(



child:

GridView.builder(



padding:

const EdgeInsets.all(12),





gridDelegate:

const SliverGridDelegateWithFixedCrossAxisCount(



crossAxisCount:

2,



crossAxisSpacing:

12,



mainAxisSpacing:

12,



childAspectRatio:

0.75,



),







itemCount:

animalList.length,







itemBuilder:

(context,index){



final animal =

animalList[index];









return Card(



elevation:

5,



shape:

RoundedRectangleBorder(



borderRadius:

BorderRadius.circular(20),



),









child:

Column(



children:[





Expanded(



child:

buildAnimalImage(

animal.image,

),



),









Padding(



padding:

const EdgeInsets.all(8),





child:

Text(



animal.nameOromo,





style:

const TextStyle(



fontSize:

22,



fontWeight:

FontWeight.bold,



),



),



),









Text(



animal.nameEnglish,



style:

const TextStyle(



fontSize:

16,



),



),











IconButton(



icon:

const Icon(



Icons.volume_up,



size:

35,



),







onPressed:

(){



audioService.playSound(



animal.sound,



);



},







),






],



),





);



},



),



),









// Lesson Completion


Padding(



padding:

const EdgeInsets.all(16),





child:

LessonCompleteButton(



lessonId:

LessonIds.animals,



),



),







],



);




},



),



);



}














Widget buildAnimalImage(

String image,

){



if(image.isEmpty){



return const Icon(

Icons.pets,

size:80,

);



}







if(image.startsWith("/")){



return ClipRRect(



borderRadius:

BorderRadius.circular(20),





child:

Image.file(



File(image),





fit:

BoxFit.cover,








errorBuilder:

(context,error,stack){



return const Icon(

Icons.broken_image,

size:70,

);



},





),



);



}







return ClipRRect(



borderRadius:

BorderRadius.circular(20),





child:

Image.asset(



image,





fit:

BoxFit.cover,






errorBuilder:

(context,error,stack){



return const Icon(

Icons.broken_image,

size:70,

);



},





),



);



}



}