import 'package:expenztracker/Data/Model/model_transaction.dart';
import 'package:flutter/cupertino.dart';
import 'package:hive/hive.dart';
import 'package:hive_flutter/adapters.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../Data/repositiories/db_function.dart';
import '../notification/notification_api.dart';
import '../presentation/screens/planner/planner_screen.dart';

class TransactionModel extends ChangeNotifier {
  final List<Transaction> allList = [];
  List<Transaction> incomeList = [];
  final List<Transaction> expenseList = [];
  Map<String, List<Transaction>> map = {}; //categoryfilter
  double totalAmountIncome = 0;
  double totalAmountExpense = 0;
  set setIncomeList(List<Transaction> newList) {
    incomeList = newList;
    notifyListeners();
  }

  Box<Transaction> getTransaction() {
    final box = Hive.box<Transaction>('transaction');
    final listOfTransaction = box.values.toList();
    allList.clear();
    incomeList.clear();
    expenseList.clear();
    totalAmountIncome = 0;
    totalAmountExpense = 0;
    // itrate and divide transaction model into two list
    //and calculate total amount
    for (var element in listOfTransaction) {
      allList.add(element);

      if (element.categoryType == CategoryType.income) {
        //add values to income List

        incomeList.add(
            element); //=================================output to IncomeList
        //add total amount of income to valueNotifier totalAmountIncome=================output
        totalAmountIncome += element.amount;
      } else {
        //add Expense List
        expenseList.add(element);

        //add total amount of expense
        totalAmountExpense += element.amount;
      }
    }
    notifyListeners();

    return box;
  }

  String? username;
  sharedprefnameset() async {
    await Future.delayed(const Duration(seconds: 4));
    final pref = await SharedPreferences.getInstance();
    username = pref.getString("userName");
  }

  //database init
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
    getTransaction();
    await plannerFiltr();
    getCategoryWiseData();
  }

// add transaction
  addDataToTransaction(Transaction object) {
    final box = Hive.box<Transaction>('transaction');

    box.add(object);
    getTransaction();

    getCategoryWiseData();

    plannerFiltr();
    notifyListeners();
  }

  // category filter (category and under transaction)
  categoryFilter() async {
    map.clear();

    final box = Hive.box<Transaction>('transaction').values.toList();
//create map
//category name and transaction list which under that category
    for (var categoryname in categoryWiseTotalAmount.value) {
      map[categoryname.category.categoryName] = box
          .where((element) =>
              categoryname.category.categoryName ==
              element.category.categoryName)
          .toList();
    }
  }

  // search filter  (app baar)
//   List<Transaction> searchFilter(String query) {
//   print("hhhS${filterSelectedType.value}");
//   List<Transaction> transaction = Boxes.getTransaction().values.toList();
//   List<Transaction> filterd = transaction.where(
//     (element) {
//       if (filterSelectedType.value == null && selectedDateRange.value == null) {
//         return element.category.categoryName
//                 .toLowerCase()
//                 .contains(query.toLowerCase()) ||
//             element.note.toLowerCase().contains(query.toLowerCase());
//       } else if (filterSelectedType.value != null) {
//         if (selectedDateRange.value != null) {
//           if (element.date.isAfter(selectedDateRange.value!.start) &&
//               element.date.isBefore(selectedDateRange.value!.end) &&
//               filterSelectedType.value == element.categoryType) {
//             return element.category.categoryName
//                     .toLowerCase()
//                     .contains(query.toLowerCase()) ||
//                 element.note.toLowerCase().contains(query.toLowerCase());
//           }
//         } else {
//           return element.categoryType == filterSelectedType.value;
//         }
//       } else if (element.date.isAfter(selectedDateRange.value!.start) &&
//           element.date.isBefore(selectedDateRange.value!.end)) {
//         log("ccccccc");
//         return element.category.categoryName
//                 .toLowerCase()
//                 .contains(query.toLowerCase()) ||
//             element.note.toLowerCase().contains(query.toLowerCase());
//       }
//       return false;
//     },
//   ).toList();

//   return filterd;
// }
}
