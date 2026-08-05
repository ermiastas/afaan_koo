import 'package:flutter/material.dart';

import '../models/hibboo_item.dart';


class HibbooCard extends StatelessWidget {


final HibbooItem hibboo;

final VoidCallback onTap;



const HibbooCard({

super.key,

required this.hibboo,

required this.onTap,

});

String? _imagePath(HibbooItem item) {
  try {
    return (item as dynamic).image as String?;
  } catch (_) {
    return null;
  }
}

@override
Widget build(BuildContext context) {
  final String? imagePath = _imagePath(hibboo);


return GestureDetector(

onTap:onTap,


child:Card(

elevation:5,

shape:RoundedRectangleBorder(

borderRadius:BorderRadius.circular(20),

),


child:Column(

mainAxisAlignment:
MainAxisAlignment.center,


children:[


if (imagePath != null)
  Image.asset(
    imagePath,
    height:120,
    errorBuilder: (context, error, stack) {
      return const Icon(
        Icons.help,
        size:80,
      );
    },
  )
else
  const Icon(
    Icons.help,
    size:80,
  ),



const SizedBox(height:10),



const Text(

"❓ Hibboo",

style:TextStyle(

fontSize:20,

fontWeight:FontWeight.bold,

),

),



],


),


),


);


}

}