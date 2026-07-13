import 'package:flutter/material.dart';

import '../services/content_service.dart';
import '../models/letter.dart';
import '../widgets/letter_card.dart';
import 'letter_detail_screen.dart';



class AlphabetScreen extends StatefulWidget {


const AlphabetScreen({super.key});


@override
State<AlphabetScreen> createState()
=> _AlphabetScreenState();


}



class _AlphabetScreenState extends State<AlphabetScreen> {


final ContentService contentService =
ContentService();


late Future<List<Letter>> letters;



@override
void initState(){

super.initState();


letters =
contentService.getLetters();


}



@override
Widget build(BuildContext context){


return Scaffold(

appBar:

AppBar(

title:
const Text(
"Qubee Koo"
),

),



body:

FutureBuilder<List<Letter>>(


future:
letters,


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
"Qubee hin argamne"
),

);

}





final letterList =
snapshot.data!;



return GridView.builder(


padding:
const EdgeInsets.all(15),



gridDelegate:

const SliverGridDelegateWithFixedCrossAxisCount(

crossAxisCount:2,

),



itemCount:

letterList.length,



itemBuilder:

(context,index){


final item =
letterList[index];



return LetterCard(


letter:

item.letter,


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

LetterDetailScreen(

letter:item,

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