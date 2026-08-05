import 'package:flutter/material.dart';

import '../models/song.dart';
import '../services/content_service.dart';
import '../services/audio_service.dart';

import '../widgets/lesson_complete_button.dart';
import '../data/lesson_ids.dart';



class SongScreen extends StatefulWidget {


  const SongScreen({

    super.key,

  });



  @override
  State<SongScreen> createState()

  => _SongScreenState();


}






class _SongScreenState extends State<SongScreen>{



  final ContentService service =

  ContentService();



  final AudioService audio =

  AudioService();




  late Future<List<Song>> songs;






  @override
  void initState(){


    super.initState();


    songs =

    service.getSongs();


  }







  @override
  Widget build(BuildContext context){



    return Scaffold(



      appBar:

      AppBar(


        title:

        const Text(

          "🎵 Sirba Koo",

        ),



        centerTitle:true,


      ),







      body:

      FutureBuilder<List<Song>>(



        future:

        songs,



        builder:(context,snapshot){





          if(snapshot.connectionState ==

              ConnectionState.waiting){



            return const Center(


              child:

              CircularProgressIndicator(),


            );


          }







          if(snapshot.hasError){



            return Center(


              child:

              Text(

                "Dogoggora: ${snapshot.error}",

              ),


            );


          }







          final list =

          snapshot.data ?? [];








          if(list.isEmpty){



            return const Center(



              child:

              Text(

                "Sirbi hin jiru",

                style:

                TextStyle(

                  fontSize:20,

                ),

              ),



            );


          }









          return Column(



            children:[







              Expanded(



                child:

                ListView.builder(



                  padding:

                  const EdgeInsets.all(12),




                  itemCount:

                  list.length,







                  itemBuilder:(context,index){



                    final song =

                    list[index];








                    return Card(



                      elevation:5,



                      margin:

                      const EdgeInsets.symmetric(

                        vertical:10,

                      ),



                      shape:

                      RoundedRectangleBorder(



                        borderRadius:

                        BorderRadius.circular(20),



                      ),






                      child:

                      Padding(



                        padding:

                        const EdgeInsets.all(12),




                        child:

                        Column(



                          children:[







                            ClipRRect(



                              borderRadius:

                              BorderRadius.circular(20),



                              child:

                              Image.asset(



                                song.image,



                                height:150,



                                width:

                                double.infinity,



                                fit:

                                BoxFit.cover,



                                errorBuilder:

                                (context,error,stack){



                                  return const Icon(

                                    Icons.music_note,

                                    size:100,

                                  );



                                },


                              ),



                            ),







                            const SizedBox(

                              height:12,

                            ),







                            Text(



                              song.titleOromo,



                              style:

                              const TextStyle(



                                fontSize:25,

                                fontWeight:

                                FontWeight.bold,



                              ),



                            ),







                            Text(



                              song.titleEnglish,



                              style:

                              const TextStyle(

                                fontSize:16,

                                color:

                                Colors.grey,

                              ),



                            ),







                            const SizedBox(

                              height:8,

                            ),








                            Text(



                              "🎤 ${song.singer}",



                              style:

                              const TextStyle(

                                fontSize:18,

                              ),



                            ),







                            const SizedBox(

                              height:12,

                            ),








                            Text(



                              song.lyricsOromo,



                              textAlign:

                              TextAlign.center,



                              style:

                              const TextStyle(



                                fontSize:18,

                              ),



                            ),







                            const SizedBox(

                              height:15,

                            ),







                            ElevatedButton.icon(



                              onPressed:(){



                                audio.playSound(

                                  song.sound,

                                );



                              },



                              icon:

                              const Icon(

                                Icons.play_arrow,

                              ),




                              label:

                              const Text(

                                "Dhaggeeffadhu 🎧",

                              ),



                            ),







                          ],



                        ),



                      ),



                    );



                  },



                ),



              ),








              Padding(



                padding:

                const EdgeInsets.all(16),




                child:

                LessonCompleteButton(



                  lessonId:

                  LessonIds.songs,



                ),



              ),




            ],



          );



        },



      ),



    );


  }


}