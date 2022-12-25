import 'package:expenztracker/screens/Transaction/widget/tab_one.dart';
import 'package:flutter/material.dart';

import 'package:flutter_slidable/flutter_slidable.dart';

import 'package:intl/intl.dart';

import '../../../Database/DB function/db_function.dart';
import '../../../Database/model/model_transaction.dart';
import '../../../custom WIDGETS/custom_text.dart';
import '../../../custom WIDGETS/custom_textInput.dart';

class TabTwo extends StatefulWidget {
  const TabTwo({super.key});

  @override
  State<TabTwo> createState() => _TabTwoState();
}

class _TabTwoState extends State<TabTwo> {
  @override
  Widget build(BuildContext context) {
    return ValueListenableBuilder(
      valueListenable: incomeList,
      builder: (context, box, _) {
        //============================================================ list generated here ========================================
        return Expanded(
          child: ListView.separated(
              physics: const BouncingScrollPhysics(),
              shrinkWrap: true,
              itemBuilder: (context, index) {
                incomeList.value.sort((a, b) => b.date.compareTo(a.date));
                var month =
                    DateFormat.MMM().format(incomeList.value[index].date);

                final amount = TextEditingController();
                final note = TextEditingController();
                amount.text = incomeList.value[index].amount.toString();
                note.text = incomeList.value[index].note;

                return Slidable(
                  //slidable              delete and edit button see when do slide

                  endActionPane: ActionPane(
                      extentRatio: 0.2,
                      motion: const BehindMotion(),
                      children: [
                        IconButton(
                            //================================= delete button ==================================
                            onPressed: () {
                              incomeList.value[index].delete();
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
                                incomeList.value[index].category.categoryName,
                            colour:
                                Color(incomeList.value[index].category.color),
                            size: 22,
                            weight: FontWeight.w600,
                          ),
                          leading: Column(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              CustomText(
                                content:
                                    incomeList.value[index].date.day.toString(),
                                size: 20,
                                weight: FontWeight.w700,
                              ),
                              CustomText(content: month),
                              CustomText(
                                  content: incomeList.value[index].date.year
                                      .toString()),
                            ],
                          ),
                          trailing: CustomText(
                            content:
                                ' +\u20b9 ${incomeList.value[index].amount.toString()}',
                            colour:
                                incomeList.value[index].category.categoryType ==
                                        CategoryType.expense
                                    ? Colors.red
                                    : Colors.green,
                            size: 18,
                            weight: FontWeight.w600,
                          ),
                          subtitle: CustomText(
                            content: incomeList.value[index].note,
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
                                    hint: incomeList.value[index].note == ''
                                        ? 'add note'
                                        : incomeList.value[index].note
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
                                              incomeList.value[index].date =
                                                  date;
                                              incomeList.value[index].save();
                                            });
                                          }
                                        },
                                        child: Row(
                                          children: [
                                            const Icon(
                                                Icons.calendar_month_outlined),
                                            CustomText(
                                                content:
                                                    "${incomeList.value[index].date.day}-${incomeList.value[index].date.month}-${incomeList.value[index].date.year}")
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
                                    incomeList.value[index].amount =
                                        double.parse(amount.text);
                                    incomeList.value[index].note = note.text;
                                    incomeList.value[index].save();
                                    incomeList.notifyListeners();
                                    categoryFilter();
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
              itemCount: incomeList.value.length),
        );
      },
    );
  }
}
