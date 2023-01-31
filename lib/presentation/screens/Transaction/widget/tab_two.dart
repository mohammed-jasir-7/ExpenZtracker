import 'package:expenztracker/business_logic/transaction_provider.dart';
import 'package:expenztracker/presentation/screens/Transaction/widget/tab_one.dart';

import 'package:flutter/material.dart';

import 'package:flutter_slidable/flutter_slidable.dart';

import 'package:intl/intl.dart';
import 'package:provider/provider.dart';

import '../../../../Data/Model/model_transaction.dart';
import '../../../../Data/repositiories/db_function.dart';
import '../../../../custom WIDGETS/custom_text.dart';
import '../../../../custom WIDGETS/custom_textInput.dart';

class TabTwo extends StatelessWidget {
  const TabTwo({super.key});

  @override
  Widget build(BuildContext context) {
    //============================================================ list generated here ========================================
    return Consumer<TransactionModel>(
      builder: (context, value, child) {
        return Expanded(
          child: ListView.separated(
              physics: const BouncingScrollPhysics(),
              shrinkWrap: true,
              itemBuilder: (context, index) {
                value.incomeList.sort((a, b) => b.date.compareTo(a.date));
                var month =
                    DateFormat.MMM().format(value.incomeList[index].date);

                final amount = TextEditingController();
                final note = TextEditingController();
                amount.text = value.incomeList[index].amount.toString();
                note.text = value.incomeList[index].note;

                return Slidable(
                  //slidable              delete and edit button see when do slide

                  endActionPane: ActionPane(
                      extentRatio: 0.2,
                      motion: const BehindMotion(),
                      children: [
                        IconButton(
                            //================================= delete button ==================================
                            onPressed: () {
                              value.incomeList[index].delete();
                              value.notifyListeners();
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
                                value.incomeList[index].category.categoryName,
                            colour:
                                Color(value.incomeList[index].category.color),
                            size: 22,
                            weight: FontWeight.w600,
                          ),
                          leading: Column(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              CustomText(
                                content:
                                    value.incomeList[index].date.day.toString(),
                                size: 20,
                                weight: FontWeight.w700,
                              ),
                              CustomText(content: month),
                              CustomText(
                                  content: value.incomeList[index].date.year
                                      .toString()),
                            ],
                          ),
                          trailing: CustomText(
                            content:
                                ' +\u20b9 ${value.incomeList[index].amount.toString()}',
                            colour:
                                value.incomeList[index].category.categoryType ==
                                        CategoryType.expense
                                    ? Colors.red
                                    : Colors.green,
                            size: 18,
                            weight: FontWeight.w600,
                          ),
                          subtitle: CustomText(
                            content: value.incomeList[index].note,
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
                                    hint: value.incomeList[index].note == ''
                                        ? 'add note'
                                        : value.incomeList[index].note
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
                                            value.incomeList[index].date = date;
                                            value.incomeList[index].save();
                                            value.notifyListeners();
                                          }
                                        },
                                        child: Row(
                                          children: [
                                            const Icon(
                                                Icons.calendar_month_outlined),
                                            CustomText(
                                                content:
                                                    "${value.incomeList[index].date.day}-${value.incomeList[index].date.month}-${value.incomeList[index].date.year}")
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
                                    value.incomeList[index].amount =
                                        double.parse(amount.text);
                                    value.incomeList[index].note = note.text;
                                    value.incomeList[index].save();
                                    value.notifyListeners();
                                    //value.incomeList.notifyListeners();
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
              itemCount: value.incomeList.length),
        );
      },
    );
  }
}
