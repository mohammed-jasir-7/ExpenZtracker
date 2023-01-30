import 'package:expenztracker/Data/Model/model_transaction.dart';
import 'package:flutter/cupertino.dart';
import 'package:hive/hive.dart';

class TransactionModel extends ChangeNotifier {
  final List<Transaction> allList = [];
  final List<Transaction> incomeList = [];
  final List<Transaction> expenseList = [];
  double totalAmountIncome = 0;
  double totalAmountExpense = 0;

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
      notifyListeners();
      if (element.categoryType == CategoryType.income) {
        //add values to income List

        incomeList.add(
            element); //=================================output to IncomeList
        //add total amount of income to valueNotifier totalAmountIncome=================output
        totalAmountIncome += element.amount;
        notifyListeners();
        notifyListeners();
      } else {
        //add Expense List
        expenseList.add(element);
        notifyListeners();

        //add total amount of expense
        totalAmountExpense += element.amount;
        notifyListeners();
      }
    }

    return box;
  }
}
