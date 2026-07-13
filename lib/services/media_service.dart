import 'dart:io';

import 'package:file_picker/file_picker.dart';
import 'package:image_picker/image_picker.dart';



class MediaService {



final ImagePicker picker =
ImagePicker();





// ==============================
// PICK IMAGE
// ==============================

Future<String?> pickImage() async {


try {


final XFile? image =

await picker.pickImage(


source:

ImageSource.gallery,



imageQuality:

85,


maxWidth:

1200,


);



if(image == null){

return null;

}



final file =

File(image.path);



if(await file.exists()){


return file.path;


}



return null;



}

catch(e){


return null;


}



}








// ==============================
// PICK AUDIO
// ==============================

Future<String?> pickAudio() async {


try {


final result =

await FilePicker.platform.pickFiles(


type:

FileType.audio,



allowMultiple:

false,


);



if(result == null){

return null;

}




final path =

result.files.single.path;




if(path == null){

return null;

}




final file =

File(path);




if(await file.exists()){


return path;


}



return null;



}

catch(e){


return null;


}



}






// ==============================
// CHECK FILE
// ==============================

Future<bool> fileExists(

String? path

) async {


if(path == null){

return false;

}



return File(path).exists();



}



}