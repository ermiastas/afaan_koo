import 'dart:io';

import 'package:flutter/material.dart';

import '../../services/firebase_content_service.dart';
import '../../services/media_service.dart';
import '../../services/storage_service.dart';



class ContentEditorScreen extends StatefulWidget {


final String category;



const ContentEditorScreen({

super.key,

required this.category,

});



@override
State<ContentEditorScreen> createState()

=> _ContentEditorScreenState();


}






class _ContentEditorScreenState

extends State<ContentEditorScreen>{



final FirebaseContentService firebase =
FirebaseContentService();



final MediaService media =
MediaService();


final StorageService storage =
StorageService();


final titleController =
TextEditingController();



final englishController =
TextEditingController();



final descriptionController =
TextEditingController();





String? imagePath;

String? audioPath;



bool saving=false;







@override
Widget build(BuildContext context){



return Scaffold(



appBar:

AppBar(

title:

Text(

"Add ${widget.category}"

),

),





body:

SingleChildScrollView(


padding:

const EdgeInsets.all(20),



child:

Column(

children:[




buildField(

titleController,

"Oromo name",

),





buildField(

englishController,

"English name",

),





buildField(

descriptionController,

"Description",

),





const SizedBox(height:20),





// IMAGE PICKER

ElevatedButton.icon(

onPressed:

pickImage,


icon:

const Icon(

Icons.image,

),


label:

const Text(

"Choose Image"

),


),






if(imagePath != null)

Padding(

padding:

const EdgeInsets.all(10),


child:

Image.file(

File(imagePath!),

height:150,

),

),







// AUDIO PICKER


ElevatedButton.icon(

onPressed:

pickAudio,


icon:

const Icon(

Icons.audio_file,

),


label:

const Text(

"Choose Sound"

),


),





if(audioPath != null)

Text(

"Audio selected 🎵",

style:

const TextStyle(

color:Colors.green,

),

),







const SizedBox(height:30),







ElevatedButton.icon(



onPressed:

saving

?

null

:

saveContent,




icon:

const Icon(

Icons.save,

),




label:

Text(

saving

?

"Saving..."

:

"Save Content",

),



),




],



),



),



);



}









Widget buildField(

TextEditingController controller,

String label,

){



return Padding(


padding:

const EdgeInsets.only(

bottom:15,

),



child:

TextField(

controller:

controller,


decoration:

InputDecoration(

labelText:

label,

border:

const OutlineInputBorder(),

),



),



);



}









Future<void> pickImage() async {



final result =

await media.pickImage();



if(result != null){


setState(() {


imagePath=result;


});


}



}







Future<void> pickAudio() async {



final result =

await media.pickAudio();



if(result != null){


setState(() {


audioPath=result;


});


}



}

Future<void> saveContent() async {


if(titleController.text.isEmpty){


ScaffoldMessenger.of(context)
.showSnackBar(

const SnackBar(

content:

Text(
"Please enter Oromo name"
),

),

);


return;

}



setState(() {

saving=true;

});



try {


final id =

DateTime.now()

.millisecondsSinceEpoch

.toString();





String? imageUrl;

String? soundUrl;





// Upload image

if(imagePath != null){


imageUrl =

await storage.uploadImage(

imagePath!,

widget.category.toLowerCase(),

);


}





// Upload audio

if(audioPath != null){


soundUrl =

await storage.uploadAudio(

audioPath!,

"audio/${widget.category.toLowerCase()}",

);


}







final data = {


"id":

id,


"title":

titleController.text,


"english":

englishController.text,


"image":

imageUrl ?? "",


"sound":

soundUrl ?? "",


"description":

descriptionController.text,


"category":

widget.category.toLowerCase(),



};







await firebase.addContent(

widget.category.toLowerCase(),

id,

data,

);







if(!mounted)return;





ScaffoldMessenger.of(context)

.showSnackBar(

const SnackBar(

content:

Text(
"Content uploaded successfully ⭐"
),

),

);





Navigator.pop(context);





}

catch(e){



if(!mounted)return;



ScaffoldMessenger.of(context)

.showSnackBar(

SnackBar(

content:

Text(

"Upload failed: $e"

),

),

);



}





finally{



if(mounted){


setState(() {

saving=false;

});


}



}



}






}