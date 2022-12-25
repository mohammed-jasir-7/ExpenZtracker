import 'package:expenztracker/custom%20WIDGETS/custom_text.dart';
import 'package:flutter/material.dart';

import 'home_appbar.dart';

class AboutApp extends StatelessWidget {
  const AboutApp({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: PreferredSize(
          preferredSize: const Size.fromHeight(50), //custom app bar here
          child: HomeAppBar(
            leadingIcon: false,
          )),
      body: SafeArea(
          child: Container(
        width: double.infinity,
        child: Column(crossAxisAlignment: CrossAxisAlignment.center, children: [
          const SizedBox(
            height: 50,
          ),
          Padding(
            padding: const EdgeInsets.all(4.0),
            child: CustomText(
              content: "About",
              size: 18,
              colour: Colors.black87,
              fontname: "Poppins",
              weight: FontWeight.w600,
            ),
          ),
          Padding(
            padding: const EdgeInsets.all(15.0),
            child: CustomText(
              align: TextAlign.center,
              content:
                  "ExpenZ Tracker, developed by\n MOHAMMED JASIR, allows you to track\n your daily/weekly/monthly/yearly expenses. It makes money management a piece of cake. You can effectively manage your expenses free of cost with ExpenZ Tracker. ",
              size: 14,
              colour: const Color.fromARGB(221, 58, 58, 58),
              fontname: "Poppins",
            ),
          ),
        ]),
      )),
    );
  }
}
