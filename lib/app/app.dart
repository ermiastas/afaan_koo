import 'package:flutter/material.dart';

import '../screens/splash_screen.dart';
import '../core/theme.dart';
// import '../providers/admin_provider.dart';



class AfaanKooApp extends StatelessWidget {


const AfaanKooApp({super.key});



@override
Widget build(BuildContext context){


return MaterialApp(

debugShowCheckedModeBanner:false,


title:"Afaan Koo",


theme:
AppTheme.theme,


home:
const SplashScreen(),


);


}


}