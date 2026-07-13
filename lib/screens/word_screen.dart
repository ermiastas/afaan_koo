import 'package:flutter/material.dart';

import '../models/word_item.dart';
import '../services/content_service.dart';
import '../widgets/word_card.dart';
import 'word_detail_screen.dart';



class WordScreen extends StatefulWidget {


const WordScreen({super.key});


@override
State<WordScreen> createState()
=> _WordScreenState();


}



class _WordScreenState extends State<WordScreen>{


final ContentService contentService =
ContentService();


late Future<List<WordItem>> words;



@override
void initState(){

super.initState();

words =
contentService.getWords();

}



@override
Widget build(BuildContext context){


return Scaffold(

appBar:

AppBar(

title:
const Text(
"Jechoota Koo"
),

),



body:

FutureBuilder<List<WordItem>>(


future:
words,


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
"Dogoggora: ${snapshot.error}"
),

);

}





if(!snapshot.hasData ||
snapshot.data!.isEmpty){

return const Center(

child:

Text(
"Jechoota hin argamne"
),

);

}




final wordList =
snapshot.data!;



return GridView.builder(


padding:
const EdgeInsets.all(15),



gridDelegate:

const SliverGridDelegateWithFixedCrossAxisCount(

crossAxisCount:2,

),



itemCount:

wordList.length,



itemBuilder:

(context,index){


final item =
wordList[index];



return WordCard(


word:

item.wordOromo,


image:

item.image,



onTap:(){


Navigator.push(

context,

MaterialPageRoute(

builder:(context)

=>

WordDetailScreen(

word:item,

),

),

);


},


);


},


);


},


),


);


}


}