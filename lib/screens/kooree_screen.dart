import 'package:flutter/material.dart';

import '../models/assistant_message.dart';
import '../services/content_service.dart';
import '../widgets/kooree_widget.dart';



class KooreeScreen extends StatefulWidget {


const KooreeScreen({super.key});



@override
State<KooreeScreen> createState()
=> _KooreeScreenState();


}





class _KooreeScreenState extends State<KooreeScreen>{



final ContentService service =
ContentService();



late Future<List<AssistantMessage>> messages;





@override
void initState(){

super.initState();


messages =
service.getKooreeMessages();


}






@override
Widget build(BuildContext context){


return Scaffold(



appBar:

AppBar(

title:

const Text(
"Kooree 🐻"
),

),





body:

FutureBuilder<List<AssistantMessage>>(



future:

messages,




builder:(context,snapshot){



if(snapshot.connectionState ==
ConnectionState.waiting){


return const Center(

child:

CircularProgressIndicator(),

);


}




if(snapshot.hasError){


return Center(

child:

Text(

"Dogoggora: ${snapshot.error}",

),

);


}





if(!snapshot.hasData ||
snapshot.data!.isEmpty){


return const Center(

child:

Text(

"Ergaan Kooree hin jiru",

),

);


}





final message =

snapshot.data!.first;





return Center(



child:

KooreeWidget(



message:

message.message,


),


);




},



),



);


}



}