import 'package:flutter/material.dart';
import 'package:tankbuddy/cylinders/cylinderlist_service.dart';

import '../services/service_locator.dart';
import 'cylinder_model.dart';
import 'units.dart';

class CylinderListViewModel extends ChangeNotifier {
  final CylinderListService cylinderListService =
      serviceLocator<CylinderListService>();

  Pressure _pressure = PressureBar(200);
  Pressure get pressure => _pressure;
  set pressure(Pressure p) {
    _pressure = p;
    notifyListeners();
  }

  Distance _depth = DistanceM(10);
  Distance get depth => _depth;
  set depth(Distance d) {
    _depth = d;
    notifyListeners();
  }

  Volume _sac = VolumeLiter(13);
  Volume get sac => _sac;
  set sac(Volume s) {
    _sac = s;
    notifyListeners();
  }

  List<CylinderModel> _cylinders;
  List<CylinderModel> get cylinders => _cylinders;

  bool _metric = true;
  bool get metric => _metric;
  void toggleMetric() {
    _metric = !_metric;
    notifyListeners();
  }

  loadData() async {
    _cylinders = await cylinderListService.getCylinders();
    notifyListeners();
  }
}
