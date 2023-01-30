import 'package:expenztracker/custom%20WIDGETS/custom_route.dart';
import 'package:expenztracker/custom%20WIDGETS/custom_text.dart';
import 'package:expenztracker/presentation/screens/Onboard/login_screen.dart';
import 'package:expenztracker/presentation/screens/Onboard/widgets/onboard_content.dart';

import 'package:flutter/material.dart';

class WelcomeScreen extends StatefulWidget {
  const WelcomeScreen({super.key});

  @override
  State<WelcomeScreen> createState() => _WelcomeScreenState();
}

class _WelcomeScreenState extends State<WelcomeScreen> {
  int currentIndex = 0;
  final PageController _controller = PageController(initialPage: 0);

  @override
  void dispose() {
    _controller;
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    Size size = MediaQuery.of(context).size;

    return Scaffold(
      body: Container(
        width: double.infinity,
        height: double.infinity,
        decoration: const BoxDecoration(
            gradient: RadialGradient(
                radius: 0.9,
                colors: [Color(0xFF64ED08), Color.fromARGB(255, 0, 210, 108)])),
        child: Column(
          children: [
            //======================================skip button==========================================
            SafeArea(
              child: Row(
                mainAxisAlignment: MainAxisAlignment.end,
                children: [
                  TextButton(
                      onPressed: () {
                        Navigator.pushAndRemoveUntil(
                            context,
                            CustomPageRoute(
                                child: const Login()) //page transition
                            ,
                            (route) => false);
                      },
                      child: CustomText(
                        content: "skip",
                        colour: Colors.white,
                      )),
                ],
              ),
            ),
            // ===========================================================page is here
            Expanded(
              child: PageView.builder(
                // page buid here
                controller: _controller,
                onPageChanged: (value) {
                  setState(() {
                    currentIndex = value;
                  });
                },
                itemCount: contents.length,
                itemBuilder: (context, index) {
                  return SafeArea(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.center,
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Image.asset(
                          contents[index].image,
                          width: size.width * 0.8,
                        ),
                        Padding(
                          padding: EdgeInsets.only(
                              top: size.height / 10, bottom: size.height / 35),
                          child: CustomText(
                            content: contents[index].title,
                            size: 29,
                            weight: FontWeight.w600,
                            colour: Colors.white,
                            align: TextAlign.center,
                          ),
                        ),
                        CustomText(
                          content: contents[index].content,
                          size: 16,
                          colour: Colors.white,
                          align: TextAlign.center,
                        )
                      ],
                    ),
                  );
                },
              ),
            ),
            //========================================slide bar================================
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: List.generate(
                  3,
                  (index) => Padding(
                        padding: const EdgeInsets.all(8.0),
                        child: ClipRRect(
                          borderRadius: BorderRadius.circular(10),
                          child: AnimatedContainer(
                            curve: Curves.easeInOut,
                            duration: const Duration(microseconds: 400000),
                            color: currentIndex == index
                                ? Colors.white
                                : const Color.fromARGB(169, 255, 255, 255),
                            width: currentIndex == index ? 20 : 10,
                            height: 8,
                          ),
                        ),
                      )), //page builder end here
            ),
            //==============================button= here================================
            Padding(
              padding: EdgeInsets.only(bottom: size.height / 20),
              child: ClipRRect(
                borderRadius: BorderRadius.circular(30),
                child: SizedBox(
                  height: 50,
                  width: size.width / 1.2,
                  child: ElevatedButton(
                      style: ButtonStyle(
                        backgroundColor:
                            MaterialStateProperty.all(Colors.white),
                      ),
                      onPressed: () {
                        slide(); // navigate to nextt screen
                        if (currentIndex == 2) {
                          Navigator.pushAndRemoveUntil(
                              context,
                              CustomPageRoute(
                                  child: const Login()) //page transition
                              ,
                              (route) => false);
                        }
                      },
                      child: CustomText(
                        content: currentIndex == 0
                            ? "GET STARTED"
                            : currentIndex == 2
                                ? 'Ready'
                                : 'Continue',
                        size: 16,
                        weight: FontWeight.w500,
                        colour: const Color(0XFF006B38),
                      )),
                ),
              ),
            ) //============================================end button===============================
          ],
        ),
      ),
    );
  }

//==== this function used for transition of onboard screeen
//it work when click button and navigate to next screeen
  slide() async {
    await _controller.nextPage(
        duration: const Duration(milliseconds: 500), curve: Curves.easeInOut);
  }
}
