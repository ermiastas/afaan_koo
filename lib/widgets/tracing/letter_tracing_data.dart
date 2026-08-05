import 'tracing_point.dart';
import 'tracing_path.dart';



LetterTracingPath createLetterPath(String letter) {


  switch(letter) {


    case "A":

      return LetterTracingPath(

        letter: "A",

        strokes: [

          TracingStroke(

            order:1,

            points:[

              TracingPoint(dx:.5, dy:.1),

              TracingPoint(dx:.2, dy:.9),

            ],

          ),


          TracingStroke(

            order:2,

            points:[

              TracingPoint(dx:.5, dy:.1),

              TracingPoint(dx:.8, dy:.9),

            ],

          ),



          TracingStroke(

            order:3,

            points:[

              TracingPoint(dx:.3, dy:.55),

              TracingPoint(dx:.7, dy:.55),

            ],

          ),

        ],

      );





    case "B":


      return LetterTracingPath(

        letter:"B",

        strokes:[


          TracingStroke(

            order:1,

            points:[

              TracingPoint(dx:.3,dy:.1),

              TracingPoint(dx:.3,dy:.9),

            ],

          ),



          TracingStroke(

            order:2,

            points:[

              TracingPoint(dx:.3,dy:.1),

              TracingPoint(dx:.75,dy:.25),

              TracingPoint(dx:.3,dy:.5),

            ],

          ),




          TracingStroke(

            order:3,

            points:[

              TracingPoint(dx:.3,dy:.5),

              TracingPoint(dx:.75,dy:.7),

              TracingPoint(dx:.3,dy:.9),

            ],

          ),


        ],

      );







    case "a":


      return LetterTracingPath(

        letter:"a",

        strokes:[


          TracingStroke(

            order:1,

            points:[

              TracingPoint(dx:.4,dy:.35),

              TracingPoint(dx:.7,dy:.35),

              TracingPoint(dx:.7,dy:.8),

            ],

          ),



          TracingStroke(

            order:2,

            points:[

              TracingPoint(dx:.7,dy:.8),

              TracingPoint(dx:.4,dy:.8),

              TracingPoint(dx:.4,dy:.35),

            ],

          ),



        ],

      );







    case "b":


      return LetterTracingPath(

        letter:"b",

        strokes:[


          TracingStroke(

            order:1,

            points:[

              TracingPoint(dx:.35,dy:.1),

              TracingPoint(dx:.35,dy:.9),

            ],

          ),



          TracingStroke(

            order:2,

            points:[

              TracingPoint(dx:.35,dy:.5),

              TracingPoint(dx:.7,dy:.5),

              TracingPoint(dx:.7,dy:.8),

              TracingPoint(dx:.35,dy:.8),

            ],

          ),


        ],

      );







    case "Ch":

    case "Dh":

    case "Ny":

    case "Ph":

    case "Sh":


      return LetterTracingPath(

        letter:letter,

        strokes:[


          TracingStroke(

            order:1,

            points:[

              TracingPoint(dx:.25,dy:.2),

              TracingPoint(dx:.75,dy:.2),

            ],

          ),


          TracingStroke(

            order:2,

            points:[

              TracingPoint(dx:.25,dy:.5),

              TracingPoint(dx:.75,dy:.5),

            ],

          ),


          TracingStroke(

            order:3,

            points:[

              TracingPoint(dx:.25,dy:.8),

              TracingPoint(dx:.75,dy:.8),

            ],

          ),


        ],

      );






    default:


      return LetterTracingPath(

        letter:letter,

        strokes:[


          TracingStroke(

            order:1,

            points:[

              TracingPoint(dx:.5,dy:.1),

              TracingPoint(dx:.5,dy:.9),

            ],

          ),


        ],

      );


  }


}