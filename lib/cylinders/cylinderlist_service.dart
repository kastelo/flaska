import 'dart:io';

import 'package:path_provider/path_provider.dart';

import '../proto/proto.dart';
import 'cylinder_model.dart';

abstract class CylinderListService {
  Future<List<CylinderModel>> getCylinders();
  Future saveCylinders(Iterable<CylinderModel> cylinders);
}

final defaultCylinderData = [
  CylinderData()
    ..id = '8ECDF9F0-2051-410A-A2B4-860DF98DE1BC'
    ..name = "AL80"
    ..measurements = MeasurementSystem.IMPERIAL
    ..metal = Metal.ALUMINIUM
    ..volume = 77.4
    ..workingPressure = 3000
    ..weight = 31.9
    ..selected = true,
  CylinderData()
    ..id = 'FE2F31E0-448B-4DAE-AC13-A48A6B5CC6DA'
    ..name = 'ECS 12x232'
    ..measurements = MeasurementSystem.METRIC
    ..metal = Metal.STEEL
    ..volume = 12.0
    ..workingPressure = 232
    ..weight = 14.5
    ..selected = true,
  CylinderData()
    ..id = 'BE45A16A-29D5-49D2-8A1E-6238324C8463'
    ..name = 'ECS 10x300'
    ..measurements = MeasurementSystem.METRIC
    ..metal = Metal.STEEL
    ..volume = 10.0
    ..workingPressure = 300
    ..weight = 15.8
    ..selected = true,
  CylinderData()
    ..id = '341BDE39-90D9-40C9-8F1D-808E3DFE2973'
    ..name = 'Faber 8x300'
    ..measurements = MeasurementSystem.METRIC
    ..metal = Metal.STEEL
    ..volume = 8.0
    ..workingPressure = 300
    ..weight = 12.4
    ..selected = true,
];

class FakeCylinderListService implements CylinderListService {
  @override
  Future<List<CylinderModel>> getCylinders() async {
    return defaultCylinderData.map((d) => CylinderModel.fromData(d)).toList();
  }

  @override
  Future saveCylinders(Iterable<CylinderModel> cylinders) async {}
}

class LocalCylinderListService implements CylinderListService {
  @override
  Future<List<CylinderModel>> getCylinders() async {
    try {
      final directory = await getApplicationDocumentsDirectory();
      final listFile = File('$directory/cylinders.pb');
      final data = await listFile.readAsBytes();
      final cylinderSet = CylinderSet.fromBuffer(data);
      return cylinderSet.cylinders
          .map((d) => CylinderModel.fromData(d))
          .toList();
    } catch (e) {
      return defaultCylinderData.map((d) => CylinderModel.fromData(d)).toList();
    }
  }

  @override
  Future saveCylinders(Iterable<CylinderModel> cylinders) async {
    final cylinderSet = CylinderSet();
    for (final m in cylinders) {
      cylinderSet.cylinders.add(m.toData());
    }

    final directory = await getApplicationDocumentsDirectory();
    final listFile = File('$directory/cylinders.pb');
    await listFile.writeAsBytes(cylinderSet.writeToBuffer());
  }
}
