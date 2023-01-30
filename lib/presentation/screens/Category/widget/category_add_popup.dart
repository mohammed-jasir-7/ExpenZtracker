import 'package:expenztracker/custom%20WIDGETS/custom_text.dart';
import 'package:expenztracker/custom%20WIDGETS/custom_textInput.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

import '../../../../Data/Model/model_transaction.dart';
import '../../../../Data/repositiories/db_function.dart';

popup(BuildContext context, CategoryType type) {
  showDialog(
    context: context,
    builder: (context) {
      return PopScreen(
        type: type,
      );
    },
  );
}

//======================================================
class PopScreen extends StatefulWidget {
  const PopScreen({super.key, required this.type});
  final CategoryType type;

  @override
  State<PopScreen> createState() => _PopScreenState();
}

class _PopScreenState extends State<PopScreen> {
  final categoryAdd = TextEditingController();
  bool categoryValidator = false;
  bool duplicationValidator = false;
  @override
  Widget build(BuildContext context) {
    return Dialog(
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(30)),
      child: Padding(
        padding: const EdgeInsets.all(8.0),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            CustomText(
              content: 'Add Category',
              fontname: "Poppins",
              size: 18,
            ),
            CustomTextfiled(
                controller: categoryAdd,
                hint: 'category name',
                limit: [LengthLimitingTextInputFormatter(7)]),
            const SizedBox(
              height: 10,
            ),
            Visibility(
              visible: categoryValidator,
              child: CustomText(
                content: "please enter category",
                fontname: "Poppins",
                colour: Colors.red,
              ),
            ),
            Visibility(
              visible: duplicationValidator,
              child: CustomText(
                content: "category name already exists",
                fontname: "Poppins",
                colour: Colors.red,
              ),
            ),
            //updation===========
            // Row(
            //   mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            //   children: [
            //     Container(
            //       width: 50,
            //       height: 50,
            //       color: Colors.amber,
            //     ),
            //     Container(
            //       width: 50,
            //       height: 50,
            //       color: Colors.green,
            //     ),
            //     Container(
            //       width: 50,
            //       height: 50,
            //       color: Colors.blue,
            //     ),
            //   ],
            // ),
            ElevatedButton(
                onPressed: () {
                  if (categoryAdd.text.isEmpty) {
                    setState(() {
                      categoryValidator = true;
                    });
                  } else {
                    final category = Boxes.getCategory();
                    bool duplicationCheck = false;
                    //duplication check=============================
                    for (var element in category.values) {
                      if (element.categoryName == categoryAdd.text) {
                        setState(() {
                          duplicationCheck = true;
                        });
                      }
                    }
                    if (duplicationCheck) {
                      setState(() {
                        duplicationValidator = true;
                      });
                    } else {
                      final obj = Category(
                          imagePath: widget.type == CategoryType.expense
                              ? 'assets/icons/expense.png'
                              : 'assets/icons/income.png',
                          Icons.abc.codePoint,
                          Colors.amber.value,
                          categoryType: widget.type,
                          categoryName: categoryAdd.text);
                      addToCategory(obj);
                      Navigator.pop(context);
                    }
                  }
                },
                child: CustomText(
                  content: 'ADD',
                  fontname: "Poppins",
                ))
          ],
        ),
      ),
    );
  }
}
