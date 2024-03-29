import 'dart:developer';

import 'package:expenztracker/Category/widget/category_add_popup.dart';
import 'package:expenztracker/Database/DB%20function/db_function.dart';
import 'package:expenztracker/Database/model/model_transaction.dart';
import 'package:expenztracker/custom%20WIDGETS/custom_route.dart';
import 'package:expenztracker/screens/home/home_screen.dart';
import 'package:flutter/material.dart';
import 'package:flutter/scheduler.dart';
import 'package:hive_flutter/hive_flutter.dart';

import '../custom WIDGETS/custom_text.dart';
//================================================ category selection screen ======================================

class CategoryScreen extends StatefulWidget {
  const CategoryScreen(
      {super.key,
      required this.appTitle,
      required this.amount,
      required this.categoryType,
      required this.date,
      this.note});
  //variables
  // get from calculator screeen
  final String appTitle;
  final double amount;
  final String? note;
  final CategoryType categoryType;
  final DateTime date;

  @override
  State<CategoryScreen> createState() => _CategoryScreenState();
}

class _CategoryScreenState extends State<CategoryScreen> {
  @override
  Widget build(BuildContext context) {
    // this methode check constructor argument income / expense and filter depends arguament value
    //
    List<Category> category = defaultCategory
        .where((element) => element.categoryType == widget.categoryType)
        .cast<Category>()
        .toList();

    return Scaffold(
      appBar: AppBar(
        centerTitle: true,
        title: CustomText(content: widget.appTitle),
        flexibleSpace: Container(
          decoration: const BoxDecoration(
              gradient: LinearGradient(colors: [
            Color(0xFF64ED08),
            Color.fromARGB(255, 0, 210, 108)
          ])),
        ),
      ),
      body: SizedBox(
        width: double.infinity,
        child: SingleChildScrollView(
          child: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              Padding(
                padding: const EdgeInsets.all(
                    8.0), // ====== default category ============================
                child: CustomText(
                  content: "Default Categories",
                  fontname: "Poppins",
                  size: 20,
                ),
              ),
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 30),
                child: GridView.builder(
                  //build button accrodin to  list
                  shrinkWrap: true,
                  physics: const NeverScrollableScrollPhysics(),
                  gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                      crossAxisCount: 3,
                      childAspectRatio: 1,
                      crossAxisSpacing: 10,
                      mainAxisSpacing: 20),
                  itemCount: category.length,
                  itemBuilder: (context, index2) {
                    log(defaultCategory[index2].color.toString());
//=====================================   category button=========================
//pass call baack function
//pass variables
//1.category model
//2.icon
////3.color
                    //4.callback

                    return GestureDetector(
                      onDoubleTap: () {},
                      child: CategoryButton(
                        categoryType: widget.categoryType,
                        imagePath: category[index2].imagePath,
                        category: category[index2],
                        icon: category[index2].icon,
                        color: category[index2].color,
                        //function receive category model from category button
                        onclickk: onClickk,
                        itemName: category[index2].categoryName,
                      ),
                    );
                  },
                ),
              ),
              //===================================================== custom category =========================================
              Padding(
                padding: const EdgeInsets.all(8.0),
                child: CustomText(
                  content: "Custom Categories",
                  size: 20,
                ),
              ),
              //========= build when add category ======================

              ValueListenableBuilder<Box<Category>>(
                valueListenable: Boxes.getCategory().listenable(),
                // create list of category
                //filter
                //// this methode check constructor argument income / expense and filter depends arguament value
                builder: (context, box, _) {
                  final customcategory = box.values
                      .where((element) =>
                          element.categoryType == widget.categoryType &&
                          element.isDelete == false)
                      .cast<Category>()
                      .toList();

                  return Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 30),
                    child: customcategory.isNotEmpty
                        ? GridView.builder(
                            shrinkWrap: true,
                            physics: const NeverScrollableScrollPhysics(),
                            gridDelegate:
                                const SliverGridDelegateWithFixedCrossAxisCount(
                                    crossAxisCount: 3,
                                    childAspectRatio: 1,
                                    crossAxisSpacing: 10,
                                    mainAxisSpacing: 20),
                            itemCount: customcategory.length,
                            itemBuilder: (context, index) {
                              return CategoryButton(
                                categoryType: widget.categoryType,
                                category: customcategory[index],
                                icon: customcategory[index].icon,
                                color: customcategory[index].color,
                                onclickk: onClickk,
                                itemName: customcategory[index].categoryName,
                                doubleClick: ondoubleclikk,
                              );
                            },
                          )
                        : SizedBox(
                            width: double.infinity,
                            height: 200,
                            child: Column(
                              mainAxisAlignment: MainAxisAlignment.center,
                              crossAxisAlignment: CrossAxisAlignment.center,
                              children: [
                                CustomText(
                                  fontname: "Poppins",
                                  colour: Colors.grey,
                                  align: TextAlign.center,
                                  content:
                                      "Tap once on a category to add transaction\nDouble tap on category to delete",
                                  size: 15,
                                ),
                              ],
                            ),
                          ),
                  );
                },
              ),
            ],
          ),
        ),
      ),
    );
  }

  //function to delete category
  ondoubleclikk(Category category) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: CustomText(content: "Delete"),
        content: CustomText(content: "Are you sure to delete?"),
        actions: [
          TextButton(
              onPressed: () {
                Navigator.pop(context);
              },
              child: CustomText(content: "cancel")),
          TextButton(
              onPressed: () {
                final box = Boxes.getCategory();
                category.isDelete = true;
                box.putAt(category.key, category);
                Navigator.pop(context);
              },
              child: CustomText(content: "sure"))
        ],
      ),
    );
  }
  //  call back function
  //this function called in cattegory bbutton's  onclick

  onClickk(Category category) {
    if (category.categoryName == "ADD") {
      popup(context, widget.categoryType);
    } else {
      final obj = Transaction(
          date: widget.date,
          amount: widget.amount,
          category: category,
          note: widget.note ?? '',
          categoryType: widget.categoryType);
      addDataToTransaction(obj);

      SchedulerBinding.instance.addPostFrameCallback((_) {
        // add your code here.
        Navigator.pushAndRemoveUntil(context,
            CustomPageRoute(child: const HomeScreen()), (route) => false);
      });
    }
  }
}
//================================================================== category button ==========================================

