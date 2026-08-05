import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import 'content_manager_screen.dart';
import '../../providers/admin_provider.dart';



class AdminScreen extends StatelessWidget {


const AdminScreen({

super.key,

});





@override
Widget build(BuildContext context){



final categories = [


{
"name":"Animals",
"icon":Icons.pets,
"color":Colors.green,
},


{
"name":"Alphabet",
"icon":Icons.abc,
"color":Colors.orange,
},


{
"name":"Words",
"icon":Icons.menu_book,
"color":Colors.blue,
},


{
"name":"Colors",
"icon":Icons.color_lens,
"color":Colors.purple,
},


{
"name":"Numbers",
"icon":Icons.numbers,
"color":Colors.red,
},


{
"name":"Stories",
"icon":Icons.auto_stories,
"color":Colors.brown,
},


{
"name":"Songs",
"icon":Icons.music_note,
"color":Colors.teal,
},


{
"name":"Quiz",
"icon":Icons.quiz,
"color":Colors.indigo,
},


];







return Scaffold(



appBar:

AppBar(

title:

const Text(

"Admin Dashboard 🔐",

),

actions:[


IconButton(

tooltip:"Sign out",

icon:const Icon(Icons.logout),

onPressed:(){

context.read<AdminProvider>().logout();

Navigator.of(context).pop();

},

),

],

),







body:

GridView.builder(



padding:

const EdgeInsets.all(15),





gridDelegate:

SliverGridDelegateWithFixedCrossAxisCount(



crossAxisCount:

MediaQuery.of(context).size.width >= 600 ? 3 : 2,



crossAxisSpacing:

15,



mainAxisSpacing:

15,



),







itemCount:

categories.length,








itemBuilder:

(context,index){



final item =

categories[index];







return Card(



elevation:

5,



shape:

RoundedRectangleBorder(

borderRadius:

BorderRadius.circular(20),

),








child:

InkWell(



borderRadius:

BorderRadius.circular(20),



onTap:

(){



Navigator.push(



context,



MaterialPageRoute(



builder:

(context)

=>

ContentManagerScreen(



category:

item["name"] as String,



),



),



);



},






child:

Column(



mainAxisAlignment:

MainAxisAlignment.center,



children:[



Icon(

item["icon"] as IconData,

size:55,

color:

item["color"] as Color,

),





const SizedBox(

height:15,

),





Text(



item["name"] as String,



style:

const TextStyle(



fontSize:20,



fontWeight:

FontWeight.bold,



),



),





],



),



),



);



},



),



);



}



}
