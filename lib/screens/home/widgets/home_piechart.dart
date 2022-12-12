import 'package:expenztracker/Database/DB%20function/db_function.dart';

import 'package:expenztracker/screens/home/widgets/piechart/piefunction.dart';
import 'package:fl_chart/fl_chart.dart';

import 'package:flutter/material.dart';

import 'package:mccounting_text/mccounting_text.dart';

import '../../../custom WIDGETS/custom_text.dart';

class HomePieChart extends StatelessWidget {
  HomePieChart({super.key});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(8.0),
      child: SizedBox(
          width: 300,
          height: 300,
          child: Stack(
            children: [
              Center(
                  child: Container(
                width: 200,
                height: 80,
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    ValueListenableBuilder(
                      valueListenable: totalAmountExpense,
                      builder: (context, value, child) {
                        return totalAmountExpense.value <= 0
                            ? CustomText(
                                content: "Good work sir!",
                                fontname: 'Poppins',
                                weight: FontWeight.w600,
                              )
                            : McCountingText(
                                begin: 0,
                                end: totalAmountExpense.value.toDouble(),
                                precision: 2,
                                style: TextStyle(color: Colors.red),
                                duration: Duration(seconds: 1),
                                curve: Curves.fastOutSlowIn,
                              );
                      },
                    ),
                    ValueListenableBuilder(
                      valueListenable: totalAmountIncome,
                      builder: (context, value, child) {
                        return totalAmountIncome.value <= 0
                            ? CustomText(
                                content: "Bad!!!",
                                fontname: 'Poppins',
                                weight: FontWeight.w600,
                              )
                            : Row(
                                mainAxisAlignment: MainAxisAlignment.center,
                                children: [
                                  CustomText(content: "+\u20b9"),
                                  McCountingText(
                                    begin: 0,
                                    end: totalAmountIncome.value.toDouble(),
                                    precision: 2,
                                    style: TextStyle(
                                        color: Color(0XFF00900E),
                                        fontFamily: 'Poppins'),
                                    duration: Duration(seconds: 1),
                                    curve: Curves.fastOutSlowIn,
                                  ),
                                ],
                              );
                      },
                    ),
                  ],
                ),
              )),
              ValueListenableBuilder(
                valueListenable: totalAmountExpense,
                builder: (context, value, child) => ValueListenableBuilder(
                  valueListenable: categoryExpenseWiseTotalAmount,
                  builder: (context, value, child) {
                    return PieChart(
                        swapAnimationDuration: Duration(seconds: 2),
                        swapAnimationCurve: Curves.bounceIn,
                        PieChartData(
                            sections: totalAmountExpense.value <= 0
                                ? [PieChartSectionData(color: Colors.green)]
                                : getData()));
                  },
                ),
              )
            ],
          )),
    );
  }
}
