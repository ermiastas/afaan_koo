import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../routes/lesson_routes.dart';
import '../screens/splash_screen.dart';
import '../core/theme.dart';
import '../providers/settings_provider.dart';
import '../widgets/app_states.dart';



class AfaanKooApp extends StatelessWidget {


  const AfaanKooApp({
    super.key,
  });



  @override
  Widget build(BuildContext context){


    final themeMode = context.watch<SettingsProvider>().themeMode;

    return MaterialApp(


      debugShowCheckedModeBanner: false,


      title: "Afaan Koo",



      theme:
      AppTheme.theme,

      darkTheme: AppTheme.darkTheme,

      themeMode: themeMode,



      // All lesson navigation routes
      routes:
      lessonRoutes,

      onUnknownRoute: (settings) => MaterialPageRoute(
        settings: settings,
        builder: (_) => Scaffold(
          appBar: AppBar(title: const Text('Page not found')),
          body: AppEmptyState(
            title: 'This lesson is not available',
            message: 'Please return home and choose another activity.',
            icon: Icons.explore_off_outlined,
          ),
        ),
      ),



      // Starting screen
      home:
      const SplashScreen(),



    );


  }


}
