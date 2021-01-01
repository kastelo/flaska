import 'package:flaska/models/rockbottom_model.dart';
import 'package:flutter/material.dart';
import 'package:flutter_guid/flutter_guid.dart';

import '../services/cylinderlist_service.dart';
import '../services/service_locator.dart';
import '../models/cylinder_model.dart';
import '../models/units.dart';

class CylinderSimulationViewModel extends ChangeNotifier {
  final CylinderListService cylinderListService =
      serviceLocator<CylinderListService>();

  RockBottomModel _rockBottom = RockBottomModel(
    depth: DistanceM(15),
    sac: VolumeLiter(15),
    ascentRatePerMin: DistanceM(10),
    troubleSolvingDurationMin: 4,
    safetyStopDepth: DistanceM(5),
    safetyStopDurationMin: 5,
  );
  RockBottomModel get rockBottom => _rockBottom;

  Distance get depth => _rockBottom.depth;
  set depth(Distance value) {
    _rockBottom.depth = value;
    notifyListeners();
  }

  Volume get sac => _rockBottom.sac;
  set sac(Volume value) {
    _rockBottom.sac = value;
    notifyListeners();
  }

  Pressure _pressure = PressureBar(200);
  Pressure get pressure => _pressure;
  set pressure(Pressure p) {
    _pressure = p;
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
}
