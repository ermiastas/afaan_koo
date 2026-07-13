import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import 'package:afaan_koo_app/app/app.dart';

import 'package:afaan_koo_app/providers/user_provider.dart';
import 'package:afaan_koo_app/providers/reward_provider.dart';
import 'package:afaan_koo_app/providers/progress_provider.dart';



void main(){


runApp(

MultiProvider(

providers:[


ChangeNotifierProvider(

create:(context)
=>
UserProvider(),

),


ChangeNotifierProvider(

create:(context)
=>
RewardProvider(),

),


ChangeNotifierProvider(

create:(context)
=>
ProgressProvider(),

),


],


child:

const AfaanKooApp(),


),

);


}