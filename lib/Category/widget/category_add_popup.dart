import 'package:expenztracker/Database/DB%20function/db_function.dart';
import 'package:expenztracker/Database/model/model_transaction.dart';
import 'package:expenztracker/custom%20WIDGETS/custom_text.dart';
import 'package:expenztracker/custom%20WIDGETS/custom_textInput.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

popup(BuildContext context, CategoryType type) {
  final categoryAdd = TextEditingController();
  showDialog(
    context: context,
    builder: (context) {
      return Dialog(
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(30)),
        child: Padding(
          padding: const EdgeInsets.all(8.0),
          child: Container(
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                CustomText(
                  content: 'Add Category',
                  size: 18,
                ),
                Container(
                  child: CustomTextfiled(
                      controller: categoryAdd,
                      hint: 'category name',
                      limit: [LengthLimitingTextInputFormatter(17)]),
                ),
                SizedBox(
                  height: 10,
                ),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                  children: [
                    Container(
                      width: 50,
                      height: 50,
                      color: Colors.amber,
                    ),
                    Container(
                      width: 50,
                      height: 50,
                      color: Colors.green,
                    ),
                    Container(
                      width: 50,
                      height: 50,
                      color: Colors.blue,
                    ),
                  ],
                ),
                ElevatedButton(
                    onPressed: () {
                      final obj = Category(
                          Icons.abc.codePoint, Colors.amber.value,
                          categoryType: type, categoryName: categoryAdd.text);
                      addToCategory(obj);
                      print("hhhhhhhhhhhhhhhhhhh");
                    },
                    child: CustomText(
                      content: 'Submit',
                    ))
              ],
            ),
          ),
        ),
      );
    },
  );
}
