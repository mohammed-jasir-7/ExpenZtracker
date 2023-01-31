import 'package:expenztracker/custom%20WIDGETS/custom_text.dart';

import 'package:flutter/material.dart';

import '../../../../Data/repositiories/db_function.dart';
import 'home_categories_content.dart';

class HomeCategoryItems extends StatelessWidget {
  const HomeCategoryItems({super.key});

  @override
  Widget build(BuildContext context) {
    Size size = MediaQuery.of(context).size;

    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 15),
      child: SizedBox(
        width: size.width,
        height: 150,
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.start,
              children: [
                Padding(
                  padding: const EdgeInsets.only(left: 10, top: 5),
                  child: CustomText(
                    content: "Category",
                    fontname: "Poppins",
                    size: 15,
                    colour: const Color.fromARGB(255, 63, 63, 63),
                  ),
                ),
              ],
            ),
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
            ),
            const Divider(
              thickness: 1,
            ),
          ],
        ),
      ),
    );
  }
}
