import 'dart:io';

import 'package:firebase_storage/firebase_storage.dart';
import 'package:logger/logger.dart';



class StorageService {



final FirebaseStorage storage =
FirebaseStorage.instance;



final Logger logger =
Logger();





// ===============================
// Upload Image
// ===============================

Future<String?> uploadImage(

String filePath,

String folder,

) async {


try {


final file =

File(filePath);



final fileName =

DateTime.now()

.millisecondsSinceEpoch

.toString();





final ref =

storage

.ref()

.child(folder)

.child(

"$fileName.jpg"

);





await ref.putFile(file);





final url =

await ref.getDownloadURL();



return url;



}

catch(e,stackTrace){


logger.e(

"Image upload failed",

error:e,

stackTrace:stackTrace,

);



return null;


}



}









// ===============================
// Upload Audio
// ===============================

Future<String?> uploadAudio(

String filePath,

String folder,

) async {



try {



final file =

File(filePath);



final fileName =

DateTime.now()

.millisecondsSinceEpoch

.toString();





final ref =

storage

.ref()

.child(folder)

.child(

"$fileName.mp3"

);





await ref.putFile(file);





final url =

await ref.getDownloadURL();





return url;



}

catch(e,stackTrace){



logger.e(

"Audio upload failed",

error:e,

stackTrace:stackTrace,

);



return null;


}



}








// ===============================
// Delete File
// ===============================

Future<void> deleteFile(

String url

) async {



try {



final ref =

storage

.refFromURL(url);



await ref.delete();



}

catch(e,stackTrace){



logger.e(

"File deletion failed",

error:e,

stackTrace:stackTrace,

);



}



}



}