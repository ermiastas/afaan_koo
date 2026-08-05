import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../providers/class_provider.dart';
import '../models/class_room.dart';
import 'class_details_screen.dart';



class TeacherClassesScreen extends StatelessWidget {


const TeacherClassesScreen({
super.key
});




@override
Widget build(BuildContext context){


final classroom =
context.watch<ClassProvider>();




return Scaffold(



appBar:

AppBar(

title:

const Text(
"Kutaalee koo 🏫"
),

),




floatingActionButton:


FloatingActionButton(


child:

const Icon(Icons.add),


onPressed:(){



showDialog(

context:context,

builder:(context){



final controller =
TextEditingController();



return AlertDialog(



title:

const Text(
"Kuta haaraa uumi"
),





content:

TextField(

controller:
controller,


decoration:

const InputDecoration(

hintText:
"Fakkeenya: Kutaa 1ffaa"

),

),





actions:[



TextButton(

onPressed:(){

Navigator.pop(context);

},


child:

const Text(
"Haqi"
),

),





ElevatedButton(

onPressed:(){


final newClass = ClassRoom(

id:

DateTime.now()
.millisecondsSinceEpoch
.toString(),


name:

controller.text,


grade:

"Grade 1",


);



context
.read<ClassProvider>()
.addClass(newClass);



Navigator.pop(context);


},


child:

const Text(
"Uumi"
),

),



],



);



}

);



},



),







body:


classroom.classes.isEmpty


?

const Center(

child:

Text(
"Kuta hin jiru"
),

)



:


ListView.builder(


padding:
const EdgeInsets.all(16),



itemCount:

classroom.classes.length,



itemBuilder:(context,index){



final item =
classroom.classes[index];




return Card(



child:

ListTile(

  onTap: () {

    Navigator.push(

      context,

      MaterialPageRoute(

        builder: (_) => ClassDetailsScreen(
          classroom: item,
        ),

      ),

    );

  },


leading:

const Icon(
Icons.class_
),



title:

Text(
item.name
),




subtitle:

Text(
item.grade
),



trailing:

const Icon(
Icons.arrow_forward_ios
),



),



);



},


),




);


}


}