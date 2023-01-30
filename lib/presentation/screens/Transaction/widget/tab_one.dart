import 'package:flutter/material.dart';

import 'package:flutter_slidable/flutter_slidable.dart';
import 'package:hive_flutter/hive_flutter.dart';
import 'package:intl/intl.dart';

import '../../../../Data/Model/model_transaction.dart';
import '../../../../Data/repositiories/db_function.dart';
import '../../../../custom WIDGETS/custom_text.dart';
import '../../../../custom WIDGETS/custom_textInput.dart';
import '../../insight/insight_screen.dart';

class TabOne extends StatefulWidget {
  const TabOne({super.key});

  @override
  State<TabOne> createState() => _TabOneState();
}

class _TabOneState extends State<TabOne> {
  @override
  Widget build(BuildContext context) {
    return ValueListenableBuilder<Box<Transaction>>(
      valueListenable: Boxes.getTransaction().listenable(),
      builder: (context, box, _) {
        final transaction = box.values.toList().cast<Transaction>();
        transaction.sort(
          (a, b) => b.date.compareTo(a.date), // sort date wise
        );
        //============================================================ list generated here ========================================
        return Expanded(
          child: ListView.separated(
              physics: const BouncingScrollPhysics(),
              shrinkWrap: true,
              itemBuilder: (context, index) {
                var month = DateFormat.MMM().format(transaction[index].date);
                final amount = TextEditingController();
                final note = TextEditingController();
                amount.text = transaction[index].amount.toString();

                note.text = transaction[index].note;

                return Slidable(
                  //slidable              delete and edit button see when do slide

                  endActionPane: ActionPane(
                      extentRatio: 0.2,
                      motion: const BehindMotion(),
                      children: [
                        IconButton(
                            //================================= delete button ==================================
                            onPressed: () {
                              transaction[index].delete();
                              getCategoryWiseData();
                              categoryFilter();
                              insightFilter();
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
                            content: transaction[index].category.categoryName,
                            colour: Color(transaction[index].category.color),
                            size: 22,
                            weight: FontWeight.w600,
                          ),
                          leading: Column(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              CustomText(
                                content: transaction[index].date.day.toString(),
                                size: 20,
                                weight: FontWeight.w700,
                              ),
                              CustomText(content: month),
                              CustomText(
                                  content:
                                      transaction[index].date.year.toString()),
                            ],
                          ),
                          trailing: CustomText(
                            content: transaction[index].categoryType ==
                                    CategoryType.income
                                ? ' +\u20b9 ${transaction[index].amount.toString()}'
                                : ' -\u20b9 ${transaction[index].amount.toString()}',
                            colour: transaction[index].category.categoryType ==
                                    CategoryType.expense
                                ? Colors.red
                                : Colors.green,
                            size: 18,
                            weight: FontWeight.w600,
                          ),
                          subtitle: CustomText(
                            content: transaction[index].note,
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
                                    hint: transaction[index].note == ''
                                        ? 'add note'
                                        : transaction[index].note.toString(),
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
                                              transaction[index].date = date;
                                              transaction[index].save();
                                            });
                                          }
                                        },
                                        child: Row(
                                          children: [
                                            const Icon(
                                                Icons.calendar_month_outlined),
                                            CustomText(
                                                content:
                                                    '${transaction[index].date.day}-${transaction[index].date.month}-${transaction[index].date.year}')
                                          ],
                                        ))),
                              ],
                            ),
                            //edit button================================
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
                                    transaction[index].amount =
                                        double.parse(amount.text);
                                    transaction[index].note = note.text;

                                    transaction[index].save();
                                    getCategoryWiseData();
                                    categoryFilter();
                                    insightFilter();
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
              itemCount: transaction.length),
        );
      },
    );
  }
}

Future<DateTime?> selectdate(BuildContext context) async {
  DateTime? date = await showDatePicker(
      context: context,
      initialDate: DateTime.now(),
      firstDate: DateTime(2000),
      lastDate: DateTime(2050));
  return date;
}
