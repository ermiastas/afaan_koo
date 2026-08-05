class JourneyItem {


final String id;

final String title;

final String category;

final String icon;

final bool unlocked;

final bool completed;

final int stars;


JourneyItem({

required this.id,

required this.title,

required this.category,

required this.icon,

this.unlocked=false,

this.completed=false,

this.stars=0,

});

}