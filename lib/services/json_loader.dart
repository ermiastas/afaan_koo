import 'dart:convert';
import 'package:flutter/services.dart';



class JsonLoader {


Future<List<dynamic>> loadJson(String path) async {


final data =
await rootBundle.loadString(path);


return json.decode(data);


}



Future<List<dynamic>> animals() {

return loadJson(
"lib/content/animals/animals.json"
);

}



Future<List<dynamic>> colors() {

return loadJson(
"lib/content/colors/colors.json"
);

}



Future<List<dynamic>> numbers() {

return loadJson(
"lib/content/numbers/numbers.json"
);

}



Future<List<dynamic>> words() {

return loadJson(
"lib/content/words/words.json"
);

}



Future<List<dynamic>> stories() {

return loadJson(
"lib/content/stories/stories.json"
);

}



Future<List<dynamic>> songs() {

return loadJson(
"lib/content/songs/songs.json"
);

}

Future<List<dynamic>> letters() {

  return loadJson(
    "lib/content/alphabet/letters.json"
  );

}


Future<List<dynamic>> quizzes(){

return loadJson(
"lib/content/quizzes/quizzes.json"
);

}

Future<List<dynamic>> kooreeMessages(){

return loadJson(

"lib/content/kooree/messages.json"

);

}

}