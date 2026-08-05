enum LearningAgeGroup {


  preschool,   // 3-5

  beginner,    // 6-8

  advanced,    // 9-12


}



class LearningAge {


  static LearningAgeGroup getGroup(int age){


    if(age <= 5){

      return LearningAgeGroup.preschool;

    }


    if(age <= 8){

      return LearningAgeGroup.beginner;

    }


    return LearningAgeGroup.advanced;


  }



}