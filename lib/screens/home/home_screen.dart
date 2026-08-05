import 'dart:math';

import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../../data/lesson_catalog.dart';
import '../../models/app_lesson.dart';

import '../../providers/age_provider.dart';
import '../../providers/profile_provider.dart';
import '../../providers/progress_provider.dart';
import '../../providers/reward_provider.dart';
import '../../services/raji_audio_service.dart';
import '../../widgets/background/moving_clouds.dart';
import '../../widgets/daily_mission_card.dart';
import '../../widgets/raji_assistant.dart';
import '../coloring/coloring_home_screen.dart';


class HomeScreen extends StatefulWidget {

  const HomeScreen({
    super.key,
  });


  @override
  State<HomeScreen> createState() =>
      _HomeScreenState();




}



class _HomeScreenState extends State<HomeScreen>
    with SingleTickerProviderStateMixin {



  late AnimationController _controller;


  final Random random = Random();



  String search = "";



  @override
  void initState(){

    super.initState();


    _controller = AnimationController(

      vsync:this,

      duration:
      const Duration(seconds:12),

    )..repeat();


  }



  @override
  void dispose(){

    _controller.dispose();

    super.dispose();

  }






@override
Widget build(BuildContext context){

  final screenWidth = MediaQuery.of(context).size.width;

// Desired width of each lesson card.
const double cardWidth = 180;

// Calculate how many cards fit.
final int columns =
    (screenWidth / cardWidth).floor().clamp(2, 8);

  final progress =
      context.watch<ProgressProvider>();


  final reward =
      context.watch<RewardProvider>();


  final ageProvider =
      context.watch<AgeProvider>();


  final selectedAge =
      ageProvider.age;



  // ================================
  // AGE + SEARCH FILTER
  // ================================


  List<AppLesson> lessons =


  lessonCatalog.where((lesson){


    final ageMatch =

    lesson.ages.contains(selectedAge);



    final searchMatch =

    lesson.title

        .toLowerCase()

        .contains(

        search.toLowerCase()

    );



    return ageMatch && searchMatch;



  }).toList();






return Scaffold(
  body: Stack(
    children: [

      // Sky background
      Positioned.fill(
        child: Container(
          decoration: const BoxDecoration(
            gradient: LinearGradient(
              begin: Alignment.topCenter,
              end: Alignment.bottomCenter,
              colors: [
                Color(0xff8ED6FF),
                Color(0xffCDEEFF),
                Color(0xffF7FCFF),
              ],
            ),
          ),
        ),
      ),

     
      const MovingClouds(),
     
     
     
      // Animated bubbles
      AnimatedBuilder(
        animation: _controller,
        builder: (context, child) {
          return CustomPaint(
            painter: BubblePainter(_controller.value),
            size: Size.infinite,
          );
        },
      ),




        SafeArea(



          child:


          SingleChildScrollView(



            padding:

            const EdgeInsets.fromLTRB(16, 16, 16, 110),




            child:


            Column(



              crossAxisAlignment:

              CrossAxisAlignment.start,




              children:[





                const DailyMissionCard(),





                _topBar(),





                const SizedBox(height:20),




              


                // Raji


                _rajiCard(),

                IconButton(
                  icon: const Icon(
                    Icons.volume_up,
                    size: 35,
                  ),
                  onPressed: () {
                    RajiAudioService.welcome();
                  },
                ),

                const SizedBox(height:20),






                // Age display


                _ageCard(selectedAge),





                const SizedBox(height:20),






                _searchBox(),





                const SizedBox(height:20),






                _rewardCard(reward),






                const SizedBox(height:25),






                const Text(


                  "🎓 Barnoota Afaan Koo",


                  style:


                  TextStyle(


                    fontSize:24,


                    fontWeight:

                    FontWeight.bold,


                  ),


                ),






                const SizedBox(height:15),






                // Lessons Grid
                Builder(
                  builder: (context) {
                    final ageLessons = lessons
                        .where((lesson) => lesson.ages.contains(selectedAge))
                        .toList();

                    return GridView.builder(
                      shrinkWrap: true,
                      physics: const NeverScrollableScrollPhysics(),
                      itemCount: ageLessons.length,
                      gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                        crossAxisCount: columns,
                        childAspectRatio: 0.68,
                        crossAxisSpacing: 8,
                        mainAxisSpacing: 12,
                      ),
                      itemBuilder: (context, index) {
                        return _lessonCard(
                          context,
                          ageLessons[index],
                          progress,
                        );
                      },
                    );
                  },
                ),



                const SizedBox(height:25),






                _dashboardSection(context),





              ],


            ),


          ),


        ),



      ],


    ),


  );



}


Widget _ageCard(int age){


String message;


if(age <=5){

  message =
  "👶 Sadarkaa daa'imaa (3-5)";

}

else if(age <=8){

  message =
  "🧒 Sadarkaa jalqabaa (6-8)";

}

else{

  message =
  "🚀 Sadarkaa ol'aanaa (9-12)";

}



return Container(


padding:

const EdgeInsets.all(16),



decoration:

BoxDecoration(


gradient:

const LinearGradient(


colors:[

Color(0xffFFEAA7),

Color(0xff81ECEC),

],


),


borderRadius:

BorderRadius.circular(25),


),



child:


Row(



children:[



const Text(

"🎯",

style:

TextStyle(

fontSize:35,

),

),




const SizedBox(width:15),




Expanded(



child:


Text(


message,


style:

const TextStyle(


fontSize:18,


fontWeight:

FontWeight.bold,


),


),


),



],



),



);

//final profile =
//context.watch<ProfileProvider>();

}




Widget _topBar(){


final profile =
context.watch<ProfileProvider>();

return Row(


mainAxisAlignment:
MainAxisAlignment.spaceBetween,


children:[

GestureDetector(

onTap:(){

Navigator.pushNamed(

context,

"/avatar-selection",

);

},


child:

CircleAvatar(

radius:35,


child:

Text(

profile.avatar,

style:

const TextStyle(

fontSize:40,

),

),


),

),

const Text(

"Afaan Koo",

style:

TextStyle(

fontSize:30,

fontWeight:
FontWeight.bold,

),

),




Semantics(
  button: true,
  label: 'Open settings',
  child: IconButton.filledTonal(
    tooltip: 'Settings',
    onPressed: () => Navigator.pushNamed(context, '/settings'),
    icon: const Icon(Icons.settings_outlined),
  ),
),



],


);


}







Widget _rajiCard() {

  return const RajiAssistant(

    message:
        "Har'a maal baranna? 😊",

    wave: true,

  );

}






Widget _searchBox(){


return TextField(


onChanged:(value){

setState((){

search=value;

});

},


decoration:

InputDecoration(


hintText:

"Barnoota barbaadi 🔍",



filled:true,

fillColor:
Colors.white,


border:

OutlineInputBorder(

borderRadius:
BorderRadius.circular(25),

borderSide:
BorderSide.none,

),


prefixIcon:

const Icon(Icons.search),


),


);


}









Widget _rewardCard(
RewardProvider reward
){


return Container(


padding:
const EdgeInsets.all(18),


decoration:

BoxDecoration(

color:
Colors.white,

borderRadius:
BorderRadius.circular(25),

),



child:

Row(

mainAxisAlignment:
MainAxisAlignment.spaceAround,


children:[


_reward(
"⭐",
reward.stars.toString(),
),



_reward(
"🪙",
reward.coins.toString(),
),



_reward(
"🏆",
"Lv ${reward.level}",
),



],


),



);


}





Widget _reward(
String icon,
String value
){

return Column(

children:[


Text(
icon,
style:
const TextStyle(fontSize:30),
),


Text(

value,

style:

const TextStyle(

fontSize:18,

fontWeight:
FontWeight.bold,

),

),


],


);


}








