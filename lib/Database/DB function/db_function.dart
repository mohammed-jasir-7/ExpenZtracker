import 'package:expenztracker/Database/model/model_transaction.dart';
import 'package:flutter/material.dart';

import 'package:hive_flutter/hive_flutter.dart';

// four lists

ValueNotifier<List<Transaction>> incomeList = ValueNotifier([]);
ValueNotifier<List<Transaction>> expenseList = ValueNotifier([]);
ValueNotifier<List<Categoryawise>> totalCategorywiseList = ValueNotifier([]);
ValueNotifier<double> totalAmountIncome = ValueNotifier(0);
ValueNotifier<double> totalAmountExpense = ValueNotifier(0);

//this class used to get database box
//use these function getTransaction return transaction box
class Boxes {
  //this function return hive box of transaction
  static Box<Transaction> getTransaction() {
    final box = Hive.box<Transaction>('transaction');
    final listOfTransaction = box.values.toList();
    incomeList.value.clear();
    expenseList.value.clear();
    totalAmountIncome.value = 0;
    totalAmountExpense.value = 0;
    // itrate and divide transaction model into two list
    //and calculate total amount
    for (var element in listOfTransaction) {
      if (element.categoryType == CategoryType.income) {
        //add values to income List
        incomeList.value.add(element);
        //add total amount of income
        totalAmountIncome.value += element.amount;
        totalAmountIncome.notifyListeners();
        incomeList.notifyListeners();
      } else {
        //add Expense List
        expenseList.value.add(element);
        expenseList.notifyListeners();
        //add total amount of expense
        totalAmountExpense.value += element.amount;
        totalAmountExpense.notifyListeners();
      }
    }

    return box;
  }

  //this function return box of category
  static Box<Category> getCategory() => Hive.box<Category>('category');
}

//this method is initilizing database and check adapter is registered or not .
//opend a box also
//this function call whre database need
dataBase() async {
  await Hive.initFlutter();
  if (!Hive.isAdapterRegistered(TransactionAdapter().typeId)) {
    Hive.registerAdapter(TransactionAdapter());
  }
  if (!Hive.isAdapterRegistered(CategoryAdapter().typeId)) {
    Hive.registerAdapter(CategoryAdapter());
  }
  if (!Hive.isAdapterRegistered(CategoryTypeAdapter().typeId)) {
    Hive.registerAdapter(CategoryTypeAdapter());
  }
  await Hive.openBox<Transaction>('transaction');
  await Hive.openBox<Category>('category');
}

//================================================== CRUD operation =============================================
addDataToTransaction(Transaction object) {
  final box = Boxes.getTransaction();
  box.add(object);
  getCategoryWiseData();
}

addToCategory(Category object) {
  final box = Boxes.getCategory();
  box.add(object);
}

//default categories

List<Category> defaultCategory = [
  Category(Icons.abc.codePoint, const Color.fromARGB(255, 6, 210, 19).value,
      categoryType: CategoryType.income, categoryName: 'Salary'),
  Category(Icons.abc.codePoint, Colors.blue.value,
      categoryType: CategoryType.income, categoryName: 'Deposit'),
  Category(Icons.abc.codePoint, const Color.fromARGB(252, 4, 218, 237).value,
      categoryType: CategoryType.income, categoryName: 'Savings'),
  Category(Icons.add.codePoint, const Color.fromARGB(252, 4, 218, 237).value,
      categoryType: CategoryType.income, categoryName: 'ADD'),

  // default expense category==========================================================================================
  Category(Icons.add.codePoint, const Color(0XFFEE3300).value,
      categoryType: CategoryType.expense,
      categoryName: 'Transport',
      imagePath: "assets/icons/Transport.png"),
  Category(Icons.add.codePoint, Color(0XFFB40097).value,
      categoryType: CategoryType.expense,
      categoryName: 'Eating Out',
      imagePath: "assets/icons/expEatingout.png"),
  Category(Icons.add.codePoint, Color(0XFFFFE600).value,
      categoryType: CategoryType.expense,
      categoryName: 'Health',
      imagePath: "assets/icons/expHealth.png"),
  Category(Icons.add.codePoint, Color.fromARGB(251, 30, 115, 190).value,
      categoryType: CategoryType.expense, categoryName: 'ADD'),
];

analysisData(
    {Function(double totalIncome, double totalExpense)? income,
    Function(List<Transaction> transaction)? tra}) {
  final box = Boxes.getTransaction(); //get box of transation
  double incomeValue = 0;
  double expenseValue = 0;
  List<Transaction> expenseTransaction = [];
  List<Category> category = Boxes.getCategory().values.toList();
  category.addAll(defaultCategory);
  List<String> expeseCategory = [];
  category.forEach((element) {
    if (element.categoryType == CategoryType.expense) {
      expeseCategory.add(element.categoryName);
    }
  });

  List<Map<String, double>> exp = [{}];

  expeseCategory.forEach((element) {});
  box.values.toList().forEach((element) {
    if (element.categoryType == CategoryType.income) {
      incomeValue += element.amount;
    } else {
      expenseValue += element.amount;
      expenseTransaction.add(element);
    }
  });
  income!(incomeValue, expenseValue); //call back

  for (int i = 0; i < expenseTransaction.length; i++) {
    double total = 0;
    String name = '';
    // for (int j = i; j < expenseTransaction.length; j++) {
    //   if (expenseTransaction[i].category.categoryName ==
    //       expenseTransaction[j].category.categoryName) {
    //     total += expenseTransaction[j].amount;
    //     name = expenseTransaction[i].category.categoryName;
    //     expenseTransaction.remove(expenseTransaction[j]);
    //     //j--;
    //   }
    // }

    //print({total, name.toString()});
    // var jj = expenseTransaction.where((element) {
    //   return element.category.categoryName ==
    //       expenseTransaction[i].category.categoryName;
    // });
    // print(jj.every((element) {
    //   total += element.amount;
    //   name = element.category.categoryName;
    //   return true;
    // }));
    // print(total);
    // print(name);
  }
}

//========================================= filter category wise =================================
double getCategoryTotal(String categorynAme) {
  double totalOfCategory = 0;
  List<Transaction> transaction = Boxes.getTransaction().values.toList();

  var jj = transaction.where((element) {
    return element.category.categoryName == categorynAme;
  });
  jj.every((element) {
    totalOfCategory += element.amount;

    return true;
  });
  return totalOfCategory;
}

ValueNotifier<List<Categoryawise>> categoryWiseTotalAmount = ValueNotifier([]);
ValueNotifier<List<Categoryawise>> categoryExpenseWiseTotalAmount =
    ValueNotifier([]);

getCategoryWiseData() {
  categoryExpenseWiseTotalAmount.value.clear();
  categoryWiseTotalAmount.value.clear();
  List<Category> category = Boxes.getCategory().values.toList();
  category.addAll(defaultCategory);
  List<Transaction> transaction = Boxes.getTransaction().values.toList();
  category.forEach((element) {
    double total = getCategoryTotal(element.categoryName);
    print(total);

    final val = Categoryawise(category: element, total: total);
    categoryWiseTotalAmount.value.add(val);
    categoryWiseTotalAmount.notifyListeners();
    if (val.category.categoryType == CategoryType.expense) {
      categoryExpenseWiseTotalAmount.value.add(val);
      categoryExpenseWiseTotalAmount.notifyListeners();
    }
  });
}

class Categoryawise {
  final Category category;
  final double total;

  Categoryawise({required this.category, required this.total});
}

ValueNotifier<List<List<Transaction>>> categorywiseList = ValueNotifier([]);
ValueNotifier<Map<String, List<Transaction>>> map = ValueNotifier({});
//function for category
categoryFilter() async {
  categorywiseList.value.clear();
  map.value.clear();

  final box = Hive.box<Transaction>('transaction').values.toList();
  print(categoryWiseTotalAmount.value.length);

  for (var categoryname in categoryWiseTotalAmount.value) {
    map.value[categoryname.category.categoryName] = box
        .where((element) =>
            categoryname.category.categoryName == element.category.categoryName)
        .toList();
    // for (var element in box) {
    //   if (box.contains(categoryname.category.categoryName)) {
    //     cat.add(element);
    //     print("hereeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeee");
    //   } else {
    //     print(
    //         "llllllllllllllllllllllllllllllllllllllllllllllllllllllllllllllll");

    //   }
    // }

    // map.value[categoryname.category.categoryName] = cat;
    // print(cat.length);
    // categorywiseList.value.add(cat);
    // categorywiseList.notifyListeners();
  }
}
