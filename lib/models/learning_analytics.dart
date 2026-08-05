class LearningAnalytics {


final Map<String,double> categories;


LearningAnalytics({

required this.categories,

});


double progress(String category){

return categories[category] ?? 0;

}


}