import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../../services/local_content_service.dart';
import '../../services/media_service.dart';
import '../../providers/video_catalog_provider.dart';



class EditContentScreen extends StatefulWidget {


  final String category;

  final Map<String,dynamic> content;



  const EditContentScreen({

    super.key,

    required this.category,

    required this.content,

  });



  @override
  State<EditContentScreen> createState()

  => _EditContentScreenState();


}









class _EditContentScreenState

extends State<EditContentScreen>{



final LocalContentService storage =

LocalContentService();



final MediaService media =

MediaService();





final Map<String,TextEditingController> fields = {};





String? imagePath;

String? audioPath;



bool saving = false;









@override
void initState(){

super.initState();


createFields();


loadData();


}









void createFields(){



List<String> fieldNames;



switch(widget.category){



case "animals":

fieldNames=[

"nameOromo",

"nameEnglish",

"animalType",

];

break;




case "words":

fieldNames=[

"wordOromo",

"wordEnglish",

];

break;




case "alphabet":

fieldNames=[

"letter",

"wordOromo",

"wordEnglish",

];

break;




case "quiz":

fieldNames=[

"question",

"option1",

"option2",

"option3",

"option4",

"answer",

];

break;




case "stories":

fieldNames=[

"titleOromo",

"titleEnglish",

"storyOromo",

"storyEnglish",

];

break;




case "songs":

fieldNames=[

"titleOromo",

"titleEnglish",

"singer",

"lyricsOromo",

"lyricsEnglish",

];

break;




case "videos":

fieldNames=[

"title",

"description",

"videoUrl",

];

break;



default:

fieldNames=[

"title",

"english",

"description",

];

}



for(final name in fieldNames){

fields[name]=

TextEditingController();

}



}









void loadData(){



fields.forEach((key,controller){



controller.text =

widget.content[key]

??

"";



});



imagePath =

widget.content["image"];



audioPath =

widget.content["sound"];



}









@override
Widget build(BuildContext context){



return Scaffold(



appBar:

AppBar(

title:

Text(

"Edit ${widget.category}",

),

),





body:

SingleChildScrollView(



padding:

const EdgeInsets.all(20),



child:

Column(



children:[



...fields.entries.map(



(entry){



return Padding(



padding:

const EdgeInsets.only(

bottom:15,

),



child:

TextField(



controller:

entry.value,



maxLines:

entry.key.contains("story") ||

entry.key.contains("lyrics")

?

5

:

1,



decoration:

InputDecoration(



labelText:

formatLabel(entry.key),



border:

const OutlineInputBorder(),

),



),



);



},



),







Row(



mainAxisAlignment:

MainAxisAlignment.spaceAround,



children:[



ElevatedButton.icon(



onPressed:

pickImage,



icon:

const Icon(Icons.image),



label:

const Text("Change Image"),



),





ElevatedButton.icon(



onPressed:

pickAudio,



icon:

const Icon(Icons.audio_file),



label:

const Text("Change Audio"),



),



],



),






if(widget.category == "videos")

ElevatedButton.icon(

onPressed: pickVideo,

icon: const Icon(Icons.video_file_outlined),

label: const Text("Select Video File"),

),



const SizedBox(height:30),






ElevatedButton.icon(



onPressed:

saving

?

null

:

updateContent,



icon:

const Icon(Icons.save),



label:

Text(

saving

?

"Saving..."

:

"Update",

),



),




],



),



),



);



}









String formatLabel(String value){


return value

.replaceAll(

RegExp(r'([A-Z])'),

" \$1",

)

.replaceFirst(

value[0],

value[0].toUpperCase(),

);


}









Future<void> pickImage() async {



final result =

await media.pickImage();



if(!mounted)return;



if(result != null){



setState((){

imagePath=result.path;

});



}



}









Future<void> pickAudio() async {



final result =

await media.pickAudio();



if(!mounted)return;



if(result != null){



setState((){

audioPath=result.path;

});



}



}









Future<void> pickVideo() async {



final result = await media.pickVideo();



if(!mounted || result == null || result.path == null)return;



setState((){

fields["videoUrl"]?.text = result.path!;

});



}



Future<void> updateContent() async {



setState((){

saving=true;

});







final Map<String,dynamic> data = {



"id":

widget.content["id"],



"category":

widget.category,



"image":

imagePath ?? "",



"sound":

audioPath ?? "",



};






fields.forEach((key,value){



data[key]=

value.text.trim();



});









if(widget.category=="animals"){



data["title"]=

data["nameOromo"];



data["english"]=

data["nameEnglish"];



}






if(widget.category=="words"){



data["title"]=

data["wordOromo"];



data["english"]=

data["wordEnglish"];



}






if(widget.category=="alphabet"){



data["title"]=

data["wordOromo"];



data["english"]=

data["wordEnglish"];



}






if(widget.category=="quiz"){



data["options"]=[



data["option1"],

data["option2"],

data["option3"],

data["option4"],



];



}









await storage.updateContent(

widget.category,

data,

);



if(widget.category=="videos"){

await context.read<VideoCatalogProvider>().load();

}








if(!mounted)return;



Navigator.pop(context);



}






}
