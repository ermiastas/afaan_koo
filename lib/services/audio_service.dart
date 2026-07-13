import 'package:audioplayers/audioplayers.dart';


class AudioService {


final AudioPlayer _player =
AudioPlayer();



Future<void> playSound(String fileName) async {


await _player.play(

AssetSource(
"audio/$fileName"
),

);


}



Future<void> stop() async{

await _player.stop();

}


}