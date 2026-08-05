import 'package:flutter/material.dart';
import '../models/number_item.dart';

class NumberCard extends StatelessWidget {

  final NumberItem numberItem;
  final VoidCallback onTap;


  const NumberCard({
    super.key,
    required this.numberItem,
    required this.onTap,
  });


  @override
  Widget build(BuildContext context) {

    return GestureDetector(

      onTap: onTap,

      child: Card(

        elevation: 5,

        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(20),
        ),


        child: Container(

          padding: const EdgeInsets.all(12),

          decoration: BoxDecoration(

            borderRadius: BorderRadius.circular(20),

            gradient: const LinearGradient(
              colors: [
                Color(0xffFFF3CD),
                Color(0xffFFFFFF),
              ],

              begin: Alignment.topLeft,
              end: Alignment.bottomRight,
            ),

          ),


          child: Column(

            mainAxisAlignment: MainAxisAlignment.center,

            children: [


              // Number display
              Text(

                numberItem.number.toString(),

                style: const TextStyle(

                  fontSize: 45,

                  fontWeight: FontWeight.bold,

                  color: Colors.orange,

                ),

              ),



              const SizedBox(height: 8),



              // Image
              Expanded(

                child: Image.asset(

                  numberItem.image,

                  fit: BoxFit.contain,

                  errorBuilder: (context, error, stackTrace) {

                    return const Icon(

                      Icons.image,

                      size: 60,

                      color: Colors.grey,

                    );

                  },

                ),

              ),



              const SizedBox(height: 8),



              // Afaan Oromoo name
              Text(

                numberItem.nameOromo,

                style: const TextStyle(

                  fontSize: 20,

                  fontWeight: FontWeight.bold,

                ),

              ),



              // English name
              Text(

                numberItem.nameEnglish,

                style: const TextStyle(

                  fontSize: 15,

                  color: Colors.grey,

                ),

              ),

            ],

          ),

        ),

      ),

    );

  }

}