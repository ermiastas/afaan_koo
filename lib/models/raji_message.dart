enum RajiMood {

  happy,
  excited,
  thinking,
  celebrating,
  encouraging,

}


class RajiMessage {


final String text;

final RajiMood mood;


RajiMessage({

required this.text,
required this.mood,

});


}