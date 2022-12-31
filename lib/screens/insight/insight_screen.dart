import 'package:expenztracker/Database/DB%20function/db_function.dart';
import 'package:expenztracker/custom%20WIDGETS/custom_text.dart';
import 'package:expenztracker/screens/home/widgets/home_appbar.dart';
import 'package:expenztracker/screens/home/widgets/home_piechart.dart';
import 'package:expenztracker/screens/insight/widgets/first_card.dart';
import 'package:fl_chart/fl_chart.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

import '../../Database/model/model_transaction.dart';

//INSGHT line grapgh date range variable
ValueNotifier<DateTimeRange?> daterange = ValueNotifier(null);

class InsightScreen extends StatelessWidget {
  const InsightScreen({super.key});

  //==================== insight screen ==============================

  @override
  Widget build(BuildContext context) {
    return Scaffold(
//=============================  app bar =========================================
      appBar: PreferredSize(
          preferredSize: const Size.fromHeight(50),
          child: HomeAppBar(leadingIcon: false)),
//==============================================================================
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.only(top: 13, left: 15, right: 15),
          child: SingleChildScrollView(
            physics: const BouncingScrollPhysics(),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                const CardOne(), // overview
                const Divider(
                  thickness: 3,
                ),
                CustomText(
                  content: "Total expense",
                  fontname: "Poppins",
                  weight: FontWeight.w600,
                  size: 20,
                ),
                HomePieChart(isvisible: false), //piechart
//buttons
                const Divider(
                  thickness: 3,
                ),
                CustomText(
                  content: "Last week expense",
                  fontname: "Poppins",
                  weight: FontWeight.w600,
                  size: 16,
                ),
                const SizedBox(
                  height: 30,
                ),
                //================================================= line chart =======================================================
                Padding(
                  padding: const EdgeInsets.only(right: 20),
                  //=======line graph =========
                  child: SizedBox(width: 300, height: 300, child: Linechartt()),
                )
              ],
            ),
          ),
        ),
      ),
    );
  }

  // date picker ======== function=============================

  bottomSheet(BuildContext context) async {
    daterange.value = await showDateRangePicker(
        context: context, firstDate: DateTime(2000), lastDate: DateTime(2050));
  }
}

// line graph widget=====================================
class Linechartt extends StatelessWidget {
  final List<Color> incomeGradiant = [
    const Color.fromARGB(255, 111, 248, 6),
    const Color.fromARGB(255, 69, 208, 4)
  ];
  Linechartt({super.key});

  @override
  Widget build(BuildContext context) => LineChart(
        Experiment.getLinechartData(),
        swapAnimationDuration: const Duration(seconds: 20),
        swapAnimationCurve: Curves.bounceInOut,
      ); // this function return Line chart data
}

//=====================================================================
//======================= getTitledata() return titles=========================
class LineTitles {
  static getTitleData() => FlTitlesData(
      show: true,
      topTitles: AxisTitles(sideTitles: null),
      rightTitles: AxisTitles(sideTitles: null),
      bottomTitles: AxisTitles(
          axisNameWidget: CustomText(content: "Last week dates"),
          sideTitles: SideTitles(
            reservedSize: 30,
            showTitles: true,
            getTitlesWidget: (value, meta) {
              switch (value.toInt()) {
                case 1:
                  final DateTime date =
                      DateTime.now().subtract(const Duration(days: 6));

                  return Text(date.day.toString());
                case 2:
                  final DateTime date =
                      DateTime.now().subtract(const Duration(days: 5));
                  return Text(date.day.toString());
                case 3:
                  final DateTime date =
                      DateTime.now().subtract(const Duration(days: 4));
                  return Text(date.day.toString());
                case 4:
                  final DateTime date =
                      DateTime.now().subtract(const Duration(days: 3));
                  return Text(date.day.toString());
                case 5:
                  final DateTime date =
                      DateTime.now().subtract(const Duration(days: 2));
                  return Text(date.day.toString());
                case 6:
                  final DateTime date =
                      DateTime.now().subtract(const Duration(days: 1));
                  return Text(date.day.toString());
                case 7:
                  final DateTime date =
                      DateTime.now().subtract(const Duration(days: 0));
                  return Text(date.day.toString());
              }
              return const Text("");
            },
          )));
}
//==============================================================================================================

ValueNotifier<List<Transaction>> linchartTransaction = ValueNotifier([]);

