import '../proto/proto.dart';
import 'cylinder_model.dart';

abstract class CylinderListService {
  Future<List<CylinderModel>> getCylinders();
}

class FakeCylinderListService implements CylinderListService {
  final cyldata = [
    CylinderData()
      ..name = "ECS 12x232"
      ..measurements = MeasurementSystem.METRIC
      ..metal = Metal.STEEL
      ..volume = 12.0
      ..workingPressure = 232
      ..weight = 14.5
      ..selected = true,
    CylinderData()
      ..name = "Faber 8x300"
      ..measurements = MeasurementSystem.METRIC
      ..metal = Metal.STEEL
      ..volume = 8.0
      ..workingPressure = 300
      ..weight = 12.0
      ..selected = true,
    CylinderData()
      ..name = "AL80"
      ..measurements = MeasurementSystem.IMPERIAL
      ..metal = Metal.ALUMINIUM
      ..volume = 77.4
      ..workingPressure = 3000
      ..weight = 31.9
      ..selected = false,
  ];

  @override
  Future<List<CylinderModel>> getCylinders() async {
    return cyldata.map((d) => CylinderModel.fromData(d)).toList();
  }
}
