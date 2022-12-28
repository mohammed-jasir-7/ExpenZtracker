import 'package:expenztracker/Database/model/model_transaction.dart';
import 'package:expenztracker/notification/notification_api.dart';
import 'package:expenztracker/screens/planner/planner_screen.dart';
import 'package:flutter/material.dart';

import 'package:hive_flutter/hive_flutter.dart';
import 'package:shared_preferences/shared_preferences.dart';

//============================list of all income & expense ===============================================
//add data when call getatransaction()
ValueNotifier<List<Transaction>> incomeList = ValueNotifier([]);
ValueNotifier<List<Transaction>> expenseList = ValueNotifier([]);
//=============================================================================
//===== value add when call getTransaction()  =================================================================
//total amount of income and expense
ValueNotifier<double> totalAmountIncome = ValueNotifier(0);
ValueNotifier<double> totalAmountExpense = ValueNotifier(0);
//=============================================================================
//======================value add when call getCategoryWiseData()===================================
//include category name and total
ValueNotifier<List<Categoryawise>> categoryWiseTotalAmount = ValueNotifier([]);
ValueNotifier<List<Categoryawise>> categoryExpenseWiseTotalAmount =
    ValueNotifier([]);
//=================================================================
//======================value add when call categoryFilter()===================================
//category name & transaction which under name
ValueNotifier<Map<String, List<Transaction>>> map = ValueNotifier({});
//===============================================================
ValueNotifier<List<Categoryawise>> datewiseplanner = ValueNotifier([]);

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

        incomeList.value.add(
            element); //=================================output to IncomeList
        //add total amount of income to valueNotifier totalAmountIncome=================output
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
//========================================== end getTransaction()==============

  //this function return box of category
  static Box<Category> getCategory() => Hive.box<Category>('category');
}

//class end!!!
String? username;
sharedprefnameset() async {
  await Future.delayed(const Duration(seconds: 4));
  final pref = await SharedPreferences.getInstance();
  username = pref.getString("userName");
}

//this method is initilizing database and check adapter is registered or not .
//opend a box also
//this function call whre database need
dataBase() async {
  await sharedprefnameset();
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
  if (!Hive.isAdapterRegistered(PlannerAdapter().typeId)) {
    Hive.registerAdapter(PlannerAdapter());
  }
  await Hive.openBox<Transaction>('transaction');
  await Hive.openBox<Category>('category');
  await Hive.openBox<Planner>('planner');
  await NotificationApi.init(initSheduled: true);
  listenNotification();
  NotificationApi.showNotifiicationDaily(
      title: "Expenz Tracker",
      date: DateTime.now(),
      body: "Hello $username , have you updated today's transactions?");
  Boxes.getTransaction();
  await plannerFiltr();
}

void listenNotification() => NotificationApi.onNotification;

//================================================== CRUD operation =============================================
addDataToTransaction(Transaction object) {
  final box = Boxes.getTransaction();
  box.add(object);
  getCategoryWiseData();

  plannerFiltr();
}

addToCategory(Category object) {
  final box = Boxes.getCategory();
  box.add(object);
  getCategoryWiseData();
}

//planner===================================== crud ===========================
Box<Planner> getPlanner() {
  final box = Hive.box<Planner>('planner');
  return box;
}

addPlanner(Planner object) async {
  final box = getPlanner();
  final k = box.keys;
  box.delete(k);
  box.add(object);
}
//default categories

