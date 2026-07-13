import 'package:flutter/material.dart';



class AdminContentEditorScreen extends StatefulWidget {


final String category;



const AdminContentEditorScreen({

super.key,

required this.category,

});



@override
State<AdminContentEditorScreen> createState()

=> _AdminContentEditorScreenState();


}






class _AdminContentEditorScreenState

extends State<AdminContentEditorScreen>{



final titleController =
TextEditingController();


final englishController =
TextEditingController();


final imageController =
TextEditingController();


final soundController =
TextEditingController();





@override
Widget build(BuildContext context){



return Scaffold(



appBar:

AppBar(

title:

Text(widget.category),

),




body:

Padding(


padding:

const EdgeInsets.all(20),



child:

ListView(


children:[




TextField(

controller:

titleController,

decoration:

const InputDecoration(

labelText:

"Oromo name"

),

),




TextField(

controller:

englishController,

decoration:

const InputDecoration(

labelText:

"English name"

),

),





TextField(

controller:

imageController,

decoration:

const InputDecoration(

labelText:

"Image path"

),

),





TextField(

controller:

soundController,

decoration:

const InputDecoration(

labelText:

"Sound path"

),

),





const SizedBox(

height:30,

),





ElevatedButton.icon(


onPressed:

saveContent,


icon:

const Icon(Icons.save),


label:

const Text(

"Save Content"

),


),





],



),



),



);


}






void saveContent(){



final item = {


"id":

DateTime.now()
.millisecondsSinceEpoch
.toString(),



"title":

titleController.text,



"english":

englishController.text,



"image":

imageController.text,



"sound":

soundController.text,



};





debugPrint(item.toString());





ScaffoldMessenger.of(context)
.showSnackBar(

const SnackBar(

content:

Text(

"Content saved successfully ⭐"

),

),

);





}



}