import 'dart:io';

import 'package:path_provider/path_provider.dart';



class MediaStorageService {



Future<String> saveImage(

String sourcePath,

String fileName,

) async {



final directory =

await getApplicationDocumentsDirectory();



final imageFolder =

Directory(

"${directory.path}/images",

);




if(!await imageFolder.exists()){

await imageFolder.create(

recursive:true,

);

}




final newPath =

"${imageFolder.path}/$fileName";





final file =

File(sourcePath);



await file.copy(newPath);



return newPath;



}







Future<String> saveAudio(

String sourcePath,

String fileName,

) async {



final directory =

await getApplicationDocumentsDirectory();



final audioFolder =

Directory(

"${directory.path}/audio",

);





if(!await audioFolder.exists()){

await audioFolder.create(

recursive:true,

);

}





final newPath =

"${audioFolder.path}/$fileName";





final file =

File(sourcePath);



await file.copy(newPath);



return newPath;



}



}