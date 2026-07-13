class LearningProgress {


int alphabetCompleted;

int animalCompleted;

int wordCompleted;

int gamesCompleted;



LearningProgress({

this.alphabetCompleted = 0,

this.animalCompleted = 0,

this.wordCompleted = 0,

this.gamesCompleted = 0,

});



int get totalCompleted =>

alphabetCompleted +

animalCompleted +

wordCompleted +

gamesCompleted;



}