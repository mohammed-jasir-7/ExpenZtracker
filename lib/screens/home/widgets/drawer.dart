import 'package:expenztracker/Database/model/model_transaction.dart';
import 'package:expenztracker/custom%20WIDGETS/custom_route.dart';
import 'package:expenztracker/custom%20WIDGETS/custom_text.dart';
import 'package:expenztracker/screens/calculator/calculator.dart';
import 'package:expenztracker/screens/home/widgets/about_app.dart';
import 'package:expenztracker/screens/insight/insight_screen.dart';
import 'package:expenztracker/screens/planner/planner_screen.dart';

import 'package:flutter/material.dart';

class DrawerScreen extends StatelessWidget {
  const DrawerScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          //====================== insights======
          InkWell(
            onTap: () {
              Navigator.push(
                  context, CustomPageRoute(child: const InsightScreen()));
            },
            child: ListTile(
              title: CustomText(
                content: "Insights",
                fontname: "Poppins",
                size: 15,
              ),
              leading: SizedBox(
                width: 40,
                height: 35,
                child: Image.asset(
                  "assets/icons/insights.png",
                  width: 30,
                ),
              ),
            ),
          ), //======================== planner =========================
          InkWell(
            onTap: () {
              Navigator.push(
                  context, CustomPageRoute(child: const PlannerScreen()));
            },
            child: ListTile(
              title: CustomText(
                content: "Planner",
                fontname: "Poppins",
                size: 15,
              ),
              leading: SizedBox(
                width: 40,
                height: 35,
                child: Image.asset(
                  "assets/icons/planner.png",
                  width: 30,
                ),
              ),
            ),
          ),
          //=====================================calculator ==================================
          InkWell(
            onTap: () {
              Navigator.push(
                  context,
                  CustomPageRoute(
                      child: const Calculator(
                          isvisible: false,
                          appTitle: "Calculator",
                          categoryType: CategoryType.income)));
            },
            child: ListTile(
              title: CustomText(
                content: "Calculator",
                fontname: "Poppins",
                size: 15,
              ),
              leading: SizedBox(
                width: 40,
                height: 30,
                child: Image.asset(
                  "assets/icons/calculator.png",
                  width: 30,
                ),
              ),
            ),
          ),
          //============================ about app ======================
          InkWell(
            onTap: () {
              Navigator.push(context, CustomPageRoute(child: const AboutApp()));
            },
            child: ListTile(
              title: CustomText(
                content: "About app",
                fontname: "Poppins",
                size: 15,
              ),
              leading: SizedBox(
                width: 40,
                height: 30,
                child: Image.asset(
                  "assets/icons/about.png",
                  width: 30,
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
