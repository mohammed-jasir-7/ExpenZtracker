import 'package:flutter/cupertino.dart';

import '../../../../custom WIDGETS/custom_text.dart';

class LogoName extends StatelessWidget {
  const LogoName({
    Key? key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Stack(
      //=============================================================logo section========================================
      children: [
        Row(
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            CustomText(
              content: "Expen",
              size: 36,
              colour: const Color(0xFF006404),
              fontname: 'Poppins',
              weight: FontWeight.w600,
            ),
            CustomText(
              content: "Z",
              size: 48,
              fontname: 'Poppins',
              colour: const Color(0xFF006404),
              weight: FontWeight.w700,
            ),
          ],
        ),
        Positioned(
          // ignore: sort_child_properties_last
          child: CustomText(
            content: "Tracker",
            weight: FontWeight.w500,
            size: 14,
          ),
          top: 40,
          left: MediaQuery.of(context).size.width / 2.1,
        )
      ],
    );
  }
}
