import 'package:drop_shadow/drop_shadow.dart';
import 'package:expenztracker/Database/model/model_transaction.dart';
import 'package:expenztracker/custom%20WIDGETS/custom_route.dart';
import 'package:expenztracker/custom%20WIDGETS/custom_text.dart';
import 'package:expenztracker/screens/calculator/calculator.dart';
import 'package:flutter/material.dart';

class CategoryContent extends StatelessWidget {
  const CategoryContent(
      {super.key,
      required this.color,
      required this.percentgeSpec,
      required this.category});

  //================= variables ==================
  final int color;
  final String percentgeSpec;
  final Category category;
  //================================================

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 8),
      child: GestureDetector(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            Container(
              width: 65,
              height: 60,
              decoration: BoxDecoration(
                  border: Border.all(color: Color(color), width: 2),
                  borderRadius: BorderRadius.circular(50)),
              child: InkWell(
                  borderRadius: BorderRadius.circular(50),
                  onTap: () {
                    Navigator.of(context).push(CustomPageRoute(
                        child: const Calculator(
                            appTitle: "new expense",
                            categoryType: CategoryType.expense)));
                  },
                  radius: 85,
                  splashColor: const Color.fromARGB(255, 230, 138, 104),
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      category.imagePath != null
                          ? Image.asset(
                              category.imagePath!,
                              width: 30,
                              color: Color(category.color),
                            )
                          : const SizedBox(),
                      CustomText(
                        content: ' $percentgeSpec%',
                      )
                    ],
                  )),
            ),
            CustomText(
              content: category.categoryName,
              size: 12,
              overflow: TextOverflow.ellipsis,
              fontname: "poppins",
            )
          ],
        ),
      ),
    );
  }
}
