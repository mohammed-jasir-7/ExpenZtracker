import 'package:expenztracker/Database/DB%20function/db_function.dart';
import 'package:expenztracker/custom%20WIDGETS/custom_text.dart';
import 'package:flutter/material.dart';

class CategoryListScreen extends StatefulWidget {
  const CategoryListScreen({super.key});

  @override
  State<CategoryListScreen> createState() => _CategoryListScreenState();
}

class _CategoryListScreenState extends State<CategoryListScreen> {
  @override
  Widget build(BuildContext context) {
    return ValueListenableBuilder(
      valueListenable: map,
      builder: (context, value, child) => ListView.separated(
          itemBuilder: (context, index) {
            var categoryname = value.keys.elementAt(index);
            var transactionUnderCategory = map.value.values.elementAt(index);
            double total = 0;
            for (var element in transactionUnderCategory) {
              total += element.amount;
            }
            return Padding(
              padding: const EdgeInsets.symmetric(horizontal: 5),
              child: GestureDetector(
                onTap: () {},
                child: Container(
                  decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(9),
                      color: const Color.fromARGB(255, 222, 247, 210)),
                  child: ExpansionTile(
                      trailing: CustomText(
                        content: "\u20b9 $total",
                        size: 17,
                        colour: Colors.black87,
                      ),
                      title: CustomText(
                        content: categoryname,
                        size: 16,
                        colour: Colors.black87,
                        fontname: "Poppins",
                      ),
                      children: [
                        Container(
                          decoration: BoxDecoration(
                              borderRadius: BorderRadius.circular(9),
                              color: const Color.fromARGB(255, 219, 241, 219)),
                          child: ConstrainedBox(
                            constraints: const BoxConstraints(minHeight: 20),
                            child: Column(
                              children: [
                                Column(
                                  children: [
                                    for (var k in transactionUnderCategory)
                                      Padding(
                                        padding: const EdgeInsets.all(8.0),
                                        child: Container(
                                          color: const Color.fromARGB(
                                              255, 232, 232, 232),
                                          child: Row(
                                            mainAxisAlignment:
                                                MainAxisAlignment.spaceEvenly,
                                            children: [
                                              CustomText(
                                                content:
                                                    '${k.date.day}-${k.date.month}-${k.date.year}',
                                                align: TextAlign.end,
                                              ),
                                              CustomText(
                                                content: "\u20b9 ${k.amount}",
                                                align: TextAlign.end,
                                              ),
                                            ],
                                          ),
                                        ),
                                      ),
                                  ],
                                ),
                              ],
                            ),
                          ),
                        ),
                      ]),
                ),
              ),
            );
          },
          separatorBuilder: (context, index) => const SizedBox(
                height: 20,
              ),
          itemCount: map.value.length),
    );
  }
}
