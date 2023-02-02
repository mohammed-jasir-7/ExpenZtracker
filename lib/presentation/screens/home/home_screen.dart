import 'package:expenztracker/business_logic/bottom_navigation_provider.dart';
import 'package:expenztracker/business_logic/transaction_provider.dart';
import 'package:expenztracker/presentation/screens/home/widgets/drawer.dart';
import 'package:expenztracker/presentation/screens/home/widgets/home_appbar.dart';
import 'package:expenztracker/presentation/screens/home/widgets/home_button.dart';
import 'package:expenztracker/presentation/screens/home/widgets/home_piechart.dart';
import 'package:expenztracker/presentation/screens/home/widgets/home_selected_item.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../../Data/repositiories/db_function.dart';
import '../Category/category_wise_transaction_list.dart';
import '../Transaction/transaction_screen.dart';
import '../insight/insight_screen.dart';

class HomeScreen extends StatelessWidget {
  HomeScreen({super.key});

  int selectedIndex = 0;

  @override
  Widget build(BuildContext context) {
    Size size = MediaQuery.of(context).size;
    WidgetsBinding.instance.addPostFrameCallback((timeStamp) {
      getCategoryWiseData();
      // Provider.of<TransactionModel>(context).categoryFilter();
      insightFilter();
    });

    return Scaffold(
      appBar: PreferredSize(
          preferredSize: const Size.fromHeight(50), //custom app bar here
          child: HomeAppBar()),
      drawer: Drawer(
        backgroundColor: const Color.fromARGB(255, 242, 242, 242),
        elevation: 0,
        width: size.width / 2,
        child: const DrawerScreen(),
      ),
      bottomNavigationBar: BottomNavigationBar(
          //bottom naviagation
          selectedItemColor: Colors.green,
          onTap: (value) =>
              Provider.of<BottomNavigationProvider>(context, listen: false)
                  .setIndex = value,
          currentIndex:
              Provider.of<BottomNavigationProvider>(context).selectedIndex,
          items: const [
            BottomNavigationBarItem(
                icon: Icon(
                  Icons.home,
                ),
                label: 'Home'),
            BottomNavigationBarItem(
                icon: Icon(Icons.currency_exchange), label: 'Transaction'),
            BottomNavigationBarItem(
                icon: Icon(Icons.category), label: 'Categories')
          ]),
      body: SafeArea(
          child: Consumer<BottomNavigationProvider>(
        builder: (context, value, child) => list.elementAt(value.selectedIndex),
      )),
    );
  }

  List<Widget> list = [
    //List of bottomnavifation
    SingleChildScrollView(
      physics: const BouncingScrollPhysics(),
      child: Column(
        children: [
          const HomeCategoryItems(),
          HomePieChart(),
          const TwoButtons()
        ],
      ),
    ),
    const TransactionScreen(),
    const CategoryListScreen()
  ];
}
