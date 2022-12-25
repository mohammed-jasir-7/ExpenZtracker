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

    selectedDateRange.value = selectedDate;
    selectedDateRange.notifyListeners();
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
                      child: ValueListenableBuilder(
                        valueListenable: filterSelectedType,
                        builder: (context, value, child) => Padding(
                          padding: const EdgeInsets.all(8.0),
                          child: DropdownButton(
                            value: filterSelectedType.value,
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
                              filterSelectedType.value = value;
                              filterSelectedType.notifyListeners();
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
                child: ValueListenableBuilder(
                  valueListenable: selectedDateRange,
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
                              content: selectedDateRange.value == null
                                  ? 'Start'
                                  : '${selectedDateRange.value!.start.day}-${selectedDateRange.value!.start.month}-${selectedDateRange.value!.start.year}',
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
        ),
      );
    },
  );
}
