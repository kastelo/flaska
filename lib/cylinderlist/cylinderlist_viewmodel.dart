import 'package:flutter/material.dart';
import 'package:flutter_guid/flutter_guid.dart';

import '../services/cylinderlist_service.dart';
import '../services/service_locator.dart';
import '../models/cylinder_model.dart';

class CylinderListViewModel extends ChangeNotifier {
  final CylinderListService cylinderListService =
      serviceLocator<CylinderListService>();

  List<CylinderModel> _cylinders = [];
  List<CylinderModel> get cylinders => _cylinders;
  List<CylinderModel> get selectedCylinders =>
      _cylinders.where((c) => c.selected).toList();

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
