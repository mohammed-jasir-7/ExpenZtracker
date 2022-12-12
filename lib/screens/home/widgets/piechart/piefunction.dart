import 'package:expenztracker/Database/DB%20function/db_function.dart';
import 'package:expenztracker/screens/home/widgets/piechart/piechartdataclass.dart';
import 'package:fl_chart/fl_chart.dart';
import 'package:flutter/animation.dart';
import 'package:hive_flutter/hive_flutter.dart';

import '../../../../Database/model/model_transaction.dart';

final box = Hive.box<Transaction>('transaction');

List<PieChartSectionData> getData() => categoryExpenseWiseTotalAmount.value
    .asMap()
    .map((key, exp) {
      final value = PieChartSectionData(
          color: totalAmountExpense.value == 0
              ? Color.fromARGB(255, 23, 229, 0)
              : Color(exp.category.color),
          radius: 60,
          title:
              ("${(exp.total / totalAmountExpense.value * 100).toInt().round()}%"),
          value: totalAmountExpense.value <= 0
              ? 10
              : exp.total / totalAmountExpense.value * 100);
      return MapEntry(key, value);
    })
    .values
    .toList();
    // .asMap()
    // .map((key, value) {
    //   final valued = PieChartSectionData(
    //       radius: 80,
    //       title: value.title,
    //       color: value.color,
    //       value: value.percent);
    //   return MapEntry(key, valued);
    // })
    // .values
    // .toList();