List<Category> defaultCategory = [
  Category(Icons.abc.codePoint, const Color.fromARGB(255, 6, 210, 19).value,
      categoryType: CategoryType.income,
      categoryName: 'Salary',
      imagePath: "assets/icons/salary.png"),
  Category(Icons.abc.codePoint, Colors.blue.value,
      categoryType: CategoryType.income,
      categoryName: 'Deposit',
      imagePath: "assets/icons/deposit.png"),
  Category(Icons.abc.codePoint, const Color.fromARGB(252, 4, 218, 237).value,
      categoryType: CategoryType.income,
      categoryName: 'Savings',
      imagePath: "assets/icons/savings.png"),
  Category(Icons.add.codePoint, const Color.fromARGB(251, 0, 172, 95).value,
      categoryType: CategoryType.income, categoryName: 'ADD'),

  // default expense category==========================================================================================
  Category(Icons.add.codePoint, Color.fromARGB(255, 203, 77, 42).value,
      categoryType: CategoryType.expense,
      categoryName: 'Transport',
      imagePath: "assets/icons/Transport.png"),
  Category(Icons.add.codePoint, const Color(0XFFB40097).value,
      categoryType: CategoryType.expense,
      categoryName: 'Eating Out',
      imagePath: "assets/icons/expEatingout.png"),
  Category(Icons.add.codePoint, const Color.fromARGB(255, 192, 202, 0).value,
      categoryType: CategoryType.expense,
      categoryName: 'Health',
      imagePath: "assets/icons/expHealth.png"),
  Category(Icons.add.codePoint, const Color.fromARGB(255, 0, 98, 202).value,
      categoryType: CategoryType.expense,
      categoryName: 'Recharge',
      imagePath: "assets/icons/communicaton.png"),
  Category(Icons.add.codePoint, const Color.fromARGB(255, 0, 202, 175).value,
      categoryType: CategoryType.expense,
      categoryName: 'Taxi',
      imagePath: "assets/icons/taxi.png"),
  Category(Icons.add.codePoint, const Color.fromARGB(255, 77, 19, 202).value,
      categoryType: CategoryType.expense,
      categoryName: 'Food',
      imagePath: "assets/icons/food.png"),
  Category(Icons.add.codePoint, const Color.fromARGB(255, 196, 27, 165).value,
      categoryType: CategoryType.expense,
      categoryName: 'Electricity',
      imagePath: 'assets/icons/electricity.png'),
  Category(Icons.add.codePoint, const Color.fromARGB(255, 196, 27, 112).value,
      categoryType: CategoryType.expense,
      categoryName: 'Loan',
      imagePath: 'assets/icons/loan.png'),
  Category(Icons.add.codePoint, const Color.fromARGB(255, 155, 73, 18).value,
      categoryType: CategoryType.expense,
      categoryName: 'Cloths',
      imagePath: 'assets/icons/fashion.png'),
  Category(Icons.add.codePoint, const Color.fromARGB(255, 51, 43, 142).value,
      categoryType: CategoryType.expense,
      categoryName: 'Insurance',
      imagePath: 'assets/icons/insurance.png'),
  Category(Icons.add.codePoint, const Color.fromARGB(248, 108, 2, 37).value,
      categoryType: CategoryType.expense, categoryName: 'ADD'),
];

//========================================= filter category wise =================================
//it work with getCategorywiseData()
//if pass categoryname get total amount
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

//====================================================================
//it make two list
//1.categoryWiseTotalAmount
//2.categoryExpenseWiseTotalAmount
ValueNotifier<List<Category>> expenseCategoryList = ValueNotifier([]);
getCategoryWiseData() {
  categoryExpenseWiseTotalAmount.value.clear();
  categoryWiseTotalAmount.value.clear();
  expenseCategoryList.value.clear();
  List<Category> category = Boxes.getCategory().values.toList();
  category.addAll(defaultCategory); //add default category to
  print(category.length);
  expenseCategoryList.value = category
      .where((element) =>
          element.categoryType == CategoryType.expense &&
          element.categoryName != 'ADD')
      .toList();

  List<Transaction> transaction = Boxes.getTransaction().values.toList();
  // itrate category
  //pass category name to getcategorytotal(). return total of that category
  //
  category.forEach((element) {
    double total = getCategoryTotal(
        element.categoryName); // passs category name and return total

//create obj of Categoryawise class and add that object valueNotifier categoryWiseTotalAmount List
    final val = Categoryawise(category: element, total: total);
    categoryWiseTotalAmount.value.add(
        val); //=============================output valueNotifier categoryWiseTotalAmount
    categoryWiseTotalAmount.notifyListeners();
    //filter and create LIst Expense
    if (val.category.categoryType == CategoryType.expense) {
      categoryExpenseWiseTotalAmount.value.add(
          val); //===========output valuenoti categoryExpenseWiseTotalAmount
      categoryExpenseWiseTotalAmount.notifyListeners();
    }
  });
}

//==========================================================================
//model
class Categoryawise {
  final Category category;
  final double total;

  Categoryawise({required this.category, required this.total});
}
//=====================

//function for category
//category name and under list of transaction
categoryFilter() async {
  map.value.clear();

  final box = Hive.box<Transaction>('transaction').values.toList();
//create map
//category name and transaction list which under that category
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

//exp
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
