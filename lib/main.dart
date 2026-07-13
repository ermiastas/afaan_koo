import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:firebase_core/firebase_core.dart';

import 'app/app.dart';

import 'providers/user_provider.dart';
import 'providers/reward_provider.dart';
import 'providers/progress_provider.dart';
import 'providers/admin_provider.dart';



void main() async {

WidgetsFlutterBinding.ensureInitialized();


await Firebase.initializeApp();



runApp(



MultiProvider(


providers:[



ChangeNotifierProvider(

create:(context)

=> UserProvider(),

),





ChangeNotifierProvider(

create:(context)

=> RewardProvider(),

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