import '../models/reward.dart';


final List<Reward> rewards = [


  Reward(

    id: "first_lesson",

    title: "Jalqaba Barnootaa",

    description:
        "Barnoota jalqabaa xumurte",

    emoji:"🌱",

    type:RewardType.badge,

    requiredXP:10,

  ),



  Reward(

    id:"alphabet_master",

    title:"Abbaa Qubee",

    description:
        "Qubee hunda baratte",

    emoji:"🔤",

    type:RewardType.badge,

    requiredXP:100,

  ),



  Reward(

    id:"animal_friend",

    title:"Hiriyyaa Bineensotaa",

    description:
        "Bineensota baratte",

    emoji:"🐾",

    type:RewardType.badge,

    requiredXP:200,

  ),



  Reward(

    id:"book_reader",

    title:"Dubbisaa Gaarii",

    description:
        "Jechoota hedduu baratte",

    emoji:"📚",

    type:RewardType.certificate,

    requiredXP:500,

  ),



];