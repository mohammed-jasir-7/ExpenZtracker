import 'package:expenztracker/business_logic/search_provider.dart';
import 'package:expenztracker/custom%20WIDGETS/custom_text.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../../../../Data/Model/model_transaction.dart';

bottomShet(BuildContext context) {
  // date function
  //intitial range of date
  DateTimeRange? dateRange =
      DateTimeRange(start: DateTime.now(), end: DateTime.now());
  //function
  Future datepick() async {
    DateTimeRange? selectedDate = await showDateRangePicker(
        context: context,
        initialDateRange: dateRange,
        firstDate: DateTime(2000),
        lastDate: DateTime(2050));

    Provider.of<SearchModel>(context, listen: false).selectedTimeRange =
        selectedDate;

    Provider.of<SearchModel>(context, listen: false).notifyListeners();
    // print(Provider.of<SearchModel>(context, listen: false).selectedTimeRange);
  }
  //================================================

  showModalBottomSheet(
    shape: RoundedRectangleBorder(
      borderRadius: BorderRadius.circular(30.0),
    ),
    context: context,
    builder: (context) {
      return SizedBox(
        height: 180,
        child: Padding(
          padding: const EdgeInsets.all(15.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Padding(
                padding: const EdgeInsets.symmetric(vertical: 5),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    CustomText(
                      content: "select type",
                      size: 17,
                      fontname: "Poppins",
                    ),
                    Container(
                      decoration: BoxDecoration(
                          border: Border.all(
                            color: Colors.green,
                            width: 1,
                          ),
                          borderRadius: BorderRadius.circular(30)),
                      width: 150,
                      height: 40,
                      child: Consumer<SearchModel>(
                        builder: (context, searchmdl, child) => Padding(
                          padding: const EdgeInsets.all(8.0),
                          child: DropdownButton(
                            value: searchmdl.selectedCategory,
                            itemHeight: 50,
                            icon: const Padding(
                              padding: EdgeInsets.only(left: 10),
                              child:
                                  Icon(Icons.arrow_drop_down_circle_outlined),
                            ),
                            borderRadius: BorderRadius.circular(30),
                            items: [
                              DropdownMenuItem(
                                value: null,
                                child: CustomText(content: "None"),
                              ),
                              DropdownMenuItem(
                                value: CategoryType.income,
                                child: CustomText(content: "Income"),
                              ),
                              DropdownMenuItem(
                                value: CategoryType.expense,
                                child: CustomText(content: "Expense"),
                              )
                            ],
                            onChanged: (value) {
                              Provider.of<SearchModel>(context, listen: false)
                                  .selectedCategory = value;
                              Provider.of<SearchModel>(context, listen: false)
                                  .notifyListeners();
                            },
                          ),
                        ),
                      ),
                    )
                  ],
                ),
              ),
              CustomText(
                content: "select date",
                size: 17,
                fontname: "Poppins",
              ),
              SizedBox(
                width: 400,
                child: Consumer<SearchModel>(
                  builder: (context, value, child) => Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Expanded(
                        child: ElevatedButton(
                            style: ButtonStyle(
                                backgroundColor: MaterialStatePropertyAll(
                                    Colors.green[400])),
                            onPressed: () {
                              datepick();
                            },
                            child: CustomText(
                              content: value.selectedTimeRange == null
                                  ? 'Start'
                                  : '${value.selectedTimeRange!.start.day}-${value.selectedTimeRange!.start.month}-${value.selectedTimeRange!.start.year}',
                            )),
                      ),
                      const SizedBox(
                        width: 20,
                      ),
                      Expanded(
                        child: ElevatedButton(
                          style: ButtonStyle(
                              backgroundColor:
                                  MaterialStatePropertyAll(Colors.green[400])),
                          onPressed: () {
                            datepick();
                          },
                          child: CustomText(
                            content: value.selectedTimeRange == null
                                ? 'End'
                                : '${value.selectedTimeRange!.end.day}-${value.selectedTimeRange!.end.month}-${value.selectedTimeRange!.end.year}',
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              )
            ],
          ),
        ),
      );
    },
  );
}
