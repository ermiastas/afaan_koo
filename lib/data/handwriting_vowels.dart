import '../models/handwriting_item.dart';
import '../models/handwriting_stroke.dart';


final List<HandwritingItem> vowels = [


  // =====================
  // A a
  // =====================

  HandwritingItem(

    character: "A",

    lowercase: "a",

    name: "A",

    sound: "A",

    category: "Dubbifamaa",

    strokes: [

      HandwritingStroke(
        order: 1,

        direction: "↘",

        points: [

          [120,40],
          [50,210],

        ],

      ),


      HandwritingStroke(
        order: 2,

        direction: "↙",

        points: [

          [120,40],
          [190,210],

        ],

      ),


      HandwritingStroke(
        order: 3,

        direction: "→",

        points: [

          [80,140],
          [160,140],

        ],

      ),

    ],

  ),



  // =====================
  // E e
  // =====================

  HandwritingItem(

    character: "E",

    lowercase: "e",

    name: "E",

    sound: "E",

    category: "Dubbifamaa",

    strokes: [

      HandwritingStroke(
        order: 1,

        direction: "↓",

        points: [

          [70,40],
          [70,210],

        ],

      ),


      HandwritingStroke(
        order: 2,

        direction: "→",

        points: [

          [70,40],
          [180,40],

        ],

      ),


      HandwritingStroke(
        order: 3,

        direction: "→",

        points: [

          [70,125],
          [160,125],

        ],

      ),


      HandwritingStroke(
        order: 4,

        direction: "→",

        points: [

          [70,210],
          [180,210],

        ],

      ),

    ],

  ),



  // =====================
  // I i
  // =====================

  HandwritingItem(

    character: "I",

    lowercase: "i",

    name: "I",

    sound: "I",

    category: "Dubbifamaa",

    strokes: [

      HandwritingStroke(
        order: 1,

        direction: "↓",

        points: [

          [120,50],
          [120,210],

        ],

      ),

    ],

  ),




  // =====================
  // O o
  // =====================

  HandwritingItem(

    character: "O",

    lowercase: "o",

    name: "O",

    sound: "O",

    category: "Dubbifamaa",

    strokes: [

      HandwritingStroke(
        order: 1,

        direction: "↻",

        points: [

          [120,40],
          [200,120],
          [120,210],
          [40,120],
          [120,40],

        ],

      ),

    ],

  ),




  // =====================
  // U u
  // =====================

  HandwritingItem(

    character: "U",

    lowercase: "u",

    name: "U",

    sound: "U",

    category: "Dubbifamaa",

    strokes: [

      HandwritingStroke(
        order: 1,

        direction: "↓",

        points: [

          [60,40],
          [60,160],

        ],

      ),


      HandwritingStroke(
        order: 2,

        direction: "↘",

        points: [

          [60,160],
          [120,210],

        ],

      ),


      HandwritingStroke(
        order: 3,

        direction: "↗",

        points: [

          [120,210],
          [180,160],

        ],

      ),


      HandwritingStroke(
        order: 4,

        direction: "↑",

        points: [

          [180,160],
          [180,40],

        ],

      ),

    ],

  ),


];