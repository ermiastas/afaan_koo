import 'package:flutter/material.dart';



class AppAnimations {


  // ==========================
  // Page slide transition
  // ==========================

  static Route slidePage(
      Widget page
      ){

    return PageRouteBuilder(

      transitionDuration:
      const Duration(milliseconds:450),


      pageBuilder:
          (context,animation,secondaryAnimation){

        return page;

      },


      transitionsBuilder:
          (context,animation,secondaryAnimation,child){


        final offsetAnimation =

        Tween<Offset>(

          begin:
          const Offset(1,0),

          end:
          Offset.zero,

        )

            .animate(

          CurvedAnimation(

            parent:animation,

            curve:
            Curves.easeOut,

          ),

        );



        return SlideTransition(

          position:
          offsetAnimation,

          child:child,

        );


      },

    );


  }






  // ==========================
  // Fade transition
  // ==========================


  static Route fadePage(
      Widget page
      ){


    return PageRouteBuilder(

      transitionDuration:
      const Duration(milliseconds:400),


      pageBuilder:
          (_,animation,secondaryAnimation)
          =>
          page,


      transitionsBuilder:
          (_,animation,__,child){


        return FadeTransition(

          opacity:
          animation,


          child:child,

        );


      },


    );


  }




}