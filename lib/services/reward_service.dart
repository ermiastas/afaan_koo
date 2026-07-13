import 'package:shared_preferences/shared_preferences.dart';


class RewardService{


Future<void> addStars(int value) async{


final prefs =
await SharedPreferences.getInstance();


int stars =
prefs.getInt("stars") ?? 0;


await prefs.setInt(

"stars",

stars + value,

);


}



Future<int> getStars() async{


final prefs =
await SharedPreferences.getInstance();


return prefs.getInt("stars") ?? 0;


}


}
