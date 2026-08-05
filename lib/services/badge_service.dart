import 'package:shared_preferences/shared_preferences.dart';



class BadgeService {



static const String key="unlocked_badges";




static Future<void> unlockBadge(

String badgeId

) async {



final prefs =

await SharedPreferences.getInstance();



List<String> badges =

prefs.getStringList(key) ?? [];



if(!badges.contains(badgeId)){


badges.add(badgeId);



await prefs.setStringList(

key,

badges,

);


}


}




static Future<List<String>> getBadges()

async{


final prefs =

await SharedPreferences.getInstance();



return prefs.getStringList(key) ?? [];

}



}