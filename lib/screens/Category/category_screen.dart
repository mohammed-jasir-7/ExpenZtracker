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
    Size size = MediaQuery.of(context).size;

    return ValueListenableBuilder(
      valueListenable: map,
      builder: (context, value, child) => ListView.separated(
          itemBuilder: (context, index) {
            var b = value.keys.elementAt(index);
            var gh = map.value.values.elementAt(index);
            double total = 0;
            gh.forEach((element) {
              total += element.amount;
            });
            return Padding(
              padding: const EdgeInsets.symmetric(horizontal: 5),
              child: GestureDetector(
                onTap: () {},
                child: Container(
                  decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(9),
                      color: Color.fromARGB(255, 169, 215, 171)),
                  child: ExpansionTile(
                      trailing: CustomText(
                        content: total.toString(),
                        size: 20,
                        colour: Colors.red,
                      ),
                      title: CustomText(
                        content: b,
                        size: 20,
                        colour: Colors.red,
                      ),
                      children: [
                        Container(
                          decoration: BoxDecoration(
                              borderRadius: BorderRadius.circular(9),
                              color: Color.fromARGB(255, 232, 243, 232)),
                          child: ConstrainedBox(
                            constraints: BoxConstraints(minHeight: 20),
                            child: Column(
                              children: [
                                Column(
                                  children: [
                                    for (var k in gh)
                                      Row(
                                        mainAxisAlignment:
                                            MainAxisAlignment.spaceEvenly,
                                        children: [
                                          CustomText(
                                            content:
                                                '${k.date.day}-${k.date.month}-${k.date.year}',
                                            align: TextAlign.end,
                                          ),
                                          CustomText(
                                            content: k.amount.toString(),
                                            align: TextAlign.end,
                                          ),
                                        ],
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
          separatorBuilder: (context, index) => SizedBox(
                height: 20,
              ),
          itemCount: map.value.length),
    );
  }
}
