import 'package:flutter/cupertino.dart';

class BottomNavigationProvider extends ChangeNotifier {
  int selectedIndex = 0;
  set setIndex(int selectedIndex) {
    this.selectedIndex = selectedIndex;
    notifyListeners();
  }
}
