import 'package:expenztracker/presentation/screens/insight/widgets/first_card.dart';

import 'package:flutter/material.dart';

import 'package:percent_indicator/circular_percent_indicator.dart';

import '../../../../Data/repositiories/db_function.dart';
import '../../../../custom WIDGETS/custom_text.dart';

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
      duration: const Duration(seconds: 3),
      width: size.width,
      child: Stack(
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            children: [
              Column(
                children: [
                  CustomText(
                      content: totalExpenseFilterBased.value <= 0
                          ? "0.0"
                          : totalIncomeFilterBased.value <=
                                  totalExpenseFilterBased.value
                              ? "100%"
                              : "${(totalExpenseFilterBased.value / totalIncomeFilterBased.value * 100).truncate()}%"),
                  CustomText(content: "expense"),
                  Container(
                    width: 10,
                    height: 10,
                    color: const Color.fromARGB(255, 183, 183, 183),
                  ),
                ],
              ),
              ValueListenableBuilder(
                valueListenable: totalExpenseFilterBased,
                builder: (context, value, child) => ValueListenableBuilder(
                  valueListenable: totalIncomeFilterBased,
                  builder: (context, value, child) => CircularPercentIndicator(
                    backgroundColor: const Color.fromARGB(255, 183, 183, 183),
                    animation: true,
                    lineWidth: 20,
                    circularStrokeCap: CircularStrokeCap.round,
                    progressColor: Colors.green,
                    center: totalIncomeFilterBased.value <=
                            totalExpenseFilterBased.value
                        ? CustomText(content: "Loss")
                        : CustomText(
                            content:
                                "${((totalIncomeFilterBased.value / totalIncomeFilterBased.value * 100) - (totalExpenseFilterBased.value / totalIncomeFilterBased.value * 100)).truncate()}%"),
                    radius: 70,
                    percent: totalIncomeFilterBased.value <=
                                totalExpenseFilterBased.value ||
                            totalAmountIncome.value == 0
                        ? 0.0
                        : (totalIncomeFilterBased.value /
                                totalIncomeFilterBased.value) -
                            (totalExpenseFilterBased.value /
                                    totalIncomeFilterBased.value)
                                .truncate(),
                  ),
                ),
              ),
              Column(
                children: [
                  CustomText(
                      content: totalIncomeFilterBased.value <= 0
                          ? "0.0"
                          : totalIncomeFilterBased.value <=
                                  totalExpenseFilterBased.value
                              ? "0.0%"
                              : "${((totalIncomeFilterBased.value / totalIncomeFilterBased.value * 100) - (totalExpenseFilterBased.value / totalIncomeFilterBased.value * 100).truncate()).truncate()}%"),
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
                      content: "This Graph shows how much Income exist"),
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
