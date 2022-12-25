import 'package:expenztracker/screens/Transaction/widget/tab_one.dart';
import 'package:flutter/material.dart';

import 'package:flutter_slidable/flutter_slidable.dart';

import 'package:intl/intl.dart';

import '../../../Database/DB function/db_function.dart';
import '../../../Database/model/model_transaction.dart';
import '../../../custom WIDGETS/custom_text.dart';
import '../../../custom WIDGETS/custom_textInput.dart';

class TabThree extends StatefulWidget {
  const TabThree({super.key});

  @override
  State<TabThree> createState() => _TabThreeState();
}

class _TabThreeState extends State<TabThree> {
  @override
  Widget build(BuildContext context) {
    return ValueListenableBuilder(
      valueListenable: expenseList,
      builder: (context, box, _) {
        //============================================================ list generated here ========================================
        return Expanded(
          child: ListView.separated(
              physics: const BouncingScrollPhysics(),
              shrinkWrap: true,
              itemBuilder: (context, index) {
                expenseList.value.sort((a, b) => b.date.compareTo(a.date));
                var month =
                    DateFormat.MMM().format(expenseList.value[index].date);

                final amount = TextEditingController();
                final note = TextEditingController();
                amount.text = expenseList.value[index].amount.toString();
                note.text = expenseList.value[index].note;

                return Slidable(
                  //slidable              delete and edit button see when do slide

                  endActionPane: ActionPane(
                      extentRatio: 0.2,
                      motion: const BehindMotion(),
                      children: [
                        IconButton(
                            //================================= delete button ==================================
                            onPressed: () {
                              expenseList.value[index].delete();
                              getCategoryWiseData();
                              categoryFilter();
                            },
                            icon: const Icon(Icons.delete))
                      ]),
                  child: GestureDetector(
                    onTap: () {},
                    child: ConstrainedBox(
                      constraints: const BoxConstraints(minHeight: 50),
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
                                '-\u20b9 ${expenseList.value[index].amount.toString()}',
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
                                const Divider(),
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
                                        onPressed: () async {
                                          DateTime? date =
                                              await selectdate(context);
                                          if (date != null) {
                                            setState(() {
                                              expenseList.value[index].date =
                                                  date;
                                              expenseList.value[index].save();
                                            });
                                          }
                                        },
                                        child: Row(
                                          children: [
                                            const Icon(
                                                Icons.calendar_month_outlined),
                                            CustomText(
                                                content:
                                                    "${expenseList.value[index].date.day}-${expenseList.value[index].date.month}-${expenseList.value[index].date.year}")
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
                                  style: const ButtonStyle(
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
                            const SizedBox(
                              height: 15,
                            )
                          ],
                        ),
                      ),
                    ),
                  ),
                );
              },
              separatorBuilder: (context, index) => const SizedBox(
                    height: 8,
                  ),
              itemCount: expenseList.value.length),
        );
      },
    );
  }
}
