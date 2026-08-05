import 'dart:convert';

import 'package:flutter/foundation.dart';
import 'package:shared_preferences/shared_preferences.dart';



class LocalContentService {




String _key(String category){

return "content_${category.toLowerCase()}";

}








Future<void> addContent(

String category,

Map<String,dynamic> content,

) async {



final prefs =

await SharedPreferences.getInstance();



final key =

_key(category);





List<Map<String,dynamic>> existing =

await getContent(category);





existing.add(content);





await prefs.setString(

key,

jsonEncode(existing),

);



}









Future<List<Map<String,dynamic>>> getContent(

String category,

) async {



try {



final prefs =

await SharedPreferences.getInstance();



final saved =

prefs.getString(

_key(category),

);





if(saved == null || saved.isEmpty){



return [];



}







final List<dynamic> decoded =

jsonDecode(saved);






return decoded

.map(

(item)=>

Map<String,dynamic>.from(item),

)

.toList();






}

catch(error){



debugPrint(

"Local content loading error: $error",

);



return [];



}



}









Future<void> updateContent(

String category,

Map<String,dynamic> updated,

) async {



final items =

await getContent(category);





final index =

items.indexWhere(

(item)=>

item["id"] == updated["id"],

);







if(index == -1){



return;



}






items[index] = updated;







final prefs =

await SharedPreferences.getInstance();






await prefs.setString(

_key(category),

jsonEncode(items),

);



}









Future<void> deleteContent(

String category,

String id,

) async {



final items =

await getContent(category);





items.removeWhere(

(item)=>

item["id"] == id,

);






final prefs =

await SharedPreferences.getInstance();






await prefs.setString(

_key(category),

jsonEncode(items),

);



}









Future<void> clearCategory(

String category,

) async {



final prefs =

await SharedPreferences.getInstance();





await prefs.remove(

_key(category),

);



}









Future<void> clearAll() async {



final prefs =

await SharedPreferences.getInstance();





final keys =

prefs.getKeys();






for(final key in keys){



if(key.startsWith("content_")){



await prefs.remove(key);



}



}



}








Future<int> getContentCount(

String category,

) async {



final items =

await getContent(category);



return items.length;



}



}