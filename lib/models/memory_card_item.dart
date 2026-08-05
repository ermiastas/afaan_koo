class MemoryCardItem {


final String id;

final String image;

final String word;

bool flipped;

bool matched;



MemoryCardItem({

required this.id,

required this.image,

required this.word,

this.flipped=false,

this.matched=false,

});


}