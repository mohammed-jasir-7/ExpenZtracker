import 'package:expenztracker/Database/model/model_transaction.dart';
import 'package:expenztracker/custom%20WIDGETS/custom_text.dart';
import 'package:flutter/material.dart';

ValueNotifier<CategoryType?> filterSelectedType = ValueNotifier(null);
ValueNotifier<DateTimeRange?> selectedDateRange = ValueNotifier(null);

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
    if (selectedDateRange == null) return;
    selectedDateRange.value = selectedDate;
    selectedDateRange.notifyListeners();
  }
  //================================================

  showModalBottomSheet(
    context: context,
    builder: (context) {
      return Padding(
        padding: const EdgeInsets.all(8.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Padding(
              padding: const EdgeInsets.symmetric(vertical: 5),
              child: CustomText(
                content: "Transaction type",
                size: 19,
              ),
            ),
            Container(
              decoration: BoxDecoration(
                  border: Border.all(color: Colors.black, width: 1)),
              width: 350,
              height: 40,
              child: ValueListenableBuilder(
                valueListenable: filterSelectedType,
                builder: (context, value, child) => Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: DropdownButton(
                    value: filterSelectedType.value,
                    itemHeight: 50,
                    icon: const Padding(
                      padding: const EdgeInsets.only(left: 200),
                      child: Icon(Icons.arrow_drop_down_circle_outlined),
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
                      filterSelectedType.value = value;
                      filterSelectedType.notifyListeners();
                    },
                  ),
                ),
              ),
            ),
            CustomText(content: "Date"),
            Container(
              width: 400,
              child: ValueListenableBuilder(
                valueListenable: selectedDateRange,
                builder: (context, value, child) => Row(
                  mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                  children: [
                    Expanded(
                      child: ElevatedButton(
                          onPressed: () {
                            datepick();
                          },
                          child: CustomText(
                            content: selectedDateRange.value == null
                                ? 'Start'
                                : '${selectedDateRange.value!.start.day}-${selectedDateRange.value!.start.month}-${selectedDateRange.value!.start.year}',
                          )),
                    ),
                    SizedBox(
                      width: 20,
                    ),
                    Expanded(
                      child: ElevatedButton(
                        onPressed: () {
                          datepick();
                        },
                        child: CustomText(
                          content: selectedDateRange.value == null
                              ? 'End'
                              : '${selectedDateRange.value!.end.day}-${selectedDateRange.value!.end.month}-${selectedDateRange.value!.end.year}',
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            )
          ],
        ),
      );
    },
  );
}
