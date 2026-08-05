class Animal {


final String nameOromo;

final String nameEnglish;

final String category;

final String image;

final String sound;



Animal({

required this.nameOromo,

required this.nameEnglish,

required this.category,

required this.image,

required this.sound,

});







factory Animal.fromJson(

Map<String,dynamic> json

){

return Animal(



nameOromo:

json["nameOromo"]

??

json["title"]

??

"",






nameEnglish:

json["nameEnglish"]

??

json["english"]

??

"",






category:

json["category"]

??

"general",






image:

json["image"]

??

"",






sound:

json["sound"]

??

"",



);



}



}