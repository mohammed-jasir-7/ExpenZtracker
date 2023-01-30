import 'package:expenztracker/custom%20WIDGETS/custom_text.dart';
import 'package:expenztracker/presentation/screens/insight/widgets/total_epense_indicator.dart';
import 'package:expenztracker/presentation/screens/insight/widgets/total_income_indicator.dart';

import 'package:flutter/material.dart';

import 'package:intl/intl.dart';

import '../../../../Data/Model/model_transaction.dart';
import '../../../../Data/repositiories/db_function.dart';

// this variabble for date range
ValueNotifier<DateTimeRange> dateRangeOfCard = ValueNotifier(DateTimeRange(
    start: DateTime.now().subtract(const Duration(days: 30)),
    end: DateTime.now()));
ValueNotifier<double> totalIncomeFilterBased = ValueNotifier(0);
ValueNotifier<double> totalExpenseFilterBased = ValueNotifier(0);

// overview card
class CardOne extends StatefulWidget {
  const CardOne({super.key});

  @override
  State<CardOne> createState() => _CardOneState();
}

class _CardOneState extends State<CardOne> {
  int dropdownvalue = 1;
  bool totalIncomePercentageCard = false;
  bool totalExpensePercentageCard = false;

  @override
  void initState() {
    WidgetsBinding.instance.addPostFrameCallback((_) {
      // Add Your Code here.
      onchangedd(1);
    });

    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    Size size = MediaQuery.of(context).size;
// animated container
    return AnimatedContainer(
      width: size.width,
      duration: const Duration(seconds: 3),
      constraints: BoxConstraints(minHeight: size.height / 3),
      child: Column(
        children: [
// date row ===========================================================
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
// drop down button =============================
              ClipRRect(
                borderRadius: BorderRadius.circular(30),
                child: Container(
                  color: Colors.green[100],
                  width: size.width / 3.5,
                  height: 40,
                  child: Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: DropdownButton(
                      alignment: AlignmentDirectional.center,
                      value: dropdownvalue,
                      borderRadius: BorderRadius.circular(20),
                      icon: const SizedBox(),
                      underline: const SizedBox(),
                      items: [
                        DropdownMenuItem(
                          value: 1,
                          child: CustomText(
                            content: "Last 30 Days",
                            fontname: "Poppins",
                            size: 13,
                            weight: FontWeight.w600,
                            colour: const Color.fromARGB(221, 51, 51, 51),
                          ),
                        ),
                        DropdownMenuItem(
                          value: 2,
                          child: CustomText(
                            content: "Last year",
                            fontname: "Poppins",
                            size: 13,
                            weight: FontWeight.w600,
                            colour: const Color.fromARGB(221, 51, 51, 51),
                          ),
                        ),
                        DropdownMenuItem(
                          value: 3,
                          child: CustomText(
                            content: "Custom",
                            fontname: "Poppins",
                            size: 13,
                            weight: FontWeight.w600,
                            colour: const Color.fromARGB(221, 51, 51, 51),
                          ),
                        )
                      ],
//================== drop down button function ===================================================================
                      onChanged: (value) {
                        onchangedd(value);
                      },
                    ),
//drop down end ==================================================================================
                  ),
                ),
              ),
//date text
              CustomText(
                content:
                    '${DateFormat.MMM().format(dateRangeOfCard.value.start)} ${dateRangeOfCard.value.start.day}-${DateFormat.MMM().format(dateRangeOfCard.value.end)} ${dateRangeOfCard.value.end.day}',
                fontname: "Poppins",
                weight: FontWeight.w600,
              )
            ],
          ),
          // date row end here ==================================================================
          const Divider(
            thickness: 2,
          ),
//heading overview
          CustomText(
            content: "Overview",
            size: 25,
            fontname: "Poppins",
            weight: FontWeight.w600,
            colour: Colors.green[400],
          ),
// discription
          CustomText(
            content:
                "Visit insights regularly to check on your\ncontent's perfomance",
            size: 13,
            fontname: "Poppins",
            weight: FontWeight.w500,
            colour: const Color.fromARGB(255, 119, 119, 119),
            align: TextAlign.center,
          ),
//==============================tile total income =====================================
          InkWell(
            splashColor: const Color.fromARGB(107, 76, 175, 79),
            child: ListTile(
              title: CustomText(
                content: "total income",
                fontname: 'Poppins',
                size: 15,
              ),
              trailing: ValueListenableBuilder(
                valueListenable: dateRangeOfCard,
                builder: (context, value, child) => CustomText(
                  content: '+\u20B9${totalIncomeFilterBased.value}',
                  fontname: 'Poppins',
                  colour: Colors.green,
                ),
              ),
            ),
            onTap: () {
              setState(() {
                totalIncomePercentageCard = !totalIncomePercentageCard;
              });
            },
          ),
//visible when tab listile=====================================================
          Visibility(
              visible: totalIncomePercentageCard,
              child: const PercentageContainer()),
//================================ tile total expense =======================================
          InkWell(
            onTap: () {
              setState(() {
                totalExpensePercentageCard = !totalExpensePercentageCard;
              });
            },
            splashColor: const Color.fromARGB(110, 244, 67, 54),
            child: ListTile(
              title: CustomText(
                content: "total Expense",
                fontname: 'Poppins',
                size: 15,
              ),
              trailing: ValueListenableBuilder(
                valueListenable: dateRangeOfCard,
                builder: (context, value, child) => CustomText(
                  content: '-\u20B9${totalExpenseFilterBased.value}',
                  fontname: 'Poppins',
                  colour: Colors.red,
                ),
              ),
            ),
          ),
//visible when tab listile=====================================================
          Visibility(
              visible: totalExpensePercentageCard,
              child: const PercentageIndicatorTwo()),
//===================================== tile end ============================================
        ],
      ),
    );
  }

