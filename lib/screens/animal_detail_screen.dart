import 'package:flutter/material.dart';

import '../data/animal_data.dart';
import '../services/audio_service.dart';



class AnimalDetailScreen extends StatelessWidget {


  final Animal animal;



  AnimalDetailScreen({

    super.key,

    required this.animal,

  });



  final AudioService audio =
      AudioService();





  @override
  Widget build(BuildContext context) {



    return Scaffold(



      appBar:

      AppBar(


        title:

        Text(

          animal.nameOromo,

        ),


        centerTitle:true,


      ),







      body:

      SingleChildScrollView(



        padding:

        const EdgeInsets.all(20),






        child:

        Column(



          children:[







            // =========================
            // Animal Image
            // =========================


            Container(



              padding:

              const EdgeInsets.all(20),




              decoration:

              BoxDecoration(



                color:

                Colors.white,



                borderRadius:

                BorderRadius.circular(30),




                boxShadow:[



                  BoxShadow(



                    blurRadius:10,



                    color:

                    Colors.black12,



                  ),



                ],



              ),





              child:

              ClipRRect(



                borderRadius:

                BorderRadius.circular(25),





                child:

                Image.asset(



                  animal.image,



                  height:250,



                  fit:

                  BoxFit.cover,




                  errorBuilder:

                  (context,error,stack){



                    return const Icon(



                      Icons.pets,



                      size:120,



                    );


                  },



                ),



              ),



            ),







            const SizedBox(height:25),







            // =========================
            // Oromo Name
            // =========================


            Text(



              animal.nameOromo,



              textAlign:

              TextAlign.center,



              style:

              const TextStyle(



                fontSize:40,



                fontWeight:

                FontWeight.bold,



              ),



            ),







            const SizedBox(height:8),








            Text(



              animal.nameEnglish,



              style:

              const TextStyle(



                fontSize:25,



                color:

                Colors.grey,



              ),



            ),







            const SizedBox(height:25),







            // =========================
            // Audio Button
            // =========================


            SizedBox(



              width:

              double.infinity,





              child:

              ElevatedButton.icon(




                style:

                ElevatedButton.styleFrom(



                  padding:

                  const EdgeInsets.symmetric(



                    vertical:15,



                  ),





                  shape:

                  RoundedRectangleBorder(



                    borderRadius:

                    BorderRadius.circular(25),



                  ),



                ),





                onPressed:(){



                  audio.playSound(



                    animal.sound,



                  );



                },





                icon:

                const Icon(



                  Icons.volume_up,



                  size:30,



                ),





                label:

                const Text(



                  "Sagalee dhaggeeffadhu 🔊",



                  style:

                  TextStyle(



                    fontSize:18,



                  ),



                ),



              ),



            ),







            const SizedBox(height:25),







            // =========================
            // Learning Message
            // =========================


            Card(



              child:

              const Padding(



                padding:

                EdgeInsets.all(16),





                child:

                Text(



                  "Bineensi kun maal akka ta'e baradhu. "

                  "Maqaa isaa dubbadhu, sagalee isaa dhaggeeffadhu.",





                  textAlign:

                  TextAlign.center,



                  style:

                  TextStyle(



                    fontSize:17,



                  ),



                ),



              ),



            ),





          ],



        ),



      ),



    );

  }


}