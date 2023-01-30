import 'package:expenztracker/Data/Model/model_transaction.dart';
import 'package:flutter/cupertino.dart';
import 'package:hive/hive.dart';

class TransactionModel extends ChangeNotifier {
  final List<Transaction> allList = [];
  final 


     Box<Transaction> getTransaction() {
    final box = Hive.box<Transaction>('transaction');
    final listOfTransaction = box.values.toList();
    allList.clear();
    incomeList.value.clear();
    expenseList.value.clear();
    totalAmountIncome.value = 0;
    totalAmountExpense.value = 0;
    // itrate and divide transaction model into two list
    //and calculate total amount
    for (var element in listOfTransaction) {
      allList.value.add(element);
      allList.notifyListeners();
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
}
