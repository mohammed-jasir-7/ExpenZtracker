import 'package:expenztracker/Data/Model/model_transaction.dart';

import 'package:flutter/material.dart';

class SearchModel extends ChangeNotifier {
  List<Transaction> allTransactionList = [];
  CategoryType? selectedCategory;
  DateTimeRange? selectedTimeRange;

  List<Transaction> searchFilter(String query) {
    List<Transaction> filterd = allTransactionList.where(
      (element) {
        if (selectedCategory == null && selectedTimeRange == null) {
          return element.category.categoryName
                  .toLowerCase()
                  .contains(query.toLowerCase()) ||
              element.note.toLowerCase().contains(query.toLowerCase());
        } else if (selectedCategory != null) {
          if (selectedTimeRange != null) {
            if (element.date.isAfter(selectedTimeRange!.start) &&
                element.date.isBefore(selectedTimeRange!.end) &&
                selectedCategory == element.categoryType) {
              return element.category.categoryName
                      .toLowerCase()
                      .contains(query.toLowerCase()) ||
                  element.note.toLowerCase().contains(query.toLowerCase());
            }
          } else {
            return element.categoryType == selectedCategory;
          }
        } else if (element.date.isAfter(selectedTimeRange!.start) &&
            element.date.isBefore(selectedTimeRange!.end)) {
          return element.category.categoryName
                  .toLowerCase()
                  .contains(query.toLowerCase()) ||
              element.note.toLowerCase().contains(query.toLowerCase());
        }
        return false;
      },
    ).toList();

    return filterd;
  }
}
