import 'package:expenztracker/Database/model/model_transaction.dart';
import 'package:expenztracker/custom%20WIDGETS/custom_text.dart';
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
      padding: const EdgeInsets.all(8.0),
      child: GestureDetector(
        child: Container(
          width: 65,
          height: 50,
          decoration: BoxDecoration(
              border: Border.all(color: Color(color), width: 2),
              borderRadius: BorderRadius.circular(50)),
          child: InkWell(
              borderRadius: BorderRadius.circular(50),
              onTap: () {},
              radius: 85,
              splashColor: Color.fromARGB(255, 230, 138, 104),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  category.imagePath != null
                      ? Image.asset(category.imagePath!)
                      : const SizedBox(),
                  CustomText(content: ' $percentgeSpec%')
                ],
              )),
        ),
      ),
    );
  }
}
