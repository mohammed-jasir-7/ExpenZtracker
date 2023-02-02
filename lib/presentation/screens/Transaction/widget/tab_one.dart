import 'package:flutter/material.dart';

import 'package:flutter_slidable/flutter_slidable.dart';

import 'package:intl/intl.dart';
import 'package:provider/provider.dart';

import '../../../../Data/Model/model_transaction.dart';

import '../../../../business_logic/transaction_provider.dart';
import '../../../../custom WIDGETS/custom_text.dart';
import '../../../../custom WIDGETS/custom_textInput.dart';

class TabOne extends StatelessWidget {
  const TabOne({super.key});

  @override
  Widget build(BuildContext context) {
    return Consumer<TransactionModel>(
      builder: (context, value, child) {
        return Expanded(
          child: ListView.separated(
              physics: const BouncingScrollPhysics(),
              shrinkWrap: true,
              itemBuilder: (context, index) {
                value.allList.sort((a, b) => b.date.compareTo(a.date));
                var month = DateFormat.MMM().format(value.allList[index].date);

                final amount = TextEditingController();
                final note = TextEditingController();
                amount.text = value.allList[index].amount.toString();
                note.text = value.allList[index].note;

                return Slidable(
                  //slidabledelete and edit button see when do slide

                  endActionPane: ActionPane(
                      extentRatio: 0.2,
                      motion: const BehindMotion(),
                      children: [
                        IconButton(
                            //================================= delete button ==================================
                            onPressed: () {
                              value.allList[index].delete();
                              value.notifyListeners();
                              Provider.of<TransactionModel>(context,
                                      listen: false)
                                  .categoryFilter();
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
                            content: value.allList[index].category.categoryName,
                            colour: Color(value.allList[index].category.color),
                            size: 22,
                            weight: FontWeight.w600,
                          ),
                          leading: Column(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              CustomText(
                                content:
                                    value.allList[index].date.day.toString(),
                                size: 20,
                                weight: FontWeight.w700,
                              ),
                              CustomText(content: month),
                              CustomText(
                                  content: value.allList[index].date.year
                                      .toString()),
                            ],
                          ),
                          trailing: CustomText(
                            content:
                                ' +\u20b9 ${value.allList[index].amount.toString()}',
                            colour:
                                value.allList[index].category.categoryType ==
                                        CategoryType.expense
                                    ? Colors.red
                                    : Colors.green,
                            size: 18,
                            weight: FontWeight.w600,
                          ),
                          subtitle: CustomText(
                            content: value.allList[index].note,
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
                                    hint: value.allList[index].note == ''
                                        ? 'add note'
                                        : value.allList[index].note.toString(),
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
                                            value.allList[index].date = date;
                                            value.allList[index].save();
                                            value.notifyListeners();
                                          }
                                        },
                                        child: Row(
                                          children: [
                                            const Icon(
                                                Icons.calendar_month_outlined),
                                            CustomText(
                                                content:
                                                    "${value.allList[index].date.day}-${value.allList[index].date.month}-${value.allList[index].date.year}")
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
                                    value.allList[index].amount =
                                        double.parse(amount.text);
                                    value.allList[index].note = note.text;
                                    value.allList[index].save();
                                    value.notifyListeners();
                                    //value.allList.notifyListeners();
                                    Provider.of<TransactionModel>(context,
                                            listen: false)
                                        .categoryFilter();
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
              itemCount: value.allList.length),
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