// insight function is here================================================
// this function to pick date range =================================
  datefunction() async {
    final date = await showDateRangePicker(
        context: context, firstDate: DateTime(2000), lastDate: DateTime(2050));
    setState(() {
      if (date != null) {
        dateRangeOfCard.value = date;
      }
    });
  }
  //=========================== end =================================

  //======== function filter=============================
  // this function value get when drop down  valuee change and that value passed into this function
  //it check condition (if)and disply date
  // value has send another function .that function filter data accroding to date range
  onchangedd(int? value) async {
    //if check value and assign daterange to valuenotifier varibale
    //that rebuild texxt (show daterange select wise)
    if (value != null) {
      setState(() {
        dropdownvalue = value;
      });
      if (value == 1) {
        setState(() {
          dateRangeOfCard.value = DateTimeRange(
              start: DateTime.now().subtract(const Duration(days: 30)),
              end: DateTime.now());
          dateRangeOfCard.notifyListeners();
        });
      } else if (value == 2) {
        setState(() {
          dateRangeOfCard.value = DateTimeRange(
              start: DateTime.now().subtract(const Duration(days: 365)),
              end: DateTime.now());
          dateRangeOfCard.notifyListeners();
        });
      } else {
        //pick custom daterange here
        await datefunction();
      }
    }
    //pass onchanged value as parameter

    datewiseDataFilter(value!);
  }
  //===================================================  functio end here ===============================

// function for filter data
//user select drop down and filter
// this function called in onchangedd()
  datewiseDataFilter(int value) {
    totalIncomeFilterBased.value = 0;
    totalExpenseFilterBased.value = 0;
    final box = Boxes.getTransaction().values.toList();
    for (var element in box) {
      if (element.categoryType == CategoryType.income) {
        if (element.date.isAfter(dateRangeOfCard.value.start) &&
            element.date.isBefore(dateRangeOfCard.value.end)) {
          totalIncomeFilterBased.value += element.amount;
          totalIncomeFilterBased.notifyListeners();
        }
      } else {
        if (element.date.isAfter(dateRangeOfCard.value.start) &&
            element.date.isBefore(dateRangeOfCard.value.end)) {
          totalExpenseFilterBased.value += element.amount;
          totalExpenseFilterBased.notifyListeners();
        }
      }
    }
    //===============================================================
    //last 30 days
    //   if (value == 1) {
    //     for (var element in box) {
    //       if (element.categoryType == CategoryType.income) {
    //         if (element.date.isAfter(dateRangeOfCard.value.start) &&
    //             element.date.isBefore(dateRangeOfCard.value.end)) {
    //           totalIncome += element.amount;
    //         }
    //       }
    //     }
    //   } else if (value == 2) {
    //     for (var element in box) {
    //       if (element.categoryType == CategoryType.income) {
    //         if (element.date.isAfter(dateRangeOfCard.value.start) &&
    //             element.date.isBefore(dateRangeOfCard.value.end)) {
    //           totalIncome += element.amount;
    //         }
    //       }
    //     }
    //     print(totalIncome);
    //   } else if (value == 3) {
    //     for (var element in box) {
    //       if (element.categoryType == CategoryType.income) {
    //         if (element.date.isAfter(dateRangeOfCard.value.start) &&
    //             element.date.isBefore(dateRangeOfCard.value.end)) {
    //           totalIncome += element.amount;
    //         }
    //       }
    //     }
    //   }
  }
}
