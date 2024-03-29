import 'package:expenztracker/Database/DB%20function/db_function.dart';
import 'package:expenztracker/custom%20WIDGETS/custom_route.dart';
import 'package:expenztracker/custom%20WIDGETS/custom_text.dart';
import 'package:expenztracker/screens/Onboard/introduction.dart';
import 'package:expenztracker/screens/home/home_screen.dart';
import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';

class SplashScreen extends StatelessWidget {
  const SplashScreen({super.key});

  @override
  Widget build(BuildContext context) {
    navigate(context);
    return Scaffold(
      body: SafeArea(
        child: SizedBox(
          width: double.infinity,
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              AnimatedOpacity(
                  duration: const Duration(seconds: 1),
                  opacity: 1.0,
                  curve: Curves.easeInOut,
                  child: Image.asset(
                    'assets/icons/image 1.png',
                    width: 200,
                  )),
              Stack(
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
              ), //========================================================logo section end=============================
              // AnimatedTextKit(
              //   animatedTexts: [
              //     ScaleAnimatedText('text',
              //         duration: Duration(
              //           seconds: 5,
              //         ),
              //         scalingFactor: 5.5)
              //   ],
              //   pause: Duration(seconds: 2),
              //   totalRepeatCount: 1,
              // ),
              Padding(
                padding: EdgeInsets.only(
                    top: MediaQuery.of(context).size.height / 3),
                child: CustomText(
                  content: "version 1.0",
                  colour: Colors.grey,
                ),
              )
            ],
          ),
        ),
      ),
    );
  }

  Future<void> navigate(BuildContext ctx) async {
    //initilization database
    await dataBase();

    final pref = await SharedPreferences.getInstance();
    String? name = pref.getString("userName");
    if (name != null) {
      if (name.isNotEmpty) {
        Navigator.pushReplacement(
          ctx,
          CustomPageRoute(child: const HomeScreen()),
        );
      }
    } else {
      Navigator.pushReplacement(
        ctx,
        CustomPageRoute(child: const WelcomeScreen()),
      );
    }
  }
}
