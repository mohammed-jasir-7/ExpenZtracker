import 'package:expenztracker/Database/DB%20function/db_function.dart';

import 'package:expenztracker/screens/home/widgets/home_categories_content.dart';

import 'package:flutter/material.dart';

class HomeCategoryItems extends StatefulWidget {
  const HomeCategoryItems({super.key});

  @override
  State<HomeCategoryItems> createState() => _HomeCategoryItemsState();
}

class _HomeCategoryItemsState extends State<HomeCategoryItems> {
  @override
  Widget build(BuildContext context) {
    Size size = MediaQuery.of(context).size;

    return Padding(
      padding: const EdgeInsets.all(8.0),
      child: SizedBox(
        width: size.width,
        height: 80,
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Expanded(
              child: ValueListenableBuilder(
                valueListenable: totalAmountExpense,
                builder: (context, value, child) => ValueListenableBuilder(
                  valueListenable: categoryWiseTotalAmount,
                  builder: (context, value, _) {
                    return ListView.separated(
                        scrollDirection: Axis.horizontal,
                        shrinkWrap: true,
                        physics: const BouncingScrollPhysics(),
                        itemBuilder: (context, index) {
                          categoryExpenseWiseTotalAmount.value.sort(
                            (a, b) => b.total.compareTo(a.total),
                          );
                          categoryExpenseWiseTotalAmount.value
                              .reversed; //this is the list which stored by getCategoeryWiseData()
                          int percenage = totalAmountExpense.value <= 0
                              ? 0
                              : (categoryExpenseWiseTotalAmount
                                          .value[index].total /
                                      totalAmountExpense.value *
                                      100)
                                  .toInt()
                                  .round();
                          //=========================     this is top circle ======================================
                          return CategoryContent(
                              category: categoryExpenseWiseTotalAmount
                                  .value[index].category,
                              color: categoryExpenseWiseTotalAmount
                                  .value[index].category.color,
                              percentgeSpec: percenage.toString());
                        },
                        separatorBuilder: (context, index) => const SizedBox(
                              width: 1,
                            ),
                        itemCount:
                            categoryExpenseWiseTotalAmount.value.length - 1);
                  },
                ),
              ),
            )
          ],
        ),
      ),
    );
  }
}