Widget _lessonCard(
  BuildContext context,
  AppLesson lesson,
  progress,
) {

  return GestureDetector(

    onTap: () {

      Navigator.pushNamed(
        context,
        lesson.route,
      );

    },


    child: Container(

      padding: const EdgeInsets.all(12),

      decoration: BoxDecoration(

        color: Colors.white.withValues(alpha: .92),

        borderRadius:
        BorderRadius.circular(25),

        boxShadow:[

          BoxShadow(

            color: Colors.black.withValues(alpha: .08),

            blurRadius:12,

            offset:const Offset(0,5),

          ),

        ],

      ),


      child: Column(

        mainAxisAlignment:
        MainAxisAlignment.center,


        children: [


          // BIG EMOJI
          AnimatedContainer(

            duration:
            const Duration(milliseconds:300),


            child: Text(

              lesson.emoji,

              style: const TextStyle(

                fontSize: 75,

              ),

            ),

          ),



          const SizedBox(height:12),



          Text(

            lesson.title,

            textAlign:
            TextAlign.center,


            style: const TextStyle(

              fontSize:16,

              fontWeight:
              FontWeight.bold,

              color:
              Colors.black87,

            ),

          ),



          const SizedBox(height:6),



          Text(

            lesson.description,

            textAlign:
            TextAlign.center,


            maxLines:2,


            overflow:
            TextOverflow.ellipsis,


            style: TextStyle(

              fontSize:11,

              color:
              Colors.black54,

            ),

          ),



        ],

      ),

    ),

  );
}




Widget _coloringStudioCard(){

  return GestureDetector(

    onTap:(){

      Navigator.push(

        context,

        MaterialPageRoute(

          builder:(_)=>

              const ColoringHomeScreen(),

        ),

      );

    },


    child: Container(


      padding:

      const EdgeInsets.all(16),



      decoration:

      BoxDecoration(


        color:

        Colors.white,



        borderRadius:

        BorderRadius.circular(25),



        boxShadow:[


          BoxShadow(

            color:

            Colors.black.withValues(alpha: 0.08),


            blurRadius:12,


            offset:

            const Offset(0,5),


          ),


        ],


      ),



      child:

      Column(


        mainAxisAlignment:

        MainAxisAlignment.center,


        children:[



          const Text(

            "🎨",

            style:

            TextStyle(

              fontSize:55,

            ),

          ),



          const SizedBox(

            height:10,

          ),



          const Text(

            "Halluu Dibuu",

            textAlign:

            TextAlign.center,


            style:

            TextStyle(

              fontSize:18,

              fontWeight:

              FontWeight.bold,

            ),

          ),



          const SizedBox(

            height:5,

          ),



          Text(

            "Dibi, kalaqi fi baradhu",

            textAlign:

            TextAlign.center,


            style:

            TextStyle(

              color:

              Colors.grey,

              fontSize:13,

            ),

          ),



        ],


      ),


    ),


  );


}



Widget _dashboardSection(
BuildContext context
){


return Column(


crossAxisAlignment:
CrossAxisAlignment.start,


children:[



const Text(

"📊 Dashboards",

style:

TextStyle(

fontSize:24,

fontWeight:
FontWeight.bold,

),

),



const SizedBox(height:15),



Row(

children:[


_dashboardButton(

context,

"👨‍👩‍👧 Parent",

"/parent_dashboard",

Colors.green,

),



_dashboardButton(

context,

"👩‍🏫 Teacher",

"/teacher_dashboard",

Colors.blue,

),



_dashboardButton(

context,

"⚙️ Admin",

"/admin_dashboard",

Colors.red,

),



],


),



],


);


}






Widget _dashboardButton(

BuildContext context,

String text,

String route,

Color color,

){


return Expanded(

child:

Padding(

padding:

const EdgeInsets.all(5),


child:

ElevatedButton(

style:

ElevatedButton.styleFrom(

backgroundColor:
color,

padding:
const EdgeInsets.all(15),

shape:

RoundedRectangleBorder(

borderRadius:
BorderRadius.circular(20),

),

),


onPressed:(){

Navigator.pushNamed(
context,
route,
);

},



child:

Text(

text,

textAlign:
TextAlign.center,

style:

const TextStyle(

color:
Colors.white,

),

),


),


),


);



}



}








class BubblePainter extends CustomPainter{


final double animation;


BubblePainter(this.animation);



@override

void paint(Canvas canvas, Size size){


final paint =
Paint()
..color =
Colors.white.withValues(alpha:.35);



for(int i=0;i<20;i++){


double x =
(i*80)%size.width;



double y =
((i*120)+animation*200)
%size.height;



canvas.drawCircle(

Offset(x,y),

20+(i%5)*5,

paint,

);


}



}



@override

bool shouldRepaint(
covariant BubblePainter oldDelegate
){

return true;

}


}
