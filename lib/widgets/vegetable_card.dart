import 'package:flutter/material.dart';

import '../models/vegetable_item.dart';

class VegetableCard extends StatelessWidget {

  final VegetableItem vegetable;

  final VoidCallback onTap;

  const VegetableCard({

    super.key,

    required this.vegetable,

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

                Color(0xffE8F5E9),

                Color(0xffffffff),

              ],

              begin: Alignment.topLeft,

              end: Alignment.bottomRight,

            ),

          ),

          child: Column(

            mainAxisAlignment: MainAxisAlignment.center,

            children: [

              Expanded(

                child: Image.asset(

                  vegetable.image,

                  fit: BoxFit.contain,

                  errorBuilder: (

                    context,

                    error,

                    stackTrace,

                  ) {

                    return const Icon(

                      Icons.eco,

                      size: 70,

                      color: Colors.green,

                    );

                  },

                ),

              ),

              const SizedBox(height: 10),

              Text(

                vegetable.nameOromo,

                textAlign: TextAlign.center,

                style: const TextStyle(

                  fontSize: 20,

                  fontWeight: FontWeight.bold,

                ),

              ),

              const SizedBox(height: 4),

              Text(

                vegetable.nameEnglish,

                textAlign: TextAlign.center,

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