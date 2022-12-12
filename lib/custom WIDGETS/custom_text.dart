import 'package:flutter/material.dart';

class CustomText extends StatelessWidget {
  CustomText(
      {super.key,
      required this.content,
      this.colour,
      this.size,
      this.fontname,
      this.weight,
      this.align});
  final String content;
  Color? colour;
  double? size;
  String? fontname;
  FontWeight? weight;
  TextAlign? align;

  @override
  Widget build(BuildContext context) {
    return Text(content,
        textAlign: align,
        style: TextStyle(
          color: colour,
          fontSize: size,
          fontFamily: fontname,
          fontWeight: weight,
        ));
  }
}
