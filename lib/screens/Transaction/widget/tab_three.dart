import 'package:flutter/material.dart';

import 'package:flutter_slidable/flutter_slidable.dart';
import 'package:hive_flutter/hive_flutter.dart';
import 'package:intl/intl.dart';

import '../../../Database/DB function/db_function.dart';
import '../../../Database/model/model_transaction.dart';
import '../../../custom WIDGETS/custom_text.dart';
import '../../../custom WIDGETS/custom_textInput.dart';

class TabThree extends StatelessWidget {
  const TabThree({super.key});

  @override
  Widget build(BuildContext context) {
    return ValueListenableBuilder(
      valueListenable: expenseList,
      builder: (context, box, _) {
        //============================================================ list generated here ========================================
        return Expanded(
          child: ListView.separated(
              physics: BouncingScrollPhysics(),
              shrinkWrap: true,
              itemBuilder: (context, index) {
                var month =
                    DateFormat.MMM().format(expenseList.value[index].date);
                var year = DateFormat.y().format(expenseList.value[index].date);
                final amount = TextEditingController();
                final note = TextEditingController();
                amount.text = expenseList.value[index].amount.toString();

                int ind = -1;
                List bool = [];

                return Slidable(
                  //slidable              delete and edit button see when do slide
                  startActionPane: ActionPane(
                      extentRatio: 0.2,
                      motion: const BehindMotion(),
                      children: [
                        IconButton(
                            //  ============================ edit buttton ===========
                            onPressed: () {
                              getCategoryWiseData();
                            },
                            icon: const Icon(Icons.edit))
                      ]),
                  endActionPane: ActionPane(
                      extentRatio: 0.2,
                      motion: const BehindMotion(),
                      children: [
                        IconButton(
                            //================================= delete button ==================================
                            onPressed: () {
                              expenseList.value[index].delete();
                              getCategoryWiseData();
                            },
                            icon: const Icon(Icons.delete))
                      ]),
                  child: GestureDetector(
                    onTap: () {},
                    child: ConstrainedBox(
                      constraints: BoxConstraints(minHeight: 50),
                      child: Card(
                        child: ExpansionTile(
                          title: CustomText(
                            content:
                                expenseList.value[index].category.categoryName,
                            colour:
                                Color(expenseList.value[index].category.color),
                            size: 22,
                            weight: FontWeight.w600,
                          ),
                          leading: Column(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              CustomText(
                                content: expenseList.value[index].date.day
                                    .toString(),
                                size: 20,
                                weight: FontWeight.w700,
                              ),
                              CustomText(content: month),
                              CustomText(
                                  content: expenseList.value[index].date.year
                                      .toString()),
                            ],
                          ),
                          trailing: CustomText(
                            content:
                                ' +\u20b9 ${expenseList.value[index].amount.toString()}',
                            colour: expenseList
                                        .value[index].category.categoryType ==
                                    CategoryType.expense
                                ? Colors.red
                                : Colors.green,
                            size: 18,
                            weight: FontWeight.w600,
                          ),
                          subtitle: CustomText(
                            content: expenseList.value[index].note,
                            colour: Colors.grey,
                          ),
                          children: [
                            Column(
                              children: [
                                Divider(),
                                CustomText(content: "Edit Transaction"),
                                SizedBox(
                                  width: 250,
                                  child: CustomTextfiled(
                                    controller: amount,
                                    icon: Icons.currency_rupee,
                                  ),
                                ),
                                SizedBox(
                                  width: 250,
                                  child: CustomTextfiled(
                                    hint: expenseList.value[index].note == ''
                                        ? 'add note'
                                        : expenseList.value[index].note
                                            .toString(),
                                    controller: note,
                                    icon: Icons.note_add,
                                  ),
                                ),
                                SizedBox(
                                    width: 250,
                                    child: TextButton(
                                        onPressed: () {},
                                        child: Row(
                                          children: [
                                            Icon(Icons.calendar_month_outlined),
                                            CustomText(
                                                content:
                                                    '${expenseList.value[index].date.day.toString() + expenseList.value[index].date.month.toString()}')
                                          ],
                                        ))),
                              ],
                            ),
                            Container(
                              height: 33,
                              width: 250,
                              decoration: BoxDecoration(
                                  borderRadius: BorderRadius.circular(10)),
                              child: ElevatedButton(
                                  style: ButtonStyle(
                                      backgroundColor: MaterialStatePropertyAll(
                                          Colors.green)),
                                  onPressed: () {
                                    expenseList.value[index].amount =
                                        double.parse(amount.text);
                                    expenseList.value[index].note = note.text;
                                    expenseList.value[index].save();
                                    expenseList.notifyListeners();
                                  },
                                  child: CustomText(
                                    content: "Edit",
                                  )),
                            ),
                            SizedBox(
                              height: 15,
                            )
                          ],
                        ),
                      ),
                    ),
                  ),
                );
              },
              separatorBuilder: (context, index) => SizedBox(
                    height: 8,
                  ),
              itemCount: expenseList.value.length),
        );
      },
    );
  }
}
