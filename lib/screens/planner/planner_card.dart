import 'package:expenztracker/Database/DB%20function/db_function.dart';
import 'package:expenztracker/Database/model/model_transaction.dart';
import 'package:flutter/material.dart';

import 'package:intl/intl.dart';

import '../../custom WIDGETS/custom_text.dart';

//planner card==
ValueNotifier<DateTimeRange> plannerDateRange = ValueNotifier(DateTimeRange(
    start: DateTime(DateTime.now().year, DateTime.now().month + 1, 1),
    end: DateTime(DateTime.now().year, DateTime.now().month + 2, 0)));

class PlannerCard extends StatefulWidget {
  const PlannerCard({super.key});

  @override
  State<PlannerCard> createState() => _PlannerCardState();
}

class _PlannerCardState extends State<PlannerCard> {
  // variables
  bool isVisible = false; //planner form visbilit
  bool isVisiblePlannerButton = true; //planner button visibility

  List<Category> expCategory =
      expenseCategoryList.value; // expense category list
  final List<TextEditingController> _controller =
      []; //textediting controller used lin list viewbuilder
  @override
  void dispose() {
    // TODO: implement disp

    super.dispose();
  }

  int dropdownvalue = 1; //date dropdown init value
  @override
  Widget build(BuildContext context) {
    var balanceAmount = totalAmountIncome.value - totalAmountExpense.value;
    _controller.clear();
    Size size = MediaQuery.of(context).size;
    return AnimatedContainer(
      width: size.width,
      duration: const Duration(seconds: 3),
      constraints: BoxConstraints(minHeight: 100),
      child: Padding(
        padding: const EdgeInsets.all(8.0),
        child: Column(
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                //drop down =================
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
                              content: " Next month",
                              fontname: "Poppins",
                              size: 13,
                              weight: FontWeight.w600,
                              colour: const Color.fromARGB(221, 51, 51, 51),
                            ),
                          ),
                          // DropdownMenuItem(
                          //   value: 2,
                          //   child: CustomText(
                          //     content: " Next year",
                          //     fontname: "Poppins",
                          //     size: 13,
                          //     weight: FontWeight.w600,
                          //     colour: const Color.fromARGB(221, 51, 51, 51),
                          //   ),
                          // ),
                          DropdownMenuItem(
                            value: 2,
                            child: CustomText(
                              content: "Custom",
                              fontname: "Poppins",
                              size: 13,
                              weight: FontWeight.w600,
                              colour: const Color.fromARGB(221, 51, 51, 51),
                            ),
                          ),
                        ],
                        //================== drop down button function ===================================================================
                        onChanged: (value) {
                          onchangedd(value);
                          print(plannerDateRange.value);
                        },
                      ),
                      //drop down end ==================================================================================
                    ),
                  ),
                ),
                CustomText(
                  content:
                      '${DateFormat.MMM().format(plannerDateRange.value.start)} ${plannerDateRange.value.start.day}-${DateFormat.MMM().format(plannerDateRange.value.end)} ${plannerDateRange.value.end.day}',
                  fontname: "Poppins",
                  weight: FontWeight.w600,
                )
              ],
            ),
            //title text ===============================================
            CustomText(content: "Set Plan"),
            CustomText(content: "Set Daily or Categorywise budget"),
//============================================================= planner button ===============================
            Visibility(
              visible: isVisiblePlannerButton,
              child: Padding(
                padding: const EdgeInsets.only(top: 20),
                child: Container(
                  decoration: BoxDecoration(
                      border: Border.all(color: Colors.green, width: 5),
                      borderRadius: BorderRadius.circular(100)),
                  height: 200,
                  width: 200,
                  child: ClipRRect(
                    borderRadius: BorderRadius.circular(200),
                    child: ElevatedButton(
                      style: ButtonStyle(
                          backgroundColor:
                              MaterialStateProperty.all(Colors.green[100])),
                      onPressed: () {
                        setState(() {
                          isVisible = !isVisible;
                          isVisiblePlannerButton = false;
                        });
                      },
                      child: CustomText(
                        content: "Plan",
                        size: 30,
                      ),
                    ),
                  ),
                ),
              ),
            ),
//planner button end==========================
// list view builder
//planner form ==============================================================
            CustomText(
              content: 'balance ${balanceAmount}',
              colour: Colors.green,
            ),
            Visibility(
              visible: isVisible,
              child: Padding(
                padding: const EdgeInsets.only(top: 20),
                child: Container(
                  color: Colors.green[100],
                  width: size.width / 1.2,
                  height: 100,
                  child: Padding(
                    padding: const EdgeInsets.only(left: 0),
                    child: ListView.builder(
                      //listview builder==
                      physics: BouncingScrollPhysics(),
                      shrinkWrap: true,
                      itemCount: expCategory.length,
                      itemBuilder: (ctx, index) {
                        final textcont =
                            TextEditingController(); //pass texteditiong contriller to a list
                        _controller.add(textcont);

                        return Container(
                          decoration: BoxDecoration(
                              border: Border.all(color: Colors.green),
                              borderRadius: BorderRadius.circular(0)),
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              //category name
                              CustomText(
                                content: expCategory[index].categoryName,
                                colour: Color(expCategory[index].color),
                              ),
                              const SizedBox(
                                width: 20,
                              ),
                              //textfield =============================================
                              Container(
                                  width: 150,
                                  child: TextField(
                                    decoration: const InputDecoration(
                                        prefixIcon: Icon(
                                          Icons.currency_rupee,
                                          size: 22,
                                        ),
                                        enabledBorder: InputBorder.none,
                                        focusedBorder: InputBorder.none),
                                    keyboardType: TextInputType.number,
                                    controller: textcont,
                                  ))
                              //---------------------------------------------------------
                            ],
                          ),
                        );
                      },
                    ),
                  ),
                ),
              ),
            ),
            Visibility(
              visible: isVisible,
              child: TextButton(
                  onPressed: () async {
                    List<Map<Category, int>> budget = [];
                    Map<Category, int> mapBudget =
                        expenseCategoryList.value.asMap().map(
                      (key, value) {
                        return MapEntry(
                            value,
                            _controller[key].text.isEmpty
                                ? 0
                                : int.parse(_controller[key].text));
                      },
                    );
                    mapBudget.removeWhere((key, value) => value == 0);

                    // print(_controller.length);
                    // final box = Hive.box<Planner>('planner');
                    budget.add(mapBudget);

                    // box.add(
                    bool monthcheck = false;
                    if (mapBudget.isNotEmpty) {
                      final box = await getPlanner();

                      List<Planner> plannerlist = box.values.toList();
                      for (var element in plannerlist) {
                        print(monthcheck);
                        if (element.start.year ==
                                DateTime(
                                        DateTime.now().year,
                                        DateTime.now().month + 1,
                                        DateTime.now().day)
                                    .year &&
                            element.start.month ==
                                DateTime(
                                        DateTime.now().year,
                                        DateTime.now().month + 1,
                                        DateTime.now().day)
                                    .month) {
                          monthcheck = true;
                          print("ffffffff");
                        } else {
                          setState(() {
                            monthcheck = false;
                          });
                        }
                      }

                      if (monthcheck == false) {
                        final obj = Planner(
                            start: plannerDateRange.value.start,
                            end: plannerDateRange.value.end,
                            budget: budget);
                        addPlanner(obj);
                        print("dd");
                        print("hhhh");
                      } else {
                        print("have plan");
                      }
                    }

                    setState(() {
                      isVisiblePlannerButton = true;
                      isVisible = false;
                    });
                  },
                  child: CustomText(content: "set")),
            )
          ],
        ),
      ),
    );
  }

  onchangedd(int? value) async {
    //if check value and assign daterange to valuenotifier varibale
    //that rebuild texxt (show daterange select wise)
    if (value != null) {
      setState(() {
        dropdownvalue = value;
      });
      if (value == 1) {
        setState(() {
          plannerDateRange.value = DateTimeRange(
              start: DateTime(DateTime.now().year, DateTime.now().month + 1, 1),
              end: DateTime(DateTime.now().year, DateTime.now().month + 2, 0));

          plannerDateRange.notifyListeners();
        });
      } else if (value == 2) {
        setState(() {
          final date = datefunction();
          plannerDateRange.value = date;
          plannerDateRange.notifyListeners();
        });
      }
    }
    //pass onchanged value as parameter
  }

  datefunction() async {
    final date = await showDateRangePicker(
        context: context, firstDate: DateTime.now(), lastDate: DateTime(2050));
    setState(() {
      if (date != null) {
        plannerDateRange.value = date;
      }
    });
  }
}
