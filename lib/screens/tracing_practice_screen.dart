import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../data/alphabet_data.dart';

import '../widgets/alphabet_tracing_widget.dart';
import '../widgets/tracing/number_tracing_widget.dart';
import '../widgets/lesson_complete_button.dart';

import '../data/lesson_ids.dart';
import '../providers/reward_provider.dart';



enum TracingMode {

  alphabet,

  numbers,

}




class TracingPracticeScreen extends StatefulWidget {


  final TracingMode mode;


  const TracingPracticeScreen({

    super.key,

    required this.mode,

  });





  @override
  State<TracingPracticeScreen> createState()

  => _TracingPracticeScreenState();


}








class _TracingPracticeScreenState

extends State<TracingPracticeScreen>{



  int _index = 0;


  bool _celebrated = false;







  int get _total =>

      widget.mode == TracingMode.alphabet

          ? letters.length

          : 10;








  String get _title =>

      widget.mode == TracingMode.alphabet

          ? "Qubee Barreessi ✍️"

          : "Lakkoofsa Barreessi ✍️";







  String get lessonId =>

      widget.mode == TracingMode.alphabet

          ? LessonIds.alphabetTracing

          : LessonIds.numberTracing;








  void _move(int change){



    setState((){



      _index =

          (_index + change)

              .clamp(0,_total - 1);



      _celebrated = false;



    });



  }









  void _complete(){



    if(_celebrated){

      return;

    }



    setState((){

      _celebrated = true;

    });





    Provider.of<RewardProvider>(

      context,

      listen:false,

    )

        .addStars(3);







    ScaffoldMessenger.of(context)

        .showSnackBar(



      const SnackBar(



        content:

        Text(

          "🎉 Gaarii! Barreessuu sirriitti hojjetta +3 ⭐",

        ),



      ),



    );



  }









  @override
  Widget build(BuildContext context){



    final isAlphabet =

        widget.mode == TracingMode.alphabet;





    final letter =

    isAlphabet

        ? letters[_index]

        : null;







    final color =

    isAlphabet

        ? Colors.orange

        : Colors.blue;







    return Scaffold(





      appBar:

      AppBar(



        title:

        Text(_title),



        centerTitle:true,



      ),







      body:

      SafeArea(



        child:

        SingleChildScrollView(



          padding:

          const EdgeInsets.all(16),





          child:

          Column(



            children:[







              LinearProgressIndicator(



                value:

                (_index + 1) / _total,



                minHeight:

                10,



                color:

                color,



              ),







              const SizedBox(

                height:15,

              ),







              Text(



                "${_index + 1} / $_total",



                style:

                TextStyle(



                  color:

                  color,



                  fontWeight:

                  FontWeight.bold,



                  fontSize:18,



                ),



              ),







              const SizedBox(

                height:10,

              ),







              Text(



                isAlphabet

                    ?

                "Qubee kana qubeessuun shaakali ✍️"

                    :

                "Lakkoofsa kana suuta barreessi ✍️",




                textAlign:

                TextAlign.center,



                style:

                const TextStyle(

                  fontSize:18,

                ),



              ),







              const SizedBox(

                height:20,

              ),







              if(isAlphabet)



                AlphabetTracingWidget(



                  key:

                  ValueKey(

                      letter!.uppercase

                  ),



                  capitalLetter:

                  letter.uppercase,



                  smallLetter:

                  letter.lowercase,



                  onComplete:

                  _complete,



                )



              else



                NumberTracingWidget(



                  key:

                  ValueKey(_index),



                  number:

                  _index,



                  onComplete:

                  _complete,



                ),










              if(_celebrated)



                const Padding(



                  padding:

                  EdgeInsets.only(

                    top:15,

                  ),



                  child:

                  Text(



                    "🌟 Hojii gaarii! Raji si jajjabeessa!",



                    style:

                    TextStyle(



                      fontSize:20,

                      fontWeight:

                      FontWeight.bold,



                    ),



                  ),



                ),







              const SizedBox(

                height:20,

              ),







              Row(



                children:[





                  Expanded(



                    child:

                    OutlinedButton.icon(



                      onPressed:

                      _index == 0

                          ? null

                          :

                          () => _move(-1),



                      icon:

                      const Icon(

                        Icons.arrow_back,

                      ),



                      label:

                      const Text(

                        "Duuba",

                      ),



                    ),



                  ),







                  const SizedBox(

                    width:12,

                  ),







                  Expanded(



                    child:

                    FilledButton.icon(



                      onPressed:

                      _index == _total - 1

                          ? null

                          :

                          () => _move(1),



                      icon:

                      const Icon(

                        Icons.arrow_forward,

                      ),



                      label:

                      const Text(

                        "Itti fufi",

                      ),



                    ),



                  ),





                ],



              ),







              const SizedBox(

                height:20,

              ),







              LessonCompleteButton(



                lessonId:

                lessonId,



              ),





            ],



          ),



        ),



      ),



    );



  }



}
