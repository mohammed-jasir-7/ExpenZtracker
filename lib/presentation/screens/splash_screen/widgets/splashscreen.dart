import 'package:expenztracker/custom%20WIDGETS/custom_route.dart';
import 'package:expenztracker/custom%20WIDGETS/custom_text.dart';
import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import '../../../../Data/repositiories/db_function.dart';
import '../../Onboard/introduction.dart';
import '../../home/home_screen.dart';
import 'logo_name.dart';

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
              LogoName(), //========================================================logo section end=============================

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
