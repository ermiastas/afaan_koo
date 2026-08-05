import 'package:image_picker/image_picker.dart';
import 'package:file_picker/file_picker.dart';



class MediaService {


final ImagePicker picker =

ImagePicker();





Future<String?> pickImage() async {


final result = await picker.pickImage(

source: ImageSource.gallery,

);



return result?.path;



}








Future<String?> pickAudio() async {



final result = await FilePicker.platform.pickFiles(



type:

FileType.audio,



);



return result?.files.single.path;



}



}