import 'package:flutter/material.dart';

import 'admin/content_editor_screen.dart';


class AdminScreen extends StatelessWidget {


const AdminScreen({super.key});



@override
Widget build(BuildContext context){


return Scaffold(


appBar:

AppBar(

title:

const Text(
"Admin Dashboard 🔐"
),

),




body:

Padding(

padding:

const EdgeInsets.all(20),



child:

Column(


children:[



const CircleAvatar(

radius:50,

child:

Icon(

Icons.admin_panel_settings,

size:50,

),

),





const SizedBox(

height:20,

),





const Text(

"Afaan Koo Admin",

style:

TextStyle(

fontSize:28,

fontWeight:

FontWeight.bold,

),

),





const SizedBox(

height:30,

),





adminButton(

context,

"➕ Add Animal",

Icons.pets,

),




adminButton(

context,

"➕ Add Word",

Icons.menu_book,

),




adminButton(

context,

"➕ Add Story",

Icons.auto_stories,

),




adminButton(

context,

"➕ Add Song",

Icons.music_note,

),





],



),


),


);


}






Widget adminButton(

BuildContext context,

String title,

IconData icon,

){


return Padding(


padding:

const EdgeInsets.all(8),



child:

SizedBox(


width:

double.infinity,



child:

ElevatedButton.icon(

onPressed:(){


Navigator.push(

context,

MaterialPageRoute(

builder:(context)

=>

ContentEditorScreen(
category:title,
),

),

);



},



icon:

Icon(icon),



label:

Text(

title,

style:

const TextStyle(

fontSize:18,

),

),

),



),



);



}


}