import 'package:flutter/material.dart';


class AdminDashboardScreen extends StatelessWidget {


  const AdminDashboardScreen({
    super.key,
  });



  @override
  Widget build(BuildContext context){


    return Scaffold(

      appBar: AppBar(

        title:
        const Text(
          "Daashboordii Admin",
        ),

      ),



      body: const Center(

        child: Column(

          mainAxisAlignment:
          MainAxisAlignment.center,


          children:[


            Icon(

              Icons.admin_panel_settings,

              size:80,

              color:Colors.red,

            ),


            SizedBox(height:20),


            Text(

              "Bulchiinsa Afaan Koo",

              style:
              TextStyle(

                fontSize:20,

                fontWeight:
                FontWeight.bold,

              ),

            ),


          ],

        ),

      ),

    );

  }

}