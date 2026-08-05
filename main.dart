import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import 'package:afaan_koo_app/app/app.dart';

import 'package:afaan_koo_app/providers/user_provider.dart';
import 'package:afaan_koo_app/providers/reward_provider.dart';
import 'package:afaan_koo_app/providers/progress_provider.dart';
import 'package:afaan_koo_app/providers/admin_provider.dart';
import 'package:afaan_koo_app/providers/age_provider.dart';




void main() {


WidgetsFlutterBinding.ensureInitialized();



runApp(



MultiProvider(


providers:[



ChangeNotifierProvider(

create:(context)

=> UserProvider(),

),



ChangeNotifierProvider(

create:(_)=>
RewardProvider()
..load(),

),


/*
ChangeNotifierProvider(

create:(context)

=> RewardProvider(),

),
*/

ChangeNotifierProvider(

create: (_) =>
AgeProvider(),

),

ChangeNotifierProvider(

create:(context)

=> ProgressProvider(),

),





ChangeNotifierProvider(

create:(context)

=> AdminProvider(),

),



],



child:

const AfaanKooApp(),



),



);
}