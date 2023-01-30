import 'package:flutter/material.dart';
import 'package:flutter/src/widgets/container.dart';
import 'package:flutter/src/widgets/framework.dart';

import '../../../custom WIDGETS/custom_text.dart';

class CalculatorButton extends StatelessWidget {
  CalculatorButton(
      {super.key, this.callBack, required this.text, this.widthBorder});
  String text;
  Function? callBack;
  double? widthBorder;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 10),
      child: Container(
        decoration: BoxDecoration(borderRadius: BorderRadius.circular(50)),
        width: 70,
        height: 70,
        child: OutlinedButton(
            style: OutlinedButton.styleFrom(
                side: BorderSide(
                    color: Color(0XFF2CCD39), width: widthBorder ?? 3)),
            onPressed: () {
              if (callBack != null) {
                callBack!(text);
              }
            },
            child: CustomText(
              content: text,
              colour: Colors.black,
              size: 28,
              weight: FontWeight.w600,
            )),
      ),
    );
  }
}
