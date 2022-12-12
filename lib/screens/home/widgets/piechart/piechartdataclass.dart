import 'package:flutter/animation.dart';
import 'package:flutter/material.dart';

class PieData {
  static List<Data> data = [
    Data(name: 'food', percent: 20, color: Colors.red),
    Data(name: 'travel', percent: 30, color: Color.fromARGB(255, 2, 188, 61)),
    Data(name: 'salary', percent: 20, color: Color.fromARGB(255, 75, 39, 217)),
    Data(name: 'health', percent: 30, color: Color.fromARGB(255, 211, 148, 11)),
  ];
}

class Data {
  final String name;
  final double percent;
  final Color color;

  Data({required this.name, required this.percent, required this.color});

  get title => null;
}
