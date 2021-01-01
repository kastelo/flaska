import 'package:flutter/material.dart';

enum NavigationPage {
  CylinderListPage,
  DiveCalculationPage,
}

class NavigationViewModel extends ChangeNotifier {
  final _pages = [
    NavigationPage.DiveCalculationPage,
    NavigationPage.CylinderListPage
  ];
  int _index = 0;

  int get index => _index;
  NavigationPage get page => _pages[_index];

  void setIndex(int idx) {
    _index = idx;
    notifyListeners();
  }
}
