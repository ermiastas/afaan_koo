import 'package:flutter/material.dart';
import '../models/mammaaksa_item.dart';


class MammaaksaCard extends StatelessWidget {

  final MammaaksaItem mammaaksa;

  final VoidCallback? onAudioPressed;


  const MammaaksaCard({

    super.key,

    required this.mammaaksa,

    this.onAudioPressed,

  });



  @override
  Widget build(BuildContext context) {


    return Container(

      margin: const EdgeInsets.all(16),

      padding: const EdgeInsets.all(20),

      decoration: BoxDecoration(

        color: Colors.white,

        borderRadius:
            BorderRadius.circular(28),

        boxShadow: [

          BoxShadow(

            blurRadius: 12,

            offset:
                const Offset(0, 6),

            color:
                Colors.black12,

          )

        ],

      ),


      child: Column(

        crossAxisAlignment:
            CrossAxisAlignment.center,


        children: [


          // Emoji

          Container(

            height: 80,

            width: 80,

            decoration: BoxDecoration(

              color:
                  Colors.orange.shade100,

              shape:
                  BoxShape.circle,

            ),

            child: Center(

              child: Text(

                mammaaksa.emoji,

                style:
                    const TextStyle(
                      fontSize: 45,
                    ),

              ),

            ),

          ),



          const SizedBox(height: 20),



          // Proverb

          Text(

            mammaaksa.proverb,

            textAlign:
                TextAlign.center,

            style:
                const TextStyle(

              fontSize: 22,

              fontWeight:
                  FontWeight.bold,

            ),

          ),



          const SizedBox(height: 15),



          // Meaning

          Container(

            padding:
                const EdgeInsets.all(14),

            decoration:
                BoxDecoration(

              color:
                  Colors.green.shade50,

              borderRadius:
                  BorderRadius.circular(16),

            ),


            child: Column(

              children: [

                const Text(

                  "Hiika isaa 💡",

                  style:
                      TextStyle(

                    fontWeight:
                        FontWeight.bold,

                  ),

                ),


                const SizedBox(height: 8),


                Text(

                  mammaaksa.meaning,

                  textAlign:
                      TextAlign.center,

                ),

              ],

            ),

          ),



          const SizedBox(height: 15),



          // Hint

          Row(

            mainAxisAlignment:
                MainAxisAlignment.center,

            children: [

              Text(

                mammaaksa.hint,

                style:
                    const TextStyle(

                  fontSize: 18,

                ),

              ),

            ],

          ),



          const SizedBox(height: 20),



          // Buttons

          Row(

            mainAxisAlignment:
                MainAxisAlignment.spaceEvenly,

            children: [


              ElevatedButton.icon(

                onPressed:
                    onAudioPressed,

                icon:
                    const Icon(
                      Icons.volume_up,
                    ),

                label:
                    const Text(
                      "Dhagayi",
                    ),

              ),



              Container(

                padding:
                    const EdgeInsets.symmetric(

                  horizontal: 12,

                  vertical: 8,

                ),

                decoration:
                    BoxDecoration(

                  color:
                      Colors.amber.shade100,

                  borderRadius:
                      BorderRadius.circular(20),

                ),

                child: Text(

                  "⭐ ${mammaaksa.xpReward} XP",

                ),

              ),


            ],

          ),



          const SizedBox(height: 15),



          // Raji message

          Container(

            padding:
                const EdgeInsets.all(12),

            decoration:
                BoxDecoration(

              color:
                  Colors.blue.shade50,

              borderRadius:
                  BorderRadius.circular(18),

            ),


            child: const Text(

              "🤖 Raji: Aadaa keenya barachuun nama jabeessa!",

              textAlign:
                  TextAlign.center,

            ),

          ),

        ],

      ),

    );

  }

}