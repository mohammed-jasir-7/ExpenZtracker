import 'package:drop_shadow/drop_shadow.dart';
import 'package:expenztracker/Database/DB%20function/db_function.dart';

import 'package:expenztracker/screens/home/widgets/piechart/piefunction.dart';
import 'package:fl_chart/fl_chart.dart';

import 'package:flutter/material.dart';

import 'package:mccounting_text/mccounting_text.dart';

import '../../../custom WIDGETS/custom_text.dart';

// ignore: must_be_immutable
class HomePieChart extends StatelessWidget {
  HomePieChart({super.key, this.isvisible = true});
  bool isvisible;

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 15),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Visibility(
                visible: isvisible,
                child: DropShadow(
                  borderRadius: 0.5,
                  blurRadius: 0.5,
                  offset: const Offset(1, 1),
                  spread: 0.1,
                  opacity: 0.5,
                  child: CustomText(
                    content: "Expense Monitor",
                    fontname: "Poppins",
                    size: 18,
                    weight: FontWeight.w600,
                    colour: Colors.green,
                  ),
                ),
              ),

              //info Button
              // IconButton(
              //     onPressed: () {},
              //     icon: const Icon(
              //       Icons.info,
              //       color: Color.fromARGB(244, 93, 93, 93),
              //     ))
            ],
          ),
        ),
        Padding(
          padding: const EdgeInsets.all(4.0),
          child: SizedBox(
              width: 300,
              height: 300,
              child: Stack(
                children: [
//pie chart =============================================================================
                  ValueListenableBuilder(
                    valueListenable: totalAmountExpense,
                    builder: (context, value, child) => ValueListenableBuilder(
                      valueListenable: categoryExpenseWiseTotalAmount,
                      builder: (context, value, child) {
                        return DropShadow(
                          borderRadius: 0.5,
                          blurRadius: 8,
                          offset: const Offset(3, 3),
                          spread: 0.7,
                          opacity: 0.5,
                          child: PieChart(
                              swapAnimationDuration: const Duration(seconds: 2),
                              swapAnimationCurve: Curves.bounceIn,
                              PieChartData(
                                  sections: totalAmountExpense.value <= 0
                                      ? [
                                          PieChartSectionData(
                                              color: Colors.green)
                                        ]
                                      : getData() //this function return piechart data
                                  )),
                        );
                      },
                    ),
                  ),
// center text======================================================================================
                  Center(
                    child: SizedBox(
                      width: 200,
                      height: 80,
                      child: Column(
                        mainAxisSize: MainAxisSize.min,
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          ValueListenableBuilder(
                            valueListenable: totalAmountExpense,
                            builder: (context, value, child) {
                              return totalAmountExpense.value <= 0
                                  ? CustomText(
                                      content: "Data not found!",
                                      fontname: 'Poppins',
                                      weight: FontWeight.w600,
                                    )
                                  : Row(
                                      mainAxisAlignment:
                                          MainAxisAlignment.center,
                                      children: [
                                        CustomText(content: "-\u20b9"),
                                        McCountingText(
                                          begin: 0,
                                          end: totalAmountExpense.value,
                                          precision: 2,
                                          style: const TextStyle(
                                              color: Colors.red),
                                          duration: const Duration(seconds: 1),
                                          curve: Curves.fastOutSlowIn,
                                        ),
                                      ],
                                    );
                            },
                          ),
                          ValueListenableBuilder(
                            valueListenable: totalAmountIncome,
                            builder: (context, value, child) {
                              return totalAmountIncome.value <= 0
                                  ? CustomText(
                                      content: " ",
                                      fontname: 'Poppins',
                                      weight: FontWeight.w600,
                                    )
                                  : Row(
                                      mainAxisAlignment:
                                          MainAxisAlignment.center,
                                      children: [
                                        CustomText(content: "+\u20b9"),
                                        McCountingText(
                                          begin: 0,
                                          end: totalAmountIncome.value
                                              .toDouble(),
                                          precision: 2,
                                          style: const TextStyle(
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
                    ),
                  ),
                ],
              )),
        ),
      ],
    );
  }
}