// ======================== return linechart data ============================================
//
class Experiment {
  static LineChartData getLinechartData() {
    return LineChartData(
        lineTouchData: LineTouchData(),
        backgroundColor: const Color.fromARGB(255, 230, 230, 230),
        titlesData: LineTitles.getTitleData(),
        minX: 1,
        maxX: 7,
        minY: 0,
        maxY: (getLeftsideTitle() + getLeftsideTitle() / 2),
        gridData: FlGridData(
          show: true,
          getDrawingHorizontalLine: (value) =>
              FlLine(color: Colors.grey, strokeWidth: 0.5),
          getDrawingVerticalLine: (value) =>
              FlLine(color: Colors.grey, strokeWidth: 0.5),
        ),
        borderData: FlBorderData(show: true),
        lineBarsData: [
          LineChartBarData(
            curveSmoothness: 0.5,
            preventCurveOverShooting: true,
            barWidth: 3,
            isCurved: true,
            dotData: FlDotData(),
            belowBarData: BarAreaData(
                show: true, color: const Color.fromARGB(129, 244, 67, 54)),
            spots: gg,
          )
        ]);
  }
}

double getLeftsideTitle() {
  double max = gg.first.y;
  for (var element in gg) {
    if (element.y > max) max = element.y;
  }
  return max;
}

// Map<String, double> monthly = {
//   "Jan": 0,
//   "Feb": 0,
//   "Mar": 0,
//   "Apr": 0,
//   "May": 0,
//   "Jun": 0,
//   "Jul": 0,
//   "Aug": 0,
//   "Sep": 0,
//   "Oct": 0,
//   "Nov": 0,
//   "Dec": 0
// };
List<FlSpot> gg = [];

insightFilter() async {
  List<Transaction> value = Boxes.getTransaction().values.toList();
  Map<double, double> monthly = {
    1: 0,
    2: 0,
    3: 0,
    4: 0,
    5: 0,
    6: 0,
    7: 0,
  };

  for (var element in value) {
    // if (daterange.value != null) {}
    if (element.categoryType == CategoryType.expense) {
      // if(element.date.isAfter(DateTime.now().subtract(Duration(days: 7)))&&element.date.isBefore(DateTime.now()))

      if (DateFormat("yyyy-MM-dd").format(element.date) ==
          DateFormat("yyyy-MM-dd")
              .format(DateTime.now().subtract(const Duration(days: 6)))) {
        monthly.update(1, (value) => value + element.amount);
      } else if (DateFormat("yyyy-MM-dd").format(element.date) ==
          DateFormat("yyyy-MM-dd")
              .format(DateTime.now().subtract(const Duration(days: 5)))) {
        monthly.update(2, (value) => value + element.amount);
      } else if (DateFormat("yyyy-MM-dd").format(element.date) ==
          DateFormat("yyyy-MM-dd")
              .format(DateTime.now().subtract(const Duration(days: 4)))) {
        monthly.update(3, (value) => value + element.amount);
      } else if (DateFormat("yyyy-MM-dd").format(element.date) ==
          DateFormat("yyyy-MM-dd")
              .format(DateTime.now().subtract(const Duration(days: 3)))) {
        monthly.update(4, (value) => value + element.amount);
      } else if (DateFormat("yyyy-MM-dd").format(element.date) ==
          DateFormat("yyyy-MM-dd")
              .format(DateTime.now().subtract(const Duration(days: 2)))) {
        monthly.update(5, (value) => value + element.amount);
      } else if (DateFormat("yyyy-MM-dd").format(element.date) ==
          DateFormat("yyyy-MM-dd")
              .format(DateTime.now().subtract(const Duration(days: 1)))) {
        monthly.update(6, (value) => value + element.amount);
      } else if (DateFormat("yyyy-MM-dd").format(element.date) ==
          DateFormat("yyyy-MM-dd")
              .format(DateTime.now().subtract(const Duration(days: 0)))) {
        monthly.update(7, (value) => value + element.amount);
      }
      //month code
      // switch (element.date) {
      //   case element.date.day:
      //     print(element.amount);
      //     monthly.update(1, (value) => value + element.amount);
      //     print(monthly.entries);
      //     break;

      //   case 2:
      //     monthly.update(2, (value) => value + element.amount);
      //     break;
      //   case 3:
      //     monthly.update(3, (value) => value + element.amount);
      //     break;
      //   case 4:
      //     monthly.update(4, (value) => value + element.amount);
      //     break;
      //   case 5:
      //     monthly.update(5, (value) => value + element.amount);
      //     break;
      //   case 6:
      //     monthly.update(6, (value) => value + element.amount);
      //     break;
      // }
    }
    gg = monthly
        .map(
          (key, values) {
            final value = FlSpot(key, values);
            return MapEntry(key, value);
          },
        )
        .values
        .toList();
  }
}
