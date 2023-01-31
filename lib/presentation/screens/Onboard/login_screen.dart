import 'package:expenztracker/custom%20WIDGETS/custom_route.dart';
import 'package:expenztracker/custom%20WIDGETS/custom_text.dart';

import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../home/home_screen.dart';

class Login extends StatelessWidget {
  const Login({super.key});

  @override
  Widget build(BuildContext context) {
    Size size = MediaQuery.of(context).size;
    return Scaffold(
      body: Container(
        color: Colors.white,
        width: double.infinity,
        height: double.infinity,
        child: Stack(
          children: [
            // backround design======================
            Positioned(
                top: size.height / 6,
                left: size.width / 3.5,
                child: Image.asset("assets/images/Ellipse 1.png")),
            Positioned(
                right: size.width / 15,
                top: size.height / 3,
                child: Image.asset("assets/images/Ellipse 2.png")),
            Positioned(
              right: size.width * 0.3,
              top: size.height / 5,
              child: const Text("Login",
                  style: TextStyle(
                    shadows: [
                      Shadow(
                          color: Colors.white,
                          blurRadius: 3,
                          offset: Offset(5, -4.5))
                    ],
                    decorationStyle: TextDecorationStyle.wavy,
                    fontFamily: 'Poppins',
                    fontSize: 60,
                    fontWeight: FontWeight.w600,
                    color: Colors.black,
                  )),
            ), //========================================ATM card design===============
            Positioned(
              top: size.height / 3.8,
              child: Container(
                  color: const Color.fromARGB(0, 255, 193, 7),
                  child: Stack(children: [
                    Image.asset('assets/images/creditCard.png'),
                    Positioned(
                        left: size.width / 5,
                        top: size.height / 4.5,
                        child: SizedBox(
                          width: size.width / 1.5,
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.end,
                            children: const [
                              SingleChildScrollView(child: Logintextfield()),
                            ],
                          ),
                        ))
                  ])),
            )
          ],
        ),
      ),
    );
  }
}

//this widget is login textfield================
class Logintextfield extends StatefulWidget {
  const Logintextfield({super.key});

  @override
  State<Logintextfield> createState() => _LogintextfieldState();
}

class _LogintextfieldState extends State<Logintextfield> {
  final TextEditingController _controller = TextEditingController();
  final _formkey = GlobalKey<FormState>();
  @override
  Widget build(BuildContext context) {
    Size size = MediaQuery.of(context).size;
    return Form(
      key: _formkey,
      child: Column(
        children: [
          // CustomTextfiled(
          //   validator: validator,
          //   controller: _controller,                                        //pending to explore
          //   hint: 'Enter your name',
          //   onChangedd: jas,
          // ),
          TextFormField(
            controller: _controller,
            validator: (value) {
              if (value == null || value.isEmpty) {
                return 'please enter name';
              } else {
                return null;
              }
            },
            decoration: const InputDecoration(hintText: "Enter your Name"),
          ),
          Padding(
            padding:
                EdgeInsets.only(left: size.width / 4, top: size.height / 200),
            child: ClipRRect(
              borderRadius: BorderRadius.circular(50),
              child: SizedBox(
                width: 70,
                height: 70,
                child: ElevatedButton(
                    style: ButtonStyle(
                      backgroundColor: MaterialStateProperty.all(
                          const Color.fromARGB(255, 34, 127, 214)),
                    ),
                    onPressed: () {
                      if (_formkey.currentState!.validate()) {
                        login(_controller.text);
                        Navigator.pushAndRemoveUntil(
                            context,
                            CustomPageRoute(child: HomeScreen()),
                            (route) => false);
                      }
                    },
                    child: CustomText(
                      content: "Start",
                    )),
              ),
            ),
          )
        ],
      ),
    );
  }

  validator(String value) {
    if (value.isEmpty) {
      return 'please enter name';
    } else {
      return null;
    }
  }

  login(String name) async {
    final sharedPreference = await SharedPreferences.getInstance();
    await sharedPreference.setString("userName", name);
  }
}
