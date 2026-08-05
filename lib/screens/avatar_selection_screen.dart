import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../providers/profile_provider.dart';



class AvatarSelectionScreen extends StatelessWidget {


const AvatarSelectionScreen({
super.key,
});



@override
Widget build(BuildContext context){



final avatars = [

"😊",
"👦",
"👧",
"🦁",
"🐼",
"🐯",
"🐵",
"🐸",
"🐰",
"🐨",

];



return Scaffold(


appBar:

AppBar(

title:

const Text(
"🎭 Suuraa kee filadhu"
),

),




body:

GridView.builder(


padding:

const EdgeInsets.all(20),



itemCount:

avatars.length,



gridDelegate:

const SliverGridDelegateWithFixedCrossAxisCount(

crossAxisCount:3,

crossAxisSpacing:15,

mainAxisSpacing:15,

),



itemBuilder:(context,index){



return GestureDetector(



onTap:() async {



await context

.read<ProfileProvider>()

.setAvatar(

avatars[index],

);



if(context.mounted){

Navigator.pop(context);

}



},




child:

Container(


decoration:

BoxDecoration(


color:

Colors.white,


borderRadius:

BorderRadius.circular(25),



boxShadow:[

const BoxShadow(

blurRadius:8,

color:Colors.black12,

),

],

),



child:

Center(

child:

Text(

avatars[index],

style:

const TextStyle(

fontSize:50,

),

),

),



),



);



},


),



);



}


}