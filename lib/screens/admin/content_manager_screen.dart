import 'dart:io';

import 'package:flutter/material.dart';

import '../../services/local_content_service.dart';

import 'content_editor_screen.dart';
import 'edit_content_screen.dart';



class ContentManagerScreen extends StatefulWidget {


  final String category;


  const ContentManagerScreen({

    super.key,

    required this.category,

  });



  @override
  State<ContentManagerScreen> createState()

  => _ContentManagerScreenState();


}






class _ContentManagerScreenState

extends State<ContentManagerScreen>{



final LocalContentService service =

LocalContentService();




List<Map<String,dynamic>> contents = [];



bool loading = true;





@override
void initState(){

super.initState();

loadContent();

}







Future<void> loadContent() async {


setState((){

loading = true;

});



final data =

await service.getContent(

widget.category,

);




if(!mounted)return;



setState((){

contents = data;

loading = false;

});



}








@override
Widget build(BuildContext context){


return Scaffold(



appBar:

AppBar(


title:

Text(

"${widget.category} Manager",

),



actions:[


IconButton(

icon:

const Icon(Icons.refresh),


onPressed:

loadContent,


),


],


),






body:



loading



?

const Center(

child:

CircularProgressIndicator(),

)





:

contents.isEmpty



?

emptyView()



:

ListView.builder(



padding:

const EdgeInsets.all(15),



itemCount:

contents.length,



itemBuilder:

(context,index){



final item =

contents[index];





return Card(


elevation:

5,



margin:

const EdgeInsets.only(

bottom:15,

),





child:

ListTile(





leading:

buildImage(

item["image"] ?? "",

),






title:

Text(

getTitle(item),

style:

const TextStyle(

fontWeight:

FontWeight.bold,

),

),





subtitle:

Text(

getSubtitle(item),

),





trailing:

PopupMenuButton(



itemBuilder:

(context){


return [


const PopupMenuItem(

value:"edit",

child:

Text("Edit"),

),



const PopupMenuItem(

value:"delete",

child:

Text("Delete"),

),



];


},




onSelected:

(value){



if(value=="edit"){


editContent(item);


}



else if(value=="delete"){


deleteContent(

item["id"],

);


}



},



),




),



);



},



),







floatingActionButton:

FloatingActionButton.extended(



icon:

const Icon(Icons.add),



label:

const Text("Add"),



onPressed:

addContent,



),




);


}









Widget emptyView(){



return const Center(



child:

Column(



mainAxisAlignment:

MainAxisAlignment.center,



children:[



Icon(

Icons.folder_open,

size:70,

),



SizedBox(

height:15,

),



Text(

"No content",

style:

TextStyle(

fontSize:20,

),

),



],



),



);


}









Widget buildImage(String image){



if(image.isEmpty){


return const CircleAvatar(

child:

Icon(Icons.image),

);


}




if(image.startsWith("/")){


return CircleAvatar(

backgroundImage:

FileImage(

File(image),

),

);


}




return CircleAvatar(

backgroundImage:

AssetImage(image),

);


}









void addContent(){



Navigator.push(



context,



MaterialPageRoute(



builder:

(context)

=>

ContentEditorScreen(



category:

widget.category,



),



),



).then(

(_)=>loadContent(),

);



}









void editContent(

Map<String,dynamic> item

){



Navigator.push(



context,



MaterialPageRoute(



builder:

(context)

=>

EditContentScreen(



category:

widget.category,



content:

item,



),



),



).then(

(_)=>loadContent(),

);



}









Future<void> deleteContent(

String id

) async {



await service.deleteContent(

widget.category,

id,

);




if(!mounted)return;



loadContent();



}









String getTitle(

Map<String,dynamic> item

){



switch(widget.category){



case "animals":

return item["nameOromo"]

??

item["title"]

??

"";




case "words":

return item["wordOromo"]

??

item["title"]

??

"";




case "alphabet":

return item["letter"]

??

item["title"]

??

"";




case "quiz":

return item["question"]

??

item["title"]

??

"";




case "stories":

return item["titleOromo"]

??

item["title"]

??

"";




case "songs":

return item["titleOromo"]

??

item["title"]

??

"";




default:

return item["title"]

??

"";



}



}









String getSubtitle(

Map<String,dynamic> item

){



switch(widget.category){



case "animals":

return item["nameEnglish"]

??

item["english"]

??

"";




case "words":

return item["wordEnglish"]

??

item["english"]

??

"";




case "alphabet":

return item["wordEnglish"]

??

item["english"]

??

"";




case "songs":

return item["singer"]

??

"";




case "quiz":

return item["answer"]

??

"";




default:

return item["english"]

??

"";



}



}



}