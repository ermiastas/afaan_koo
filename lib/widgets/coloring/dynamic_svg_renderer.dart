import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';


class DynamicSvgRenderer extends StatelessWidget {


  final String asset;


  const DynamicSvgRenderer({

    super.key,

    required this.asset,

  });



  @override
  Widget build(BuildContext context){


    return SvgPicture.asset(

      asset,

      fit:BoxFit.contain,

    );


  }


}