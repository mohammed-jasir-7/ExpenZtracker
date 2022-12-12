import 'package:expenztracker/Database/DB%20function/db_function.dart';
import 'package:expenztracker/custom%20WIDGETS/custom_text.dart';
import 'package:expenztracker/screens/home/widgets/home_appbar.dart';
import 'package:fl_chart/fl_chart.dart';
import 'package:flutter/material.dart';
import 'package:flutter/src/widgets/container.dart';
import 'package:flutter/src/widgets/framework.dart';

import '../../Database/model/model_transaction.dart';

//INSGHT line grapgh date range variable
ValueNotifier<DateTimeRange?> daterange = ValueNotifier(null);

class InsightScreen extends StatelessWidget {
  const InsightScreen({super.key});

  //==================== insight screen ==============================

  @override
  Widget build(BuildContext context) {
    Size size = MediaQuery.of(context).size;
    return Scaffold(
//=============================app bar ==========================================
      appBar: PreferredSize(
          preferredSize: const Size.fromHeight(50),
          child: HomeAppBar(leadingIcon: false)),
//===============================================================================
      body: SafeArea(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Padding(
                padding: const EdgeInsets.only(left: 30),
                //===== filter buttton ==
                child: Row(
                  children: [
                    TextButton(
                      onPressed: () {
                        bottomSheet(context);
                      },
                      child: CustomText(content: "Last 30 Days "),
                    ),
                    TextButton(
                      onPressed: () {
                        insightFilter();
                      },
                      child: CustomText(content: "Last year"),
                    ),
                    TextButton(
                      style: ButtonStyle(
                        backgroundColor:
                            MaterialStateProperty.all(Colors.blue[100]),
                      ),
                      onPressed: () {
                        bottomSheet(context);
                      },
                      child: CustomText(content: "Last week"),
                    ),
                  ],
                )),
            Padding(
              padding: const EdgeInsets.only(right: 20),
//=======line graph =========
              child:
                  SizedBox(width: size.width, height: 300, child: Linechartt()),
            )
          ],
        ),
      ),
    );
  }

  bottomSheet(BuildContext context) async {
    daterange.value = await showDateRangePicker(
        context: context, firstDate: DateTime(2000), lastDate: DateTime(2050));
  }
}

class Linechartt extends StatelessWidget {
  final List<Color> incomeGradiant = [
    Color.fromARGB(255, 111, 248, 6),
    Color.fromARGB(255, 69, 208, 4)
  ];
  Linechartt({super.key});

  @override
  Widget build(BuildContext context) =>
      LineChart(Experiment.getLinechartData());
}

class LineTitles {
  static getTitleData() => FlTitlesData(
      show: true,
      topTitles: AxisTitles(sideTitles: null),
      rightTitles: AxisTitles(sideTitles: null),
      bottomTitles: AxisTitles(
          sideTitles: SideTitles(
        showTitles: true,
        getTitlesWidget: (value, meta) {
          print("jasssssssssssss");

          switch (value.toInt()) {
            case 1:
              return Text("jan");
            case 2:
              return Text("feb");
            case 3:
              return Text("mar");
          }
          return Text("null");
        },
      )));
}

ValueNotifier<List<Transaction>> linchartTransaction = ValueNotifier([]);

class Experiment {
  static LineChartData getLinechartData() {
    return LineChartData(
        lineTouchData: LineTouchData(),
        backgroundColor: Color.fromARGB(255, 230, 230, 230),
        titlesData: LineTitles.getTitleData(),
        minX: 0,
        maxX: 12,
        minY: 0,
        maxY: totalAmountExpense.value,
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
            barWidth: 3,
            isCurved: true,
            dotData: FlDotData(),
            belowBarData: BarAreaData(
                show: true, color: Color.fromARGB(129, 244, 67, 54)),
            spots: gg,
          )
        ]);
  }
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
    8: 0,
    9: 0,
    10: 0,
    11: 0,
    12: 0
  };

  for (var element in value) {
    if (daterange.value != null) {}
    if (element.categoryType == CategoryType.expense) {
      print(monthly.entries);
      switch (element.date.month) {
        case 12:
          print(element.amount);
          monthly.update(12, (value) => value + element.amount);
          print(monthly.entries);
          break;

        case 2:
          monthly.update(2, (value) => value + element.amount);
          break;
      }
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
