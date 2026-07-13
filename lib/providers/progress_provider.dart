import 'package:flutter/material.dart';

import '../models/learning_progress.dart';



class ProgressProvider extends ChangeNotifier {



final Map<String,bool> _completedLessons = {};



final LearningProgress _progress =
LearningProgress();





Map<String,bool> get completedLessons =>
_completedLessons;



LearningProgress get progress =>
_progress;





// Complete any lesson by name

void completeLesson(String lesson){


_completedLessons[lesson] = true;


notifyListeners();


}





// Check if a lesson is completed

bool isCompleted(String lesson){


return _completedLessons[lesson] ?? false;


}





// Total completed lessons

int get completedCount =>
_completedLessons.length;





// Alphabet progress

void completeAlphabet(){


_progress.alphabetCompleted++;


notifyListeners();


}





// Animal progress

void completeAnimal(){


_progress.animalCompleted++;


notifyListeners();


}





// Word progress

void completeWord(){


_progress.wordCompleted++;


notifyListeners();


}





// Game progress

void completeGame(){


_progress.gamesCompleted++;


notifyListeners();


}





// Total category progress

int get totalProgress{


return

_progress.alphabetCompleted +

_progress.animalCompleted +

_progress.wordCompleted +

_progress.gamesCompleted;


}





// Percentage for progress bar

double get completionPercentage{


int completedCategories = 0;



if(_progress.alphabetCompleted > 0){

completedCategories++;

}



if(_progress.animalCompleted > 0){

completedCategories++;

}



if(_progress.wordCompleted > 0){

completedCategories++;

}



if(_progress.gamesCompleted > 0){

completedCategories++;

}



return completedCategories / 4;


}



}