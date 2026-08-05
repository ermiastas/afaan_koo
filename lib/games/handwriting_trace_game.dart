import 'dart:math';

import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../data/alphabet_data.dart';
import '../models/game_item.dart';
import '../providers/progress_provider.dart';
import '../providers/reward_provider.dart';
import '../widgets/alphabet_tracing_widget.dart';
import '../widgets/tracing/number_tracing_widget.dart';



class HandwritingTraceGame extends StatefulWidget {


  final GameItem game;


  const HandwritingTraceGame({

    super.key,

    required this.game,

  });



  @override
  State<HandwritingTraceGame> createState() =>
      _HandwritingTraceGameState();


}





class _HandwritingTraceGameState
    extends State<HandwritingTraceGame> {


  final Random _random =
      Random();



  late List<_TraceRound> _rounds;



  int _round = 0;


  bool _roundDone = false;


  bool _finished = false;


  bool _rewardClaimed = false;





  @override
  void initState() {

    super.initState();


    _rounds = [

      ...List.generate(

        3,

        (_) => _TraceRound.letter(

          _random.nextInt(
              letters.length
          ),

        ),

      ),


      ...List.generate(

        2,

        (_) => _TraceRound.number(

          _random.nextInt(10),

        ),

      ),

    ]..shuffle(_random);


  }









  Future<void> _completeRound() async {



    if(_roundDone || _finished){

      return;

    }




    setState(() {

      _roundDone = true;

    });






    if(_round == _rounds.length - 1){



      setState(() {

        _finished = true;

      });




      await _completeGameReward();



      return;


    }





    await Future.delayed(

      const Duration(
          milliseconds:900
      ),

    );




    if(!mounted){

      return;

    }



    setState(() {

      _round++;

      _roundDone=false;

    });



  }









  Future<void> _completeGameReward() async {



    if(_rewardClaimed){

      return;

    }



    _rewardClaimed=true;






    // Save progress

    await context

        .read<ProgressProvider>()

        .completeGame(

          widget.game.id,

        );






    // Add learning time

    await context

        .read<ProgressProvider>()

        .addLearningMinutes(

          5,

        );








    // Give rewards

    await context

        .read<RewardProvider>()

        .completeGame(


          xp:
          widget.game.rewardXP,


          coins:
          widget.game.rewardCoins,


          stars:
          widget.game.rewardStars,


          gameId:
          widget.game.id,


        );



  }









  @override
  Widget build(BuildContext context) {



    final current =
        _rounds[_round];



    return Scaffold(



      appBar: AppBar(

        title:
        const Text(
          "Qubee Barreessuu Taphadhu ✍️",
        ),

      ),





      body: SafeArea(



        child: SingleChildScrollView(



          padding:
          const EdgeInsets.all(16),




          child: Column(



            children:[



              LinearProgressIndicator(

                value:

                (_round +

                    (_finished ? 1 : 0))

                    /

                _rounds.length,

                minHeight:10,

              ),




              const SizedBox(
                  height:12
              ),





              Text(


                _finished

                    ?

                "Xumurteetta! 🎉"

                    :

                "Marsaa ${_round + 1} keessaa ${_rounds.length}",



                style:
                const TextStyle(

                  fontSize:21,

                  fontWeight:
                  FontWeight.w800,

                ),


              ),





              const SizedBox(
                  height:8
              ),






              Text(


                _finished

                    ?

                "Barreeffama gaarii hojjechuun badhaasa argatte."

                    :


                current.isLetter

                    ?

                "Qubee sirriitti hordofi."

                    :

                "Lakkoofsa sirriitti barreessi.",




                textAlign:
                TextAlign.center,



                style:
                const TextStyle(

                  fontSize:17,

                ),


              ),







              const SizedBox(
                  height:12
              ),







              if(!_finished &&
                  current.isLetter)



                AlphabetTracingWidget(



                  key:
                  ValueKey(

                    'letter-$_round-${current.letterIndex}',

                  ),



                  capitalLetter:

                  letters[current.letterIndex!]

                      .uppercase,



                  smallLetter:

                  letters[current.letterIndex!]

                      .lowercase,



                  onComplete:
                  _completeRound,


                )






              else if(!_finished)



                NumberTracingWidget(



                  key:
                  ValueKey(

                    'number-$_round-${current.number}',

                  ),



                  number:
                  current.number!,



                  onComplete:
                  _completeRound,


                )







              else



                const Padding(



                  padding:
                  EdgeInsets.all(72),



                  child:

                  Icon(

                    Icons.workspace_premium_rounded,

                    size:96,

                    color:Colors.amber,

                  ),

                ),







              if(_roundDone &&
                  !_finished)



                const Text(


                  "Bareedduu gaarii! Marsaa itti aanu qophaa'i 🌟",


                  style:
                  TextStyle(

                    fontSize:18,

                    fontWeight:
                    FontWeight.bold,

                  ),


                ),







              if(_finished)



                FilledButton.icon(



                  onPressed:

                  () =>

                  Navigator.of(context)
                      .pop(),



                  icon:

                  const Icon(
                    Icons.star_rounded,
                  ),



                  label:

                  const Text(
                    "Badhaasa koo ilaali",
                  ),



                ),



            ],



          ),



        ),


      ),


    );


  }


}









class _TraceRound {



  final int? letterIndex;


  final int? number;



  const _TraceRound.letter(
      this.letterIndex
      )
      :
      number=null;




  const _TraceRound.number(
      this.number
      )
      :
      letterIndex=null;





  bool get isLetter =>
      letterIndex != null;


}