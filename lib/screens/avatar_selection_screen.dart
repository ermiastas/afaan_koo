import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../utils/responsive.dart';
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

EdgeInsets.all(Responsive.pagePadding(context)),



itemCount:

avatars.length,



gridDelegate:

Responsive.homeGridDelegate(
context,
childAspectRatio: 1,
crossAxisSpacing: 15,
mainAxisSpacing: 15,
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
