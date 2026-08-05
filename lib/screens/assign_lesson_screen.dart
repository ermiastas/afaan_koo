import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../models/lesson_assignment.dart';
import '../providers/assignment_provider.dart';



class AssignLessonScreen extends StatelessWidget {


final String classId;



const AssignLessonScreen({

super.key,

required this.classId,

});





final List<Map<String,String>> lessons = const [


{
"id":"alphabet",
"title":"Qubee Afaan Oromoo",
},


{
"id":"numbers",
"title":"Lakkoofsa",
},


{
"id":"animals",
"title":"Bineensota",
},


{
"id":"culture",
"title":"Aadaa Oromoo",
},


{
"id":"health",
"title":"Fayyaa",
},


];





@override
Widget build(BuildContext context){



return Scaffold(


appBar:

AppBar(

title:

const Text(
"Barnoota Ramadi 📚"
),

),





body:

ListView.builder(


padding:

const EdgeInsets.all(16),



itemCount:

lessons.length,



itemBuilder:

(context,index){



final lesson =
lessons[index];





return Card(


child:

ListTile(



leading:

const Icon(
Icons.menu_book,
),




title:

Text(
lesson['title']!,
),




trailing:

ElevatedButton(



child:

const Text(
"Ramadi",
),




onPressed:(){



final assignment =
LessonAssignment(


id:

DateTime.now()
.millisecondsSinceEpoch
.toString(),


classId:
classId,


lessonId:
lesson['id']!,


lessonTitle:
lesson['title']!,


assignedDate:
DateTime.now(),

);





context

.read<AssignmentProvider>()

.assignLesson(

assignment,

);






ScaffoldMessenger.of(context)

.showSnackBar(

SnackBar(

content:

Text(

"${lesson['title']} ramadameera ✅",

),

),

);





},



),



),



);



},


),



);


}



}