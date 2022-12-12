import 'package:expenztracker/Database/DB%20function/db_function.dart';
import 'package:expenztracker/Database/model/model_transaction.dart';
import 'package:expenztracker/screens/splashscreen.dart';
import 'package:flutter/material.dart';

void main(List<String> args) async {
  WidgetsFlutterBinding.ensureInitialized();

  await dataBase();
  //initilization database

  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        primaryColor: Colors.green,
      ),
      home: const SplashScreen(), //spashscreen
    );
  }
}
