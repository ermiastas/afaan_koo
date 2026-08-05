import 'package:flutter/material.dart';

import '../models/learning_task.dart';

import '../data/learning_path_data.dart';



class LearningPathProvider extends ChangeNotifier {



List<LearningTask> todayTasks =
dailyLearningTasks;



int completed = 0;



double get progress {


if(todayTasks.isEmpty){

return 0;

}


return completed /
todayTasks.length;


}



void completeTask(){


completed++;


notifyListeners();


}



}