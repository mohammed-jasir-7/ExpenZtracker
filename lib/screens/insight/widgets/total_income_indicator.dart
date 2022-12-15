import 'package:expenztracker/screens/insight/widgets/first_card.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter/src/widgets/container.dart';
import 'package:flutter/src/widgets/framework.dart';
import 'package:percent_indicator/circular_percent_indicator.dart';

import '../../../Database/DB function/db_function.dart';
import '../../../custom WIDGETS/custom_text.dart';

//percentagr indicatr
class PercentageContainer extends StatefulWidget {
  const PercentageContainer({super.key});

  @override
  State<PercentageContainer> createState() => _PercentageContainerState();
}

class _PercentageContainerState extends State<PercentageContainer> {
  bool totalIncomeInfoButton = false;
  @override
  Widget build(BuildContext context) {
    Size size = MediaQuery.of(context).size;
    return AnimatedContainer(
      duration: Duration(seconds: 3),
      width: size.width,
      child: Stack(
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            children: [
              Column(
                children: [
                  CustomText(
                      content:
                          "${(((totalIncomeFilterBased.value / totalIncomeFilterBased.value * 100) - (totalExpenseFilterBased.value / totalIncomeFilterBased.value * 100))).truncate()}%"),
                  CustomText(content: "expense"),
                  Container(
                    width: 10,
                    height: 10,
                    color: Color.fromARGB(255, 183, 183, 183),
                  ),
                ],
              ),
              ValueListenableBuilder(
                valueListenable: totalExpenseFilterBased,
                builder: (context, value, child) => ValueListenableBuilder(
                  valueListenable: totalIncomeFilterBased,
                  builder: (context, value, child) => CircularPercentIndicator(
                    backgroundColor: Color.fromARGB(255, 183, 183, 183),
                    animation: true,
                    lineWidth: 20,
                    circularStrokeCap: CircularStrokeCap.round,
                    progressColor: Colors.green,
                    center: totalIncomeFilterBased.value <=
                            totalExpenseFilterBased.value
                        ? CustomText(content: "Loss")
                        : CustomText(
                            content:
                                "${((totalExpenseFilterBased.value / totalIncomeFilterBased.value * 100)).truncate()}%"),
                    radius: 70,
                    percent: totalIncomeFilterBased.value <=
                            totalExpenseFilterBased.value
                        ? 0.0
                        : totalExpenseFilterBased.value /
                            totalIncomeFilterBased.value,
                  ),
                ),
              ),
              Column(
                children: [
                  CustomText(
                      content:
                          "${(((totalExpenseFilterBased.value / totalIncomeFilterBased.value * 100))).truncate()}%"),
                  CustomText(content: "income"),
                  Container(
                    width: 10,
                    height: 10,
                    color: Colors.green,
                  ),
                ],
              ),
            ],
          ),
          //========================== i button ================
          Row(
            mainAxisAlignment: MainAxisAlignment.end,
            children: [
              Visibility(
                visible: totalIncomeInfoButton,
                child: AnimatedContainer(
                  curve: Curves.easeInOut,
                  color: Colors.white,
                  duration: const Duration(seconds: 3),
                  child: CustomText(
                      content: "this graph shows how much income exist"),
                ),
              ),
              InkWell(
                  splashColor: Colors.green,
                  onTap: () {
                    setState(() {
                      totalIncomeInfoButton = !totalIncomeInfoButton;
                    });
                  },
                  child: const Icon(
                    Icons.info,
                    color: Colors.grey,
                  )),
            ],
          ),

          //================== i button end here ====================
        ],
      ),
    );
  }
}
