import 'package:flutter/cupertino.dart';

class LayoutProvider extends ChangeNotifier {
  String tabHeading = "HRM";
  int navbar = 0;
  bool sideBar = true;

  sideBarOn() {
    sideBar = true;
    notifyListeners();
  }

  changeNav(int int) {
    navbar = int;
    notifyListeners();
  }

  navBarChange(String head, int nav) {
    tabHeading = head;
    navbar = nav;
    notifyListeners();
  }
}
