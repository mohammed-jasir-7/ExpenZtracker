import 'package:expenztracker/Database/DB%20function/db_function.dart';
import 'package:expenztracker/Database/model/model_transaction.dart';
import 'package:expenztracker/custom%20WIDGETS/custom_text.dart';
import 'package:expenztracker/custom%20WIDGETS/custom_textInput.dart';
import 'package:expenztracker/screens/Transaction/widget/tab_one.dart';
import 'package:expenztracker/screens/Transaction/widget/tab_three.dart';
import 'package:expenztracker/screens/Transaction/widget/tab_two.dart';
import 'package:flutter/material.dart';
import 'package:flutter_slidable/flutter_slidable.dart';
import 'package:flutter_toggle_tab/flutter_toggle_tab.dart';

import 'package:hive_flutter/hive_flutter.dart';
import 'package:intl/intl.dart';

class TransactionScreen extends StatefulWidget {
  const TransactionScreen({super.key});

  @override
  State<TransactionScreen> createState() => _TransactionScreenState();
}

class _TransactionScreenState extends State<TransactionScreen> {
  int _counter = 0;
  List<Widget> tabs = [TabOne(), TabTwo(), TabThree()];
  @override
  Widget build(BuildContext context) {
    Size size = MediaQuery.of(context).size;

    // value listenble builder    detTransaction listen and build when it change
    return Column(
      crossAxisAlignment: CrossAxisAlignment.center,
      children: [
        Padding(
          padding: const EdgeInsets.only(
            top: 17,
          ),
          child: FlutterToggleTab(
              begin: Alignment.center,
              width: 80,
              height: 35,
              labels: ["All", "Income", "Expense"],
              selectedLabelIndex: (p0) {
                setState(() {
                  _counter = p0;
                });
                print(_counter);
              },
              selectedTextStyle: TextStyle(),
              unSelectedTextStyle: TextStyle(),
              selectedIndex: _counter),
        ),
        tabs[_counter]
      ],
    );
  }
}
