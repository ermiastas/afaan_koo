import 'package:supabase_flutter/supabase_flutter.dart';


class DatabaseService {


final db = Supabase.instance.client;



Future<void> saveProgress(

String userId,

Map<String,dynamic> data

) async{


await db.from('progress').upsert({
  ...data,
  'user_id': userId,
  'updated_at': DateTime.now().toIso8601String(),
});


}


}
