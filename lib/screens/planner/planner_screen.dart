import 'package:expenztracker/Database/DB%20function/db_function.dart';
import 'package:expenztracker/Database/model/model_transaction.dart';
import 'package:expenztracker/custom%20WIDGETS/custom_text.dart';
import 'package:expenztracker/screens/home/widgets/home_appbar.dart';

import 'package:expenztracker/screens/planner/planner_card.dart';
import 'package:flutter/material.dart';

import 'package:hive/hive.dart';

//planner screeen
class PlannerScreen extends StatelessWidget {
  const PlannerScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      resizeToAvoidBottomInset: false,
      appBar: PreferredSize(
          preferredSize: const Size.fromHeight(50),
          child: HomeAppBar(
            leadingIcon: false,
          )),
      body: Padding(
        padding: const EdgeInsets.all(8.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            PlannerCard(),
            Divider(
              thickness: 2,
            ),
            //next section
            Padding(
                padding: const EdgeInsets.all(8.0),
                child: Column(
                  children: [
                    CustomText(content: "This month "),
                    Padding(
                      padding: const EdgeInsets.symmetric(vertical: 15),
                      child: Row(
                          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                          children: [
                            CustomText(content: "Categorry"),
                            CustomText(content: "Limit"),
                            CustomText(content: "Balance"),
                            CustomText(content: "Daily Avg")
                          ]),
                    ),
                    Column(
                      children: [
                        ValueListenableBuilder(
                          valueListenable: expenseList,
                          builder: (context, value, child) => FutureBuilder(
                            future: plannerFiltr(),
                            builder: (context, snapshot) {
                              if (snapshot.hasData) {
                                if (snapshot.data != null) {
                                  final list =
                                      snapshot.data as List<Map<Category, int>>;
                                  final List<Category> keyOfMap =
                                      list[0].keys.toList();
                                  final List<int> mapValues =
                                      list[0].values.toList();

                                  return Container(
                                    height: 200,
                                    child: Column(
                                      children: [
                                        Expanded(
                                          child: ListView.separated(
                                              shrinkWrap: true,
                                              itemBuilder: (context, index) {
                                                return Row(
                                                  mainAxisAlignment:
                                                      MainAxisAlignment
                                                          .spaceEvenly,
                                                  children: [
                                                    CustomText(
                                                        content: keyOfMap[index]
                                                            .categoryName),
                                                    CustomText(
                                                        content:
                                                            mapValues[index]
                                                                .toString()),
                                                    CustomText(
                                                        content: (mapValues[
                                                                    index] -
                                                                datewiseplanner
                                                                    .value[
                                                                        index]
                                                                    .total)
                                                            .toString()),
                                                    CustomText(
                                                        content:
                                                            (mapValues[index] /
                                                                    30)
                                                                .round()
                                                                .toString())
                                                  ],
                                                );
                                              },
                                              separatorBuilder:
                                                  (context, index) => Divider(),
                                              itemCount: keyOfMap.length),
                                        ),
                                      ],
                                    ),
                                  );
                                } else {
                                  return Text("data");
                                }
                              } else {
                                return Center(
                                  child: CircularProgressIndicator(),
                                );
                              }
                            },
                          ),
                        ),
                      ],
                    )
                  ],
                ))
          ],
        ),
      ),
    );
  }
}

Future<List<Map<Category, int>>?> plannerFiltr() async {
  //get pplanner box here
  //convert to list
  final box = await getPlanner();
  List<Planner> plannerList = box.values.toList();
  //itrate

  for (var element in plannerList) {
    //check plans. start date andd curent date
    //if its true itrate list of map in element
    if (element.start.month ==
            DateTime(DateTime.now().year, DateTime.now().month + 1, 1)
                .month && //chech date and year same as now

        element.start.year ==
            DateTime(DateTime.now().year, DateTime.now().month + 1, 1).year) {
      for (var category in element.budget) {
        //map itrate and pass category to filterDateWiseExp()
        //that function check some condition after add Values to Valuenotifier- datewiseplanner
        category.forEach((key, value) {
          filterDateWiseExp(key);
        });
      }
      return element
          .budget; //return list of map for future builder if datecondition is true
    } else {
      return null;
    }
  }
}

//receive category
//check exp elemrnt with plannerdate range
//check argument value with element in expense
//all conditio is true amout add and loop exit create obj and add to valuenotifier  datewiseplanner
filterDateWiseExp(Category categoryname) async {
  double amount = 0;
  for (var element in expenseList.value) {
    if (element.date.isAfter(
            plannerDateRange.value.start.subtract(Duration(days: 1))) &&
        element.date
            .isBefore(plannerDateRange.value.end.add(Duration(days: 1)))) {
      if (element.category.categoryName == categoryname.categoryName) {
        amount += element.amount;
      }
    }
  }
  final obj = Categoryawise(category: categoryname, total: amount);
  datewiseplanner.value.add(obj);
  datewiseplanner.notifyListeners();
}
