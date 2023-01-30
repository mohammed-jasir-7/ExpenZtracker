import 'package:expenztracker/presentation/screens/Transaction/widget/tab_one.dart';
import 'package:expenztracker/presentation/screens/Transaction/widget/tab_three.dart';
import 'package:expenztracker/presentation/screens/Transaction/widget/tab_two.dart';

import 'package:flutter/material.dart';

import 'package:flutter_toggle_tab/flutter_toggle_tab.dart';

class TransactionScreen extends StatefulWidget {
  const TransactionScreen({super.key});

  @override
  State<TransactionScreen> createState() => _TransactionScreenState();
}

class _TransactionScreenState extends State<TransactionScreen> {
  int _counter = 0;
  List<Widget> tabs = [const TabOne(), const TabTwo(), const TabThree()];
  @override
  Widget build(BuildContext context) {
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
              labels: const ["All", "Income", "Expense"],
              selectedLabelIndex: (p0) {
                setState(() {
                  _counter = p0;
                });
              },
              selectedTextStyle: const TextStyle(color: Colors.white),
              unSelectedTextStyle: const TextStyle(color: Colors.green),
              selectedIndex: _counter),
        ),
        tabs[_counter]
      ],
    );
  }
}
