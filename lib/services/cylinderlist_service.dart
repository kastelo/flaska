import 'dart:io';

import 'package:path_provider/path_provider.dart';

import '../proto/proto.dart';
import '../models/cylinder_model.dart';

abstract class CylinderListService {
  Future<List<CylinderModel>> defaultCylinders();
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
    ..id = '1F7DC8EB-AB82-475B-97DE-F78E24898F3F'
    ..name = 'D12x232'
    ..measurements = MeasurementSystem.METRIC
    ..metal = Metal.STEEL
    ..volume = 12.0
    ..workingPressure = 300
    ..weight = 14.5
    ..selected = false
    ..twinset = true,
  CylinderData()
    ..id = 'AF5DEB8F-B324-4C13-A73D-98267FD343EC'
    ..name = 'D7x300'
    ..measurements = MeasurementSystem.METRIC
    ..metal = Metal.STEEL
    ..volume = 7.0
    ..workingPressure = 300
    ..weight = 8.5
    ..selected = false
    ..twinset = true,
  CylinderData()
    ..id = '851EAA0D-38CA-4995-AFF1-7BC1B7D26A65'
    ..name = 'D8.5x232'
    ..measurements = MeasurementSystem.METRIC
    ..metal = Metal.STEEL
    ..volume = 8.5
    ..workingPressure = 232
    ..weight = 10.4
    ..selected = false
    ..twinset = true,
  CylinderData()
    ..id = 'FE2F31E0-448B-4DAE-AC13-A48A6B5CC6DA'
    ..name = 'S12x232'
    ..measurements = MeasurementSystem.METRIC
    ..metal = Metal.STEEL
    ..volume = 12.0
    ..workingPressure = 232
    ..weight = 14.5
    ..selected = true,
  CylinderData()
    ..id = 'BE45A16A-29D5-49D2-8A1E-6238324C8463'
    ..name = 'S10x300'
    ..measurements = MeasurementSystem.METRIC
    ..metal = Metal.STEEL
    ..volume = 10.0
    ..workingPressure = 300
    ..weight = 15.8
    ..selected = false,
  CylinderData()
    ..id = '341BDE39-90D9-40C9-8F1D-808E3DFE2973'
    ..name = 'S8x300'
    ..measurements = MeasurementSystem.METRIC
    ..metal = Metal.STEEL
    ..volume = 8.0
    ..workingPressure = 300
    ..weight = 12.4
    ..selected = false,
];

class FakeCylinderListService implements CylinderListService {
  @override
  Future<List<CylinderModel>> defaultCylinders() async => defaultCylinderData.map((d) => CylinderModel.fromData(d)).toList();

  @override
  Future<List<CylinderModel>> getCylinders() async => defaultCylinderData.map((d) => CylinderModel.fromData(d)).toList();

  @override
  Future saveCylinders(Iterable<CylinderModel> cylinders) async {}
}

class LocalCylinderListService implements CylinderListService {
  @override
  Future<List<CylinderModel>> defaultCylinders() async => defaultCylinderData.map((d) => CylinderModel.fromData(d)).toList();

  @override
  Future<List<CylinderModel>> getCylinders() async {
    try {
      final directory = await getApplicationDocumentsDirectory();
      final listFile = File('${directory.path}/cylinders.pb');
      final data = await listFile.readAsBytes();
      if (data.isEmpty) {
        return defaultCylinderData.map((d) => CylinderModel.fromData(d)).toList();
      }
      final cylinderSet = CylinderSet.fromBuffer(data);
      return cylinderSet.cylinders.map((d) => CylinderModel.fromData(d)).toList();
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
    final listFile = File('${directory.path}/cylinders.pb');
    await listFile.writeAsBytes(cylinderSet.writeToBuffer());
  }
}
