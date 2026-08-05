import 'package:shared_preferences/shared_preferences.dart';


class RewardService {


static const String xpKey = "xp";

static const String coinKey = "coins";

static const String lessonKey = "lessons";

static const String streakKey = "streak";

static const String starKey = "stars";

static const String gameKey = "games_completed";




// LESSON COMPLETION

static Future<void> completeLesson() async {


final prefs =
await SharedPreferences.getInstance();


int xp =
prefs.getInt(xpKey) ?? 0;


int coins =
prefs.getInt(coinKey) ?? 0;


int lessons =
prefs.getInt(lessonKey) ?? 0;



await prefs.setInt(
xpKey,
xp + 50,
);



await prefs.setInt(
coinKey,
coins + 10,
);



await prefs.setInt(
lessonKey,
lessons + 1,
);


}





// ADD XP

static Future<void> addXP(int amount) async {


final prefs =
await SharedPreferences.getInstance();


int xp =
prefs.getInt(xpKey) ?? 0;



await prefs.setInt(

xpKey,

xp + amount,

);


}





// ADD COINS

static Future<void> addCoins(int amount) async {


final prefs =
await SharedPreferences.getInstance();


int coins =
prefs.getInt(coinKey) ?? 0;



await prefs.setInt(

coinKey,

coins + amount,

);


}





// ADD STARS

static Future<void> addStars(int amount) async {


final prefs =
await SharedPreferences.getInstance();


int stars =
prefs.getInt(starKey) ?? 0;



await prefs.setInt(

starKey,

stars + amount,

);


}





// ADD COMPLETED GAMES

static Future<void> addGameCompleted() async {


final prefs =
await SharedPreferences.getInstance();


int games =
prefs.getInt(gameKey) ?? 0;



await prefs.setInt(

gameKey,

games + 1,

);


}





// GET XP

static Future<int> getXP() async {


final prefs =
await SharedPreferences.getInstance();


return prefs.getInt(xpKey) ?? 0;


}





// GET COINS

static Future<int> getCoins() async {


final prefs =
await SharedPreferences.getInstance();


return prefs.getInt(coinKey) ?? 0;


}





// GET STARS

static Future<int> getStars() async {


final prefs =
await SharedPreferences.getInstance();


return prefs.getInt(starKey) ?? 0;


}





// GET LESSONS

static Future<int> getLessons() async {


final prefs =
await SharedPreferences.getInstance();


return prefs.getInt(lessonKey) ?? 0;


}





// GET GAMES

static Future<int> getGamesCompleted() async {


final prefs =
await SharedPreferences.getInstance();


return prefs.getInt(gameKey) ?? 0;


}


}