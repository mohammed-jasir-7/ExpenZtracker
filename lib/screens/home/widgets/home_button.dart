import 'package:expenztracker/Database/DB%20function/db_function.dart';
import 'package:expenztracker/Database/model/model_transaction.dart';
import 'package:expenztracker/custom%20WIDGETS/custom_route.dart';
import 'package:expenztracker/custom%20WIDGETS/custom_text.dart';

import 'package:expenztracker/screens/calculator/calculator.dart';

import 'package:flutter/material.dart';

// ==============================  income button and expense button ===============================
class TwoButtons extends StatelessWidget {
  const TwoButtons({super.key});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(left: 40, right: 40, top: 30),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          const BalanceShow(), // this is a box to show balance amount . balance=income-expense
          const SizedBox(
            height: 10,
          ),
          SizedBox(
            width: 500,
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: const [
                ExpenseButton(),
                AddButton()
              ], //===================here is income buttton and expense button  ===============
            ), //==================================================================buttons are below
          ),
        ],
      ),
    );
  }
}

//==================================================this balance box ====================================
class BalanceShow extends StatefulWidget {
  const BalanceShow({super.key});

  @override
  State<BalanceShow> createState() => _BalanceShowState();
}

class _BalanceShowState extends State<BalanceShow> {
  @override
  Widget build(BuildContext context) {
    return Container(
        color: Colors.green[200],
        height: 30,
        width: 150,
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceAround,
          children: [
            CustomText(content: "Balance"),
            ValueListenableBuilder(
              // ====== listen total expense notifier =========
              valueListenable: totalAmountExpense,
              builder: (context, value, child) => ValueListenableBuilder(
                //==========listen total income notifier==============
                valueListenable: totalAmountIncome,
                builder: (context, value, child) => CustomText(
                  content:
                      "\u20b9${totalAmountIncome.value - totalAmountExpense.value}", //==== operation  (income-expense)
                  colour: (totalAmountIncome.value -
                              totalAmountExpense.value) //color chaange depends
                          .isNegative
                      ? Colors.red
                      : Colors.black,
                ),
              ),
            )
          ],
        ));
  }
}

//============================================================ income button ======================================================

class AddButton extends StatelessWidget {
  const AddButton({super.key});

  @override
  Widget build(BuildContext context) {
    return InkWell(
      borderRadius: BorderRadius.circular(50),
      onTap: () {
        //===========================     navigation     to calculator . pass: app title , income or expense
        Navigator.push(
            context,
            CustomPageRoute(
              child: const Calculator(
                  appTitle: "new income", categoryType: CategoryType.income),
            ));
      },
      child: Container(
        width: 100,
        height: 100,
        decoration: BoxDecoration(
            border: Border.all(color: const Color(0XFF00900E), width: 20),
            borderRadius: BorderRadius.circular(50)),
        child: const Icon(Icons.add), //==== botton icon
      ),
    );
  }
}
//==================================================================  expense button ====================================================

class ExpenseButton extends StatelessWidget {
  const ExpenseButton({super.key});

  @override
  Widget build(BuildContext context) {
    return InkWell(
      borderRadius: BorderRadius.circular(50),
      onTap: () {
        Navigator.push(
            context,
            CustomPageRoute(
              child: const Calculator(
                  appTitle: "new expense", categoryType: CategoryType.expense),
            ));
      },
      child: Container(
        width: 100,
        height: 100,
        decoration: BoxDecoration(
            border: Border.all(color: const Color(0XFFD73E3E), width: 20),
            borderRadius: BorderRadius.circular(50)),
        child: const Icon(Icons.remove), //== button icon
      ),
    );
  }
}
//=====================================================     end          ==============================
