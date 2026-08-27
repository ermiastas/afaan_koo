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
import '../../utils/responsive.dart';

import '../../widgets/background/moving_clouds.dart';
import '../../widgets/daily_mission_card.dart';
import '../../widgets/raji_assistant.dart';

import '../coloring/coloring_home_screen.dart';


class HomeScreen extends StatefulWidget {
  const HomeScreen({
    super.key,
  });

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}


class _HomeScreenState extends State<HomeScreen>
    with SingleTickerProviderStateMixin {

  late AnimationController _controller;

  final Random random = Random();

  String search = "";


  @override
  void initState() {
    super.initState();

    _controller = AnimationController(
      vsync: this,
      duration: const Duration(seconds: 12),
    )..repeat();
  }


  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }


  @override
  Widget build(BuildContext context) {

    final screenWidth =
        MediaQuery.of(context).size.width;


    /*
    ------------------------------------------------
    RESPONSIVE LESSON COLUMNS
    ------------------------------------------------

    Small watch / very small screen:
      1 column

    Phone:
      2–3 columns

    Tablet:
      3–4 columns

    Laptop:
      4–5 columns

    Android TV:
      5–8 columns
    */

    final columns = Responsive.homeColumns(context);


    final progress =
        context.watch<ProgressProvider>();


    final reward =
        context.watch<RewardProvider>();


    final ageProvider =
        context.watch<AgeProvider>();


    final selectedAge =
        ageProvider.age;


    // ============================================
    // AGE + SEARCH FILTER
    // ============================================

    final List<AppLesson> lessons =
        lessonCatalog.where((lesson) {

      final ageMatch =
          lesson.ages.contains(selectedAge);


      final searchMatch =
          lesson.title
              .toLowerCase()
              .contains(
                search.toLowerCase(),
              );


      return ageMatch && searchMatch;

    }).toList();


    return Scaffold(

      body: Stack(

        children: [

          // ========================================
          // SKY BACKGROUND
          // ========================================

          Positioned.fill(

            child: Container(

              decoration:
                  const BoxDecoration(

                gradient:
                    LinearGradient(

                  begin:
                      Alignment.topCenter,

                  end:
                      Alignment.bottomCenter,

                  colors: [

                    Color(0xff8ED6FF),

                    Color(0xffCDEEFF),

                    Color(0xffF7FCFF),

                  ],

                ),

              ),

            ),

          ),


          // ========================================
          // MOVING CLOUDS
          // ========================================

          const MovingClouds(),


          // ========================================
          // ANIMATED BUBBLES
          // ========================================

          AnimatedBuilder(

            animation: _controller,

            builder: (context, child) {

              return CustomPaint(

                painter:
                    BubblePainter(
                  _controller.value,
                ),

                size:
                    Size.infinite,

              );

            },

          ),


          // ========================================
          // MAIN CONTENT
          // ========================================

          SafeArea(

            child:
                SingleChildScrollView(

              padding:
                  EdgeInsets.fromLTRB(
                Responsive.pagePadding(context),
                Responsive.pagePadding(context),
                Responsive.pagePadding(context),
                110,
              ),

              child:

                  Column(

                crossAxisAlignment:
                    CrossAxisAlignment.start,

                children: [

                  // =================================
                  // DAILY MISSION
                  // =================================

                  const DailyMissionCard(),


                  // =================================
                  // TOP BAR
                  // =================================

                  _topBar(),


                  const SizedBox(
                    height: 20,
                  ),


                  // =================================
                  // RAJI
                  // =================================

                  _rajiCard(),


                  // Responsive audio button
                  Align(

                    alignment:
                        Alignment.centerLeft,

                    child:
                        IconButton(

                      tooltip:
                          "Raji sagalee dhaggeeffadhu",

                      icon:
                          const Icon(
                        Icons.volume_up,
                        size: 32,
                      ),

                      onPressed: () {

                        RajiAudioService
                            .welcome();

                      },

                    ),

                  ),


                  const SizedBox(
                    height: 12,
                  ),


                  // =================================
                  // AGE
                  // =================================

                  _ageCard(
                    selectedAge,
                  ),


                  const SizedBox(
                    height: 20,
                  ),


                  // =================================
                  // SEARCH
                  // =================================

                  _searchBox(),


                  const SizedBox(
                    height: 20,
                  ),


                  // =================================
                  // REWARDS
                  // =================================

                  _rewardCard(
                    reward,
                  ),


                  const SizedBox(
                    height: 25,
                  ),


                  // =================================
                  // LESSON TITLE
                  // =================================

                  Text(

                    "🎓 Barnoota Afaan Koo",

                    style: TextStyle(

                      fontSize:
                          screenWidth < 400
                              ? 20
                              : screenWidth < 700
                                  ? 24
                                  : 28,

                      fontWeight:
                          FontWeight.bold,

                    ),

                  ),


                  const SizedBox(
                    height: 15,
                  ),


                  // =================================
                  // LESSON GRID
                  // =================================

                  GridView.builder(

                    shrinkWrap:
                        true,

                    physics:
                        const NeverScrollableScrollPhysics(),

                    itemCount:
                        lessons.length,

                    gridDelegate:

                        SliverGridDelegateWithFixedCrossAxisCount(

                      crossAxisCount:
                          columns,

                      crossAxisSpacing:
                          screenWidth < 500
                              ? 8
                              : 12,

                      mainAxisSpacing:
                          screenWidth < 500
                              ? 10
                              : 14,

                      /*
                      Flexible card ratio.

                      Very small screens need
                      taller cards.

                      Large screens can use
                      wider cards.
                      */

                      childAspectRatio:

                          screenWidth < 280
                              ? 0.95
                              : screenWidth < 420
                                  ? 0.82
                                  : screenWidth < 700
                                      ? 0.78
                                      : 0.85,

                    ),

                    itemBuilder:
                        (context, index) {

                      return _lessonCard(

                        context,

                        lessons[index],

                        progress,

                      );

                    },

                  ),


                  const SizedBox(
                    height: 25,
                  ),


                  // =================================
                  // COLORING
                  // =================================

                  _coloringStudioCard(),

                ],

              ),

            ),

          ),

        ],

      ),

    );

  }


  // =================================================
  // TOP BAR
  // =================================================

  Widget _topBar() {

    final profile =
        context.watch<ProfileProvider>();


    final screenWidth =
        MediaQuery.of(context).size.width;


    final avatarSize =
        screenWidth < 350
            ? 25.0
            : screenWidth < 600
                ? 30.0
                : 35.0;


    final titleSize =
        screenWidth < 350
            ? 20.0
            : screenWidth < 600
                ? 24.0
                : 30.0;


    return Row(

      children: [

        // =========================================
        // AVATAR
        // =========================================

        GestureDetector(

          onTap: () {

            Navigator.pushNamed(
              context,
              "/avatar-selection",
            );

          },

          child: CircleAvatar(

            radius:
                avatarSize,

            child: Text(

              profile.avatar,

              style: TextStyle(

                fontSize:
                    avatarSize * 1.15,

              ),

            ),

          ),

        ),


        const SizedBox(
          width: 10,
        ),


        // =========================================
        // APP NAME
        // =========================================

        Expanded(

          child: Text(

            "Afaan Koo",

            maxLines: 1,

            overflow:
                TextOverflow.ellipsis,

            style: TextStyle(

              fontSize:
                  titleSize,

              fontWeight:
                  FontWeight.bold,

            ),

          ),

        ),


        // =========================================
        // DASHBOARD MENU
        // =========================================

        PopupMenuButton<String>(

          tooltip:
              "Dashboards",

          icon:
              const Icon(
            Icons.dashboard_outlined,
          ),

          onSelected: (route) {

            Navigator.pushNamed(
              context,
              route,
            );

          },

          itemBuilder:
              (context) => [

            const PopupMenuItem<String>(

              value:
                  "/parent_dashboard",

              child: Row(

                children: [

                  Text(
                    "👨‍👩‍👧",
                    style:
                        TextStyle(
                      fontSize: 22,
                    ),
                  ),

                  SizedBox(
                    width: 10,
                  ),

                  Text(
                    "Parent Dashboard",
                  ),

                ],

              ),

            ),


            const PopupMenuItem<String>(

              value:
                  "/teacher_dashboard",

              child: Row(

                children: [

                  Text(
                    "👩‍🏫",
                    style:
                        TextStyle(
                      fontSize: 22,
                    ),
                  ),

                  SizedBox(
                    width: 10,
                  ),

                  Text(
                    "Teacher Dashboard",
                  ),

                ],

              ),

            ),


            const PopupMenuItem<String>(

              value:
                  "/admin_dashboard",

              child: Row(

                children: [

                  Text(
                    "⚙️",
                    style:
                        TextStyle(
                      fontSize: 22,
                    ),
                  ),

                  SizedBox(
                    width: 10,
                  ),

                  Text(
                    "Admin Dashboard",
                  ),

                ],

              ),

            ),

          ],

        ),


        // =========================================
        // SETTINGS
        // =========================================

        Semantics(

          button: true,

          label:
              'Open settings',

          child:
              IconButton.filledTonal(

            tooltip:
                'Settings',

            onPressed: () {

              Navigator.pushNamed(
                context,
                '/settings',
              );

            },

            icon:
                const Icon(
              Icons.settings_outlined,
            ),

          ),

        ),

      ],

    );

  }


  // =================================================
  // AGE CARD
  // =================================================

  Widget _ageCard(
    int age,
  ) {

    String message;


    if (age <= 5) {

      message =
          "👶 Sadarkaa daa'imaa (3-5)";

    } else if (age <= 8) {

      message =
          "🧒 Sadarkaa jalqabaa (6-8)";

    } else {

      message =
          "🚀 Sadarkaa ol'aanaa (9-12)";

    }


    return Semantics(
      button: true,
      label: 'Change age category',
      child: GestureDetector(
        onTap: () => Navigator.of(context).pushNamed('/age-selection'),
        child: Container(

      padding:
          const EdgeInsets.all(16),

      decoration:
          BoxDecoration(

        gradient:
            const LinearGradient(

          colors: [

            Color(0xffFFEAA7),

            Color(0xff81ECEC),

          ],

        ),

        borderRadius:
            BorderRadius.circular(25),

      ),

      child: Row(

        children: [

          const Text(

            "🎯",

            style:
                TextStyle(
              fontSize: 35,
            ),

          ),


          const SizedBox(
            width: 15,
          ),


          Expanded(

            child: Text(

              message,

              style:
                  const TextStyle(

                fontSize: 18,

                fontWeight:
                    FontWeight.bold,

              ),

            ),

          ),

        ],

      ),

        ),
      ),
    );

  }


  // =================================================
  // RAJI CARD
  // =================================================

  Widget _rajiCard() {

    return const RajiAssistant(

      message:
          "Har'a maal baranna? 😊",

      wave: true,

    );

  }


  // =================================================
  // SEARCH
  // =================================================

  Widget _searchBox() {

    return TextField(

      onChanged: (value) {

        setState(() {

          search = value;

        });

      },

      decoration:
          InputDecoration(

        hintText:
            "Barnoota barbaadi 🔍",

        filled:
            true,

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
            const Icon(
          Icons.search,
        ),

      ),

    );

  }


  // =================================================
  // REWARD CARD
  // =================================================

  Widget _rewardCard(
    RewardProvider reward,
  ) {

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

      child: Row(

        mainAxisAlignment:
            MainAxisAlignment.spaceAround,

        children: [

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
    String value,
  ) {

    return Column(

      children: [

        Text(

          icon,

          style:
              const TextStyle(
            fontSize: 30,
          ),

        ),

        Text(

          value,

          style:
              const TextStyle(

            fontSize: 18,

            fontWeight:
                FontWeight.bold,

          ),

        ),

      ],

    );

  }


  // =================================================
  // LESSON CARD
  // =================================================

  Widget _lessonCard(

    BuildContext context,

    AppLesson lesson,

    ProgressProvider progress,

  ) {

    final width =
        MediaQuery.of(context).size.width;


    /*
    Responsive emoji.

    Watch:
      28

    Phone:
      40–50

    Tablet:
      60

    TV:
      75+
    */

    final emojiSize =
        width < 280
            ? 30.0
            : width < 420
                ? 42.0
                : width < 700
                    ? 52.0
                    : width < 1200
                        ? 62.0
                        : 72.0;


    final titleSize =
        width < 280
            ? 10.0
            : width < 420
                ? 12.0
                : width < 700
                    ? 14.0
                    : width < 1200
                        ? 16.0
                        : 18.0;


    final descriptionSize =
        width < 280
            ? 7.0
            : width < 420
                ? 8.0
                : width < 700
                    ? 10.0
                    : 12.0;


    return GestureDetector(

      onTap: () {

        Navigator.pushNamed(
          context,
          lesson.route,
        );

      },

      child: Container(

        padding:

            EdgeInsets.all(

          width < 420
              ? 8
              : width < 700
                  ? 10
                  : 14,

        ),


        decoration:

            BoxDecoration(

          // =======================================
          // TRANSPARENT
          // =======================================

          color:
              Colors.transparent,


          borderRadius:
              BorderRadius.circular(22),


          border:

              Border.all(

            color:
                Colors.white.withValues(
              alpha: 0.65,
            ),

            width: 1.5,

          ),


          boxShadow: [

            BoxShadow(

              color:
                  Colors.black.withValues(
                alpha: 0.05,
              ),

              blurRadius: 10,

              offset:
                  const Offset(0, 4),

            ),

          ],

        ),


        child: Column(

          mainAxisAlignment:
              MainAxisAlignment.center,

          children: [

            // ===================================
            // EMOJI
            // ===================================

            Flexible(

              child: FittedBox(

                fit:
                    BoxFit.contain,

                child: Text(

                  lesson.emoji,

                  style:
                      TextStyle(

                    fontSize:
                        emojiSize,

                  ),

                ),

              ),

            ),


            SizedBox(

              height:
                  width < 420
                      ? 5
                      : 8,

            ),


            // ===================================
            // TITLE
            // ===================================

            Text(

              lesson.title,

              textAlign:
                  TextAlign.center,

              maxLines: 2,

              overflow:
                  TextOverflow.ellipsis,

              style:

                  TextStyle(

                fontSize:
                    titleSize,

                fontWeight:
                    FontWeight.bold,

                color:
                    Colors.black87,

              ),

            ),


            SizedBox(

              height:
                  width < 420
                      ? 3
                      : 5,

            ),


            // ===================================
            // DESCRIPTION
            // ===================================

            Flexible(

              child: Text(

                lesson.description,

                textAlign:
                    TextAlign.center,

                maxLines:
                    width < 420
                        ? 1
                        : 2,

                overflow:
                    TextOverflow.ellipsis,

                style:

                    TextStyle(

                  fontSize:
                      descriptionSize,

                  color:
                      Colors.black54,

                ),

              ),

            ),

          ],

        ),

      ),

    );

  }


  // =================================================
  // COLORING STUDIO
  // =================================================

  Widget _coloringStudioCard() {

    return GestureDetector(

      onTap: () {

        Navigator.push(

          context,

          MaterialPageRoute(

            builder: (_) =>
                const ColoringHomeScreen(),

          ),

        );

      },

      child: Container(

        width:
            double.infinity,

        padding:
            const EdgeInsets.all(16),

        decoration:
            BoxDecoration(

          color:
              Colors.transparent,

          borderRadius:
              BorderRadius.circular(25),

          border:

              Border.all(

            color:
                Colors.white.withValues(
              alpha: 0.65,
            ),

          ),

        ),

        child: Column(

          mainAxisAlignment:
              MainAxisAlignment.center,

          children: [

            const Text(

              "🎨",

              style:
                  TextStyle(
                fontSize: 55,
              ),

            ),

            const SizedBox(
              height: 10,
            ),

            const Text(

              "Halluu Dibuu",

              textAlign:
                  TextAlign.center,

              style:
                  TextStyle(

                fontSize: 18,

                fontWeight:
                    FontWeight.bold,

              ),

            ),

            const SizedBox(
              height: 5,
            ),

            Text(

              "Dibi, kalaqi fi baradhu",

              textAlign:
                  TextAlign.center,

              style:
                  TextStyle(

                color:
                    Colors.grey,

                fontSize: 13,

              ),

            ),

          ],

        ),

      ),

    );

  }

}


// =====================================================
// BUBBLE PAINTER
// =====================================================

class BubblePainter extends CustomPainter {

  final double animation;


  BubblePainter(
    this.animation,
  );


  @override
  void paint(
    Canvas canvas,
    Size size,
  ) {

    final paint =
        Paint()
          ..color =
              Colors.white.withValues(
            alpha: .35,
          );


    for (
      int i = 0;
      i < 20;
      i++
    ) {

      final double x =
          (i * 80) %
              size.width;


      final double y =
          ((i * 120) +
                  animation * 200) %
              size.height;


      canvas.drawCircle(

        Offset(
          x,
          y,
        ),

        20 +
            (i % 5) * 5,

        paint,

      );

    }

  }


  @override
  bool shouldRepaint(
    covariant BubblePainter oldDelegate,
  ) {

    return true;

  }

}
