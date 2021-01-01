import 'package:flutter/material.dart';
import 'package:flutter_guid/flutter_guid.dart';

import '../services/cylinderlist_service.dart';
import '../services/service_locator.dart';
import '../models/cylinder_model.dart';
import '../models/units.dart';

class CylinderListViewModel extends ChangeNotifier {
  final CylinderListService cylinderListService =
      serviceLocator<CylinderListService>();

  Pressure _pressure = PressureBar(200);
  Pressure get pressure => _pressure;
  set pressure(Pressure p) {
    _pressure = p;
    notifyListeners();
  }

  Distance _depth = DistanceM(15);
  Distance get depth => _depth;
  set depth(Distance d) {
    _depth = d;
    notifyListeners();
  }

  Volume _sac = VolumeLiter(15);
  Volume get sac => _sac;
  set sac(Volume s) {
    _sac = s;
    notifyListeners();
  }

  List<CylinderModel> _cylinders = [];
  List<CylinderModel> get cylinders => _cylinders;
  List<CylinderModel> get selectedCylinders =>
      _cylinders.where((c) => c.selected).toList();

  bool _metric = true;
  bool get metric => _metric;
  void toggleMetric() {
    _metric = !_metric;
    notifyListeners();
  }

  void loadData() async {
    _cylinders = await cylinderListService.getCylinders();
    notifyListeners();
  }

  editCylinder(CylinderModel cyl) async {
    _cylinders = _cylinders.map((c) {
      if (c.id == cyl.id)
        return cyl;
      else
        return c;
    }).toList();
    await cylinderListService.saveCylinders(_cylinders);
    notifyListeners();
  }

  addCylinder(CylinderModel cyl) async {
    _cylinders = _cylinders.where((c) => c.id != cyl.id).toList();
    _cylinders.add(cyl);
    await cylinderListService.saveCylinders(_cylinders);
    notifyListeners();
  }

  deleteCylinder(Guid id) async {
    _cylinders = _cylinders.where((c) => c.id != id).toList();
    await cylinderListService.saveCylinders(_cylinders);
    notifyListeners();
  }
}
