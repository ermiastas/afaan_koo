import 'package:cloud_firestore/cloud_firestore.dart';



class FirebaseContentService {



final FirebaseFirestore firestore =

FirebaseFirestore.instance;





Future<void> addContent(

String collection,

String id,

Map<String,dynamic> data

) async {



await firestore

.collection(collection)

.doc(id)

.set(data);


}






Future<List<Map<String,dynamic>>> getCollection(

String collection

) async {



final snapshot =

await firestore

.collection(collection)

.get();



return snapshot.docs

.map(

(e)=>e.data(),

)

.toList();



}



}