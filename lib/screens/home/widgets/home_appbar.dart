import 'dart:developer';

import 'package:expenztracker/Database/DB%20function/db_function.dart';
import 'package:expenztracker/Database/model/model_transaction.dart';
import 'package:expenztracker/screens/home/widgets/bottomsheet.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

import '../../../custom WIDGETS/custom_text.dart';

// ====================================================== app bar ===============================================================

class HomeAppBar extends StatelessWidget {
  HomeAppBar({super.key, this.leadingIcon = true});
  bool leadingIcon = true;

  @override
  Widget build(BuildContext context) {
    Size size = MediaQuery.of(context).size;
    return AppBar(
      centerTitle: true,
      actions: [
//search icon
//this icon navigate to search bar
//search delegate decalred below app bar
        IconButton(
            onPressed: () =>
                {showSearch(context: context, delegate: MysearchDelegate())},
            icon: const Icon(Icons.search))
      ],
      //===========================================================================
//================================================ app bar title =============================================
      title: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          CustomText(content: "Expen"),
          CustomText(
            content: "Z",
            size: 25,
            weight: FontWeight.w700,
          )
        ],
      ),
//===========================================================================
//============================================ drawer ==================================================
      leading: leadingIcon
          ? Builder(
              //drawer icon button
              builder: (context) => IconButton(
                    icon: Icon(
                      Icons.sort,
                      size: size.width * 0.1,
                    ),
                    onPressed: () {
                      return Scaffold.of(context).openDrawer();
                    },
                  ))
          : null,
      flexibleSpace: Container(
        decoration: const BoxDecoration(
            gradient: LinearGradient(
                colors: [Color(0xFF64ED08), Color.fromARGB(255, 0, 210, 108)])),
      ),
    );
  }
}

//===================================================== app bar end here ====================================================
ValueNotifier<List<Transaction>> transaction = ValueNotifier([]);

//=====================================================search bar ================================================================
class MysearchDelegate extends SearchDelegate {
  @override
  // TODO: implement searchFieldStyle
  TextStyle? get searchFieldStyle => const TextStyle(color: Colors.amber);

  @override
  List<Widget>? buildActions(BuildContext context) => [
        IconButton(
            onPressed: () {
              bottomShet(context);
            },
            icon: const Icon(Icons.sort)),
        IconButton(
            onPressed: () {
              if (query.isEmpty) {
                close(context, null);
              } else {
                query = '';
              }
            },
            icon: const Icon(Icons.close))
      ];

  @override
  Widget? buildLeading(BuildContext context) => IconButton(
      onPressed: () => close(context, null),
      icon: const Icon(Icons.arrow_back));

  @override
  Widget buildResults(BuildContext context) {
    // WidgetsBinding.instance.addPostFrameCallback((_) {
    //   List<Transaction> get = searchFilter(query);
    //   transaction.value.addAll(get);
    //   transaction.notifyListeners();
    // });
    return Text("data");
  }

  @override
  Widget buildSuggestions(BuildContext context) {
    WidgetsBinding.instance.addPostFrameCallback((_) {
      if (query.isNotEmpty) {
        List<Transaction> get = searchFilter(query);
        transaction.value.clear();
        transaction.value.addAll(get);
        transaction.notifyListeners();
      }

      // Add Your Code here.
    });

    // TODO: implement buildSuggestions
    return query.isEmpty
        ? SizedBox(
            width: double.infinity,
            height: double.infinity,
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                const Icon(
                  Icons.search,
                  size: 60,
                  color: Colors.grey,
                ),
                CustomText(
                  content: "search by category or note",
                  size: 20,
                  colour: Colors.grey,
                  fontname: 'Poppins',
                )
              ],
            ),
          )
        : Container(
            width: double.infinity,
            child: ValueListenableBuilder(
              valueListenable: transaction,
              builder: (context, value, child) {
                return transaction.value.length != 0
                    ? ListView.separated(
                        separatorBuilder: (context, index) => SizedBox(
                          height: 2,
                        ),
                        itemBuilder: (context, index) {
                          var month = DateFormat.MMM()
                              .format(transaction.value[index].date);
                          var year = DateFormat.y()
                              .format(transaction.value[index].date);
                          final amount = TextEditingController();
                          final note = TextEditingController();
                          amount.text =
                              transaction.value[index].amount.toString();
                          return ListTile(
                            title: CustomText(
                              content: transaction
                                  .value[index].category.categoryName,
                              colour: Color(
                                  transaction.value[index].category.color),
                              size: 22,
                              weight: FontWeight.w600,
                            ),
                            leading: Column(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                                CustomText(
                                  content: transaction.value[index].date.day
                                      .toString(),
                                  size: 20,
                                  weight: FontWeight.w700,
                                ),
                                CustomText(content: month),
                                CustomText(
                                    content: transaction.value[index].date.year
                                        .toString()),
                              ],
                            ),
                            trailing: CustomText(
                              content:
                                  ' +\u20b9 ${transaction.value[index].amount.toString()}',
                              colour: transaction
                                          .value[index].category.categoryType ==
                                      CategoryType.expense
                                  ? Colors.red
                                  : Colors.green,
                              size: 18,
                              weight: FontWeight.w600,
                            ),
                            subtitle: CustomText(
                              content: transaction.value[index].note,
                              colour: Colors.grey,
                            ),
                          );
                        },
                        itemCount: transaction.value.length,
                      )
                    : Container(
                        width: double.infinity,
                        height: double.infinity,
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.center,
                          crossAxisAlignment: CrossAxisAlignment.center,
                          children: [
                            CustomText(
                              content: "No records have been found",
                              size: 18,
                              colour: Colors.grey,
                              fontname: 'Poppins',
                            ),
                          ],
                        ),
                      );
              },
            ),
          );
  }
}

List<Transaction> searchFilter(String query) {
  print("hhhS${filterSelectedType.value}");
  List<Transaction> transaction = Boxes.getTransaction().values.toList();
  List<Transaction> filterd = transaction.where(
    (element) {
      if (filterSelectedType.value == null && selectedDateRange.value == null) {
        return element.category.categoryName
                .toLowerCase()
                .contains(query.toLowerCase()) ||
            element.note.toLowerCase().contains(query.toLowerCase());
      } else if (filterSelectedType.value != null) {
        if (selectedDateRange.value != null) {
          if (element.date.isAfter(selectedDateRange.value!.start) &&
              element.date.isBefore(selectedDateRange.value!.end) &&
              filterSelectedType.value == element.categoryType) {
            return element.category.categoryName
                    .toLowerCase()
                    .contains(query.toLowerCase()) ||
                element.note.toLowerCase().contains(query.toLowerCase());
          }
        } else {
          return element.categoryType == filterSelectedType.value;
        }
      } else if (element.date.isAfter(selectedDateRange.value!.start) &&
          element.date.isBefore(selectedDateRange.value!.end)) {
        log("ccccccc");
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
