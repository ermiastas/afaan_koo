import 'package:shared_preferences/shared_preferences.dart';



class ProgressService {



static const String starsKey="stars";

static const String lessonsKey="lessons";



static Future<void> addStar(int amount) async{


final prefs=

await SharedPreferences.getInstance();



int stars=

prefs.getInt(starsKey) ?? 0;



await prefs.setInt(

starsKey,

stars + amount,

);


}




static Future<int> getStars() async{


final prefs=

await SharedPreferences.getInstance();


return prefs.getInt(starsKey) ?? 0;


}




static Future<void> completeLesson() async{


final prefs=

await SharedPreferences.getInstance();



int lessons=

prefs.getInt(lessonsKey) ?? 0;



await prefs.setInt(

lessonsKey,

lessons+1,

);


}



static Future<int> getLessons() async{


final prefs=

await SharedPreferences.getInstance();


return prefs.getInt(lessonsKey) ?? 0;


}



}