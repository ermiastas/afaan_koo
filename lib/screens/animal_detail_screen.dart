import 'package:flutter/material.dart';
import '../data/animal_data.dart';
import '../services/audio_service.dart';


class AnimalDetailScreen extends StatelessWidget {

  final Animal animal;

  AnimalDetailScreen({
    super.key,
    required this.animal,
  });


  final AudioService audio = AudioService();


  @override
  Widget build(BuildContext context) {

    return Scaffold(

      appBar: AppBar(
        title: Text(animal.nameOromo),
      ),


      body: Center(

        child: Column(

          mainAxisAlignment:
          MainAxisAlignment.center,


          children: [

            Image.asset(
              animal.image,
              height:250,
            ),


            Text(
              animal.nameOromo,
              style:
              const TextStyle(
                fontSize:40,
                fontWeight:FontWeight.bold,
              ),
            ),


            Text(
              animal.nameEnglish,
              style:
              const TextStyle(
                fontSize:25,
              ),
            ),


            const SizedBox(height:20),


            ElevatedButton.icon(

              onPressed:(){

                audio.playSound(
                  animal.sound,
                );

              },

              icon:
              const Icon(
                Icons.volume_up,
              ),

              label:
              const Text(
                "Sagalee dhaggeeffadhu",
              ),

            )

          ],
        ),
      ),
    );
  }
}