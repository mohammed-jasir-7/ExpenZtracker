import 'package:expenztracker/business_logic/transaction_provider.dart';
import 'package:expenztracker/custom%20WIDGETS/custom_text.dart';
import 'package:expenztracker/presentation/screens/planner/planner_card.dart';

import 'package:flutter/material.dart';
import 'package:hive_flutter/hive_flutter.dart';
import 'package:provider/provider.dart';

import '../../../Data/Model/model_transaction.dart';
import '../../../Data/repositiories/db_function.dart';
import '../../../notification/notification_api.dart';

import '../home/widgets/home_appbar.dart';

//planner screeen
class PlannerScreen extends StatefulWidget {
  const PlannerScreen({super.key});

  @override
  State<PlannerScreen> createState() => _PlannerScreenState();
}

class _PlannerScreenState extends State<PlannerScreen> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      resizeToAvoidBottomInset: false,
      appBar: PreferredSize(
          preferredSize: const Size.fromHeight(50),
          child: HomeAppBar(
            leadingIcon: false,
          )),
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.all(8.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const PlannerCard(), // card to select plan

              const Divider(
                thickness: 2,
              ),
              //next section
              Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: Column(
                    children: [
                      Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Stack(
                            children: [
                              CustomText(content: "This month "),
                            ],
                          ),
                          IconButton(
                              onPressed: () {
                                final hh = getPlanner();
                                final keyPlanner = hh.keys;
                                hh.delete(keyPlanner.first);
                              },
                              icon: const Icon(Icons.delete))
                        ],
                      ),
                      Padding(
                        padding: const EdgeInsets.symmetric(vertical: 15),
                        child: Row(
                            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                            children: [
                              CustomText(content: "Category"),
                              CustomText(content: "Limit"),
                              CustomText(content: "Balance"),
                              CustomText(content: "Daily Avg")
                            ]),
                      ),
                      Column(
                        children: [
                          ValueListenableBuilder(
                            valueListenable: getPlanner().listenable(),
                            builder: (context, value, child) =>
                                Consumer<TransactionModel>(
                              builder: (context, value, child) => FutureBuilder(
                                future: plannerFiltr(),
                                builder: (context, snapshot) {
                                  if (snapshot.hasData) {
                                    if (snapshot.data != null) {
                                      final list = snapshot.data
                                          as List<Map<Category, int>>;
                                      final List<Category> keyOfMap =
                                          list[0].keys.toList();
                                      final List<int> mapValues =
                                          list[0].values.toList();

                                      return SizedBox(
                                        height: 200,
                                        child: Column(
                                          children: [
                                            Expanded(
                                              child: ListView.separated(
                                                  shrinkWrap: true,
                                                  itemBuilder:
                                                      (context, index) {
                                                    return Row(
                                                      mainAxisAlignment:
                                                          MainAxisAlignment
                                                              .spaceEvenly,
                                                      children: [
                                                        CustomText(
                                                          content:
                                                              keyOfMap[index]
                                                                  .categoryName,
                                                          colour: Color(
                                                              keyOfMap[index]
                                                                  .color),
                                                        ),
                                                        CustomText(
                                                            content: mapValues[
                                                                    index]
                                                                .toString()),
                                                        CustomText(
                                                            content: datewiseplanner
                                                                    .value
                                                                    .isEmpty
                                                                ? "--"
                                                                : datewiseplanner
                                                                            .value[
                                                                                index]
                                                                            .total ==
                                                                        0
                                                                    ? "--"
                                                                    : (mapValues[index] -
                                                                            datewiseplanner.value[index].total)
                                                                        .toString()),
                                                        CustomText(
                                                            content: datewiseplanner
                                                                    .value
                                                                    .isEmpty
                                                                ? "--"
                                                                : datewiseplanner
                                                                            .value[
                                                                                index]
                                                                            .total ==
                                                                        0
                                                                    ? "--"
                                                                    : ((mapValues[index] -
                                                                                datewiseplanner.value[index].total) /
                                                                            30)
                                                                        .truncate()
                                                                        .toString())
                                                      ],
                                                    );
                                                  },
                                                  separatorBuilder:
                                                      (context, index) =>
                                                          const Divider(),
                                                  itemCount: keyOfMap.length),
                                            ),
                                          ],
                                        ),
                                      );
                                    } else {
                                      return const Text("data");
                                    }
                                  } else {
                                    return Center(
                                      child:
                                          CustomText(content: "No data found"),
                                    );
                                  }
                                },
                              ),
                            ),
                          ),
                        ],
                      )
                    ],
                  ))
            ],
          ),
        ),
      ),
    );
  }
}

Future<List<Map<Category, int>>?> plannerFiltr() async {
  print("notificat");
  datewiseplanner.value.clear();
  //get pplanner box here
  //convert to list
  final box = getPlanner();
  List<Planner> plannerList = box.values.toList();
  //itrate

  for (var element in plannerList) {
    //check plans. start date andd curent date
    //if its true itrate list of map in element
    if (element.start.month ==
            DateTime(DateTime.now().year, DateTime.now().month, 1)
                .month && //chech date and year same as now

        element.start.year ==
            DateTime(DateTime.now().year, DateTime.now().month + 1, 0).year) {
      for (var category in element.budget) {
        //map itrate and pass category to filterDateWiseExp()
        //that function check some condition after add Values to Valuenotifier- datewiseplanner
        category.forEach((key, value) {
          filterDateWiseExp(key);
        });
      }

      //================== sample ======================
      for (var cate in element.budget) {
        final ke = element.budget[0].values.toList();
        for (int i = 0; i < ke.length; i++) {
          num amt = ke[i] - datewiseplanner.value[i].total;
          print("here ${datewiseplanner.value[i].total}");
          if (amt <= 0) {
            NotificationApi.showNotifi(
                date: DateTime.now().add(const Duration(minutes: 1)),
                body: "Your expense crossed limit",
                title: "warning",
                playoad: " ");
          }
        }
      }
      //============================================================
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
            plannerDateRange.value.start.subtract(const Duration(days: 1))) &&
        element.date.isBefore(
            plannerDateRange.value.end.add(const Duration(days: 1)))) {
      if (element.category.categoryName == categoryname.categoryName) {
        amount += element.amount;
      }
    }
  }
  final obj = Categoryawise(category: categoryname, total: amount);
  datewiseplanner.value.add(obj);
  datewiseplanner.notifyListeners();
}
