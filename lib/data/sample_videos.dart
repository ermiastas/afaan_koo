import 'package:flutter/material.dart';

import '../models/video_item.dart';


final List<VideoItem> sampleVideos = [

  // ==========================
  // Featured Videos
  // ==========================


  VideoItem(
    id: "animal_intro",
    title: "Bineensota Koo",
    titleEnglish: "My Animals",
    description:
        "Maqaa bineensotaa Afaan Oromootiin baradhu.",
    thumbnail:
        "assets/videos/thumbnails/animals.png",
    videoUrl:
        "assets/videos/animals_intro.mp4",
    category:
        "Animals",
    emoji:
        "🐘",
    color:
        Colors.brown, 
    duration:
        Duration(minutes:5),
    featured:
        true,
    rewardXP:
        25,
  ),



  VideoItem(
    id:"qubee_song",

    title:"Sirba Qubee",

    titleEnglish:"Alphabet Song",

    description:
        "Qubee Afaan Oromoo sirbaan baradhu.",

    thumbnail:
        "assets/videos/thumbnails/alphabet.png",

    videoUrl:
        "assets/videos/alphabet.mp4",

    category:
        "Alphabet",

    emoji:
        "🔤",

    color:
        Colors.blue,

    duration:
        Duration(minutes:4),

    featured:
        true,

    rewardXP:
        30,

  ),





  // ==========================
  // Numbers
  // ==========================


  VideoItem(

    id:"numbers",

    title:"Lakkoofsa Koo",

    titleEnglish:"My Numbers",

    description:
        "Lakkoofsa 1 hanga 100 baradhu.",

    thumbnail:
        "assets/videos/thumbnails/numbers.png",

    videoUrl:
        "assets/videos/numbers.mp4",

    category:
        "Numbers",

    emoji:
        "🔢",

    color:
        Colors.orange,

    duration:
        Duration(minutes:6),

    rewardXP:
        25,

  ),





  // ==========================
  // Fruits
  // ==========================


  VideoItem(

    id:"fruits",

    title:"Muduraa Koo",

    titleEnglish:
        "My Fruits",

    description:
        "Maqaa muduraa adda addaa baradhu.",

    thumbnail:
        "assets/videos/thumbnails/fruits.png",

    videoUrl:
        "assets/videos/fruits.mp4",

    category:
        "Fruits",

    emoji:
        "🍎",

    color:
        Colors.red,

    duration:
        Duration(minutes:5),

    rewardXP:
        20,

  ),





  // ==========================
  // Oromo Culture
  // ==========================


  VideoItem(

    id:"culture",

    title:"Aadaa Oromoo",

    titleEnglish:
        "Oromo Culture",

    description:
        "Aadaa fi duudhaa Oromoo baradhu.",

    thumbnail:
        "assets/videos/thumbnails/culture.png",

    videoUrl:
        "assets/videos/culture.mp4",

    category:
        "Culture",

    emoji:
        "🏛️",

    color:
        Colors.amber,

    duration:
        Duration(minutes:8),

    rewardXP:
        35,

  ),





  // ==========================
  // Songs
  // ==========================


  VideoItem(

    id:"songs",

    title:"Sirboota Koo",

    titleEnglish:
        "My Songs",

    description:
        "Sirboota Afaan Oromoo ijoollee.",

    thumbnail:
        "assets/videos/thumbnails/songs.png",

    videoUrl:
        "assets/videos/songs.mp4",

    category:
        "Songs",

    emoji:
        "🎵",

    color:
        Colors.pink,

    duration:
        Duration(minutes:10),

    rewardXP:
        30,

  ),





  // ==========================
  // Stories
  // ==========================


  VideoItem(

    id:"stories",

    title:"Seenaa Koo",

    titleEnglish:
        "My Stories",

    description:
        "Seenaa gabaabaa barnootaa dhaggeeffadhu.",

    thumbnail:
        "assets/videos/thumbnails/story.png",

    videoUrl:
        "assets/videos/story.mp4",

    category:
        "Stories",

    emoji:
        "📖",

    color:
        Colors.indigo,

    duration:
        Duration(minutes:7),

    rewardXP:
        30,

  ),





  // ==========================
  // Drawing / Coloring
  // ==========================


  VideoItem(

    id:"drawing",

    title:"Fakkii Kaasuu",

    titleEnglish:
        "Drawing",

    description:
        "Akkaataa fakkii itti kaasnu baradhu.",

    thumbnail:
        "assets/videos/thumbnails/drawing.png",

    videoUrl:
        "assets/videos/drawing.mp4",

    category:
        "Creative",

    emoji:
        "🎨",

    color:
        Colors.deepPurple,

    duration:
        Duration(minutes:6),

    rewardXP:
        25,

  ),



];