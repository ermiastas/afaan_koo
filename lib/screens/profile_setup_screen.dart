import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../providers/profile_provider.dart';



class ProfileSetupScreen extends StatefulWidget {


const ProfileSetupScreen({
super.key,
});



@override
State<ProfileSetupScreen> createState()
=> _ProfileSetupScreenState();


}




class _ProfileSetupScreenState
extends State<ProfileSetupScreen>{


final controller =
TextEditingController();




@override
Widget build(BuildContext context){



return Scaffold(


appBar:

AppBar(

title:

const Text(
"👋 Maqaa kee galchi"
),

),




body:

Padding(

padding:

const EdgeInsets.all(25),



child:

Column(

children:[



const Text(

"Raji maqaa kee beekuu barbaada 😊",

textAlign:
TextAlign.center,

style:

TextStyle(

fontSize:20,

fontWeight:
FontWeight.bold,

),

),



const SizedBox(height:30),




TextField(

controller:
controller,


decoration:

InputDecoration(

labelText:
"Maqaa daa'imaa",

hintText:
"Fakkeenya: Sami",

border:

OutlineInputBorder(

borderRadius:

BorderRadius.circular(20),

),

),



),




const SizedBox(height:30),





ElevatedButton.icon(


icon:

const Icon(Icons.check),



label:

const Text(
"Itti fufi"
),



onPressed:() async {



if(controller.text.trim().isEmpty){

return;

}



await context

.read<ProfileProvider>()

.setName(

controller.text.trim(),

);



if(context.mounted){

Navigator.pop(context);

}


},



),




],


),


),


);



}


}