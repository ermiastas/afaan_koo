class ContentItem {


final String id;

final String title;

final String english;

final String category;

final String image;

final String sound;

final String description;



ContentItem({

required this.id,

required this.title,

required this.english,

required this.category,

required this.image,

required this.sound,

required this.description,

});





factory ContentItem.fromJson(
Map<String,dynamic> json
){

return ContentItem(

id:
json["id"] ?? "",


title:
json["title"] ?? "",


english:
json["english"] ?? "",


category:
json["category"] ?? "",


image:
json["image"] ?? "",


sound:
json["sound"] ?? "",


description:
json["description"] ?? "",


);

}






Map<String,dynamic> toJson(){


return {


"id":id,

"title":title,

"english":english,

"category":category,

"image":image,

"sound":sound,

"description":description,


};


}


}