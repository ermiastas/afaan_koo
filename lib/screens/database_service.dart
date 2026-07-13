import 'package:cloud_firestore/cloud_firestore.dart';


class DatabaseService {


final db =
FirebaseFirestore.instance;



Future<void> saveProgress(

String userId,

Map<String,dynamic> data

) async{


await db

.collection("progress")

.doc(userId)

.set(data);


}


}
