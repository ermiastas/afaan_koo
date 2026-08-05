import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../../data/lesson_catalog.dart';
import '../../models/app_lesson.dart';

import '../../providers/progress_provider.dart';
import '../../providers/reward_provider.dart';


class HomeScreen extends StatefulWidget {

  const HomeScreen({
    super.key,
  });


  @override
  State<HomeScreen> createState()
      => _HomeScreenState();

}




class _HomeScreenState
    extends State<HomeScreen>
    with SingleTickerProviderStateMixin {


  late AnimationController controller;


  @override
  void initState(){

    super.initState();


    controller =
        AnimationController(
          vsync:this,
          duration:
          const Duration(seconds:10),
        )
          ..repeat();


  }



  @override
  void dispose(){

    controller.dispose();

    super.dispose();

  }





  @override
  Widget build(BuildContext context){


    final progress =
    context.watch<ProgressProvider>();


    final reward =
    context.watch<RewardProvider>();




    final categories =
    lessonCatalog
        .map((e)=>e.category)
        .toSet()
        .toList();




    return Scaffold(


      backgroundColor:
      const Color(0xffF4FAFF),



      body:

      Stack(

        children:[



          AnimatedBuilder(

            animation:controller,

            builder:(context,child){

              return CustomPaint(

                painter:
                BubblePainter(
                  controller.value,
                ),

                size:
                Size.infinite,

              );

            },

          ),






          SafeArea(

            child:

            SingleChildScrollView(

              padding:
              const EdgeInsets.all(16),



              child:

              Column(

                crossAxisAlignment:
                CrossAxisAlignment.start,


                children:[



                  _topBar(),



                  const SizedBox(height:20),



                  _rajiCard(),



                  const SizedBox(height:20),



                  _rewardCard(
                    reward,
                  ),



                  const SizedBox(height:25),




                  _specialCards(
                    context,
                  ),





                  const SizedBox(height:25),




                  ...categories.map((category){


                    final lessons =
                    lessonCatalog
                        .where(
                          (l)=>
                      l.category ==
                          category,
                    )
                        .toList();



                    return _categorySection(

                      context,

                      category,

                      lessons,

                      progress,

                    );


                  }),




                ],


              ),


            ),


          ),


        ],


      ),


    );


  }






Widget _topBar(){


return Row(

mainAxisAlignment:
MainAxisAlignment.spaceBetween,


children:[



const Text(

"Afaan Koo 🌈",

style:

TextStyle(

fontSize:28,

fontWeight:
FontWeight.bold,

),

),




CircleAvatar(

radius:25,

backgroundColor:
Colors.white,

child:

const Text(

"😊",

style:

TextStyle(
fontSize:30,
),

),

),



],


);


}







Widget _rajiCard(){


return Container(

padding:
const EdgeInsets.all(20),


decoration:

BoxDecoration(

gradient:

const LinearGradient(

colors:[

Color(0xff74ebd5),

Color(0xffACB6E5),

],

),


borderRadius:
BorderRadius.circular(30),


),



child:

const Row(

children:[


CircleAvatar(

radius:35,

child:

Text(

"🤖",

style:

TextStyle(
fontSize:35,
),

),

),



SizedBox(width:15),



Expanded(

child:

Column(

crossAxisAlignment:
CrossAxisAlignment.start,

children:[


Text(

"Raji 👋",

style:

TextStyle(

fontSize:24,

fontWeight:
FontWeight.bold,

),

),



Text(

"Baga nagaan dhufta!\nBarnoota keenya haa jalqabnu!",

),

],


),

),



],


),


);


}







Widget _rewardCard(
RewardProvider reward
){


return Card(

shape:

RoundedRectangleBorder(

borderRadius:
BorderRadius.circular(25),

),


child:

Padding(

padding:
const EdgeInsets.all(20),


child:

Row(

mainAxisAlignment:
MainAxisAlignment.spaceAround,


children:[


_reward(
"⭐",
reward.stars.toString(),
"Urjii"
),



_reward(
"🪙",
reward.coins.toString(),
"Saantima"
),



_reward(
"🏆",
"Lv ${reward.level}",
"Sadarkaa"
),


],


),


),


);


}





Widget _reward(
String icon,
String value,
String title
){


return Column(

children:[


Text(

icon,

style:

const TextStyle(
fontSize:30,
),

),


Text(

value,

style:

const TextStyle(

fontWeight:
FontWeight.bold,

fontSize:18,

),

),


Text(title),


],


);


}








Widget _specialCards(
BuildContext context){


return Column(

children:[



_specialCard(

context,

"⭐ Quiz",

"Barnoota kee qoradhu",

Colors.orange,

"/quiz",

),



_specialCard(

context,

"👨‍👩‍👧 Parent Dashboard",

"Hordoffii ijoollee",

Colors.green,

"/parent",

),



_specialCard(

context,

"👩‍🏫 Teacher Dashboard",

"Hordoffii barattootaa",

Colors.blue,

"/teacher",

),



_specialCard(

context,

"⚙️ Admin Dashboard",

"Bulchiinsa app",

Colors.purple,

"/admin",

),



],


);


}






Widget _specialCard(
BuildContext context,
String title,
String subtitle,
Color color,
String route
){


return Container(

margin:

const EdgeInsets.only(
bottom:12,
),



child:

InkWell(

borderRadius:
BorderRadius.circular(20),


onTap:(){

Navigator.pushNamed(
context,
route,
);

},


child:

Container(

padding:
const EdgeInsets.all(18),


decoration:

BoxDecoration(

color:color,

borderRadius:
BorderRadius.circular(20),

),


child:

Row(

children:[


const Icon(

Icons.star,

color:Colors.white,

size:35,

),



const SizedBox(width:15),



Column(

crossAxisAlignment:
CrossAxisAlignment.start,

children:[


Text(

title,

style:

const TextStyle(

color:Colors.white,

fontSize:20,

fontWeight:
FontWeight.bold,

),

),



Text(

subtitle,

style:

const TextStyle(

color:Colors.white70,

),

),


],


)


],


),


),


),


);


}








Widget _categorySection(
BuildContext context,
String category,
List<AppLesson> lessons,
ProgressProvider progress
){


return Column(

crossAxisAlignment:
CrossAxisAlignment.start,


children:[


Text(

category,

style:

const TextStyle(

fontSize:23,

fontWeight:
FontWeight.bold,

),

),




SizedBox(

height:190,


child:

ListView.builder(

scrollDirection:
Axis.horizontal,

itemCount:
lessons.length,


itemBuilder:(context,index){


return _lessonCard(

context,

lessons[index],

progress,

);


},

),


),



const SizedBox(height:20),


],


);


}








Widget _lessonCard(
BuildContext context,
AppLesson lesson,
ProgressProvider progress
){


final completed =
progress.isCompleted(
lesson.id,
);



return InkWell(

onTap:(){

Navigator.pushNamed(

context,

lesson.route,

);

},



child:

Container(

width:150,

margin:

const EdgeInsets.only(
right:15,
),


decoration:

BoxDecoration(

color:
lesson.color,

borderRadius:
BorderRadius.circular(25),

),



child:

Stack(

children:[


Center(

child:

Column(

mainAxisAlignment:
MainAxisAlignment.center,


children:[


Icon(

lesson.icon,

size:55,

color:
Colors.white,

),



const SizedBox(height:10),



Text(

lesson.title,

textAlign:
TextAlign.center,

style:

const TextStyle(

color:Colors.white,

fontWeight:
FontWeight.bold,

),

),


],


),


),




if(completed)

const Positioned(

right:8,

top:8,

child:

Icon(

Icons.check_circle,

color:Colors.white,

size:30,

),

),



],


),


),


);


}


}






class BubblePainter extends CustomPainter {


final double value;


BubblePainter(this.value);



@override

void paint(Canvas canvas,Size size){


final paint =
Paint()
..color =
Colors.blue.withValues(alpha:.08);



for(int i=0;i<20;i++){


final x =
(i*70)%size.width;


final y =
((i*120)+value*300)%size.height;



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
)=>true;


}