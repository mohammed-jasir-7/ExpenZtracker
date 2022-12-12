import 'package:expenztracker/screens/Category/category_screen.dart';
import 'package:expenztracker/screens/Transaction/transaction_screen.dart';
import 'package:expenztracker/screens/home/widgets/drawer.dart';
import 'package:expenztracker/screens/home/widgets/home_appbar.dart';
import 'package:expenztracker/screens/home/widgets/home_button.dart';
import 'package:expenztracker/screens/home/widgets/home_piechart.dart';

import 'package:expenztracker/screens/home/widgets/home_selected_item.dart';
import 'package:flutter/material.dart';

import '../../Database/DB function/db_function.dart';
import '../insight/insight_screen.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  int selectedIndex = 0;
  @override
  void initState() {
    // TODO: implement initState
    WidgetsBinding.instance.addPostFrameCallback((timeStamp) {
      getCategoryWiseData();
      categoryFilter();
      insightFilter();
    });
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    Size size = MediaQuery.of(context).size;

    return Scaffold(
      appBar: PreferredSize(
          preferredSize: Size.fromHeight(50), //custom app bar here
          child: HomeAppBar()),
      drawer: Drawer(
        width: size.width / 4.9,
        child: DrawerScreen(),
      ),
      bottomNavigationBar: BottomNavigationBar(
          //bottom naviagation
          selectedItemColor: Colors.green,
          onTap: (value) => setState(() {
                selectedIndex = value;
              }),
          currentIndex: selectedIndex,
          items: const [
            BottomNavigationBarItem(
                icon: Icon(
                  Icons.home,
                ),
                label: 'Home'),
            BottomNavigationBarItem(
                icon: Icon(Icons.currency_exchange), label: 'Transaction'),
            BottomNavigationBarItem(
                icon: Icon(Icons.category), label: 'Cateegories')
          ]),
      body: list.elementAt(selectedIndex),
    );
  }

  List<Widget> list = [
    //List of bottomnavifation
    SingleChildScrollView(
      physics: const BouncingScrollPhysics(),
      child: Column(
        children: [HomeCategoryItems(), HomePieChart(), TwoButtons()],
      ),
    ),
    const TransactionScreen(),
    const CategoryListScreen()
  ];
}
