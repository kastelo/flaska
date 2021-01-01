import 'package:flutter/material.dart';

enum NavigationPage {
  CylinderListPage,
  DiveCalculationPage,
  SettingsPage,
}

class NavigationViewModel extends ChangeNotifier {
  final _pages = [
    NavigationPage.DiveCalculationPage,
    NavigationPage.CylinderListPage,
    NavigationPage.SettingsPage,
  ];
  final _titles = [
    "Dive Calculation",
    "Cylinders",
    "Settings",
  ];
  var _index = 0;

  int get index => _index;
  NavigationPage get page => _pages[_index];
  String get title => _titles[_index];

  void setIndex(int idx) {
    _index = idx;
    notifyListeners();
  }
}