class CategoryButton extends StatelessWidget {
  const CategoryButton(
      {super.key,
      this.imagePath,
      required this.onclickk,
      required this.itemName,
      required this.color,
      required this.icon,
      required this.category,
      required this.categoryType,
      this.doubleClick});
  final int color;
  final String itemName;
  final int icon;
  final Function onclickk;
  final Function? doubleClick;
  final Category category;
  final String? imagePath;
  final CategoryType categoryType;

  @override
  Widget build(BuildContext context) {
    log(color.toString());
    return Padding(
      padding: const EdgeInsets.all(8.0),
      child: Material(
        child: InkWell(
          onDoubleTap: () {
            if (doubleClick != null) {
              doubleClick!(category);
            }
          },
          radius: 50,
          splashColor: Colors.green,
          onTap: () {
            onclickk(category);
          },
          child: Container(
            decoration: BoxDecoration(
              border: Border.all(
                color: Color(color.toInt()),
                width: 3,
              ),
              borderRadius: BorderRadius.circular(5),
            ),
            width: 75,
            height: 75,
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Container(
                  child: imagePath == null //if image null
                      ? itemName == "ADD"
                          ? const Icon(Icons.add)
                          : categoryType == CategoryType.expense
                              ? Image.asset(
                                  'assets/icons/expense.png',
                                  width: 40,
                                )
                              : Image.asset(
                                  'assets/icons/income.png',
                                  width: 40,
                                  color: Color.fromARGB(255, 241, 160, 0),
                                )
                      : Image.asset(
                          imagePath!,
                          color: Color(category.color),
                        ),
                ),
                CustomText(content: itemName)
              ],
            ),
          ),
        ),
      ),
    );
  }
}
