import 'dart:io';

import 'package:path_provider/path_provider.dart';
import 'package:protobuf/protobuf.dart';

import '../proto/proto.dart';

abstract class SettingsService {
  Future<SettingsData> getSettings();
  Future saveSettings(SettingsData settings);
}

final defaultSettings = SettingsData()
  ..measurements = MeasurementSystem.METRIC
  ..ascentSacMultiplier = 4
  ..safetyStopDuration = 3
  ..safetyStopSacMultiplier = 2
  ..troubleSolvingDuration = 4
  ..troubleSolvingSacMultiplier = 4
  ..metric = (MeasurementDependentSettingsData()
    ..sacRate = 15
    ..ascentRate = 10
    ..safetyStopDepth = 5
    ..minPressure = 30
    ..maxPressure = 300
    ..pressureStep = 5
    ..minDepth = 2
    ..maxDepth = 40)
  ..imperial = (MeasurementDependentSettingsData()
    ..sacRate = 0.5
    ..ascentRate = 30
    ..safetyStopDepth = 15
    ..minPressure = 300
    ..maxPressure = 4000
    ..pressureStep = 100
    ..minDepth = 10
    ..maxDepth = 150);

class FakeSettingsListService implements SettingsService {
  var settings = SettingsData();

  @override
  Future<SettingsData> getSettings() async {
    return settings;
  }

  @override
  Future saveSettings(SettingsData settings) async {
    this.settings = settings;
  }
}

class LocalSettingsService implements SettingsService {
  @override
  Future<SettingsData> getSettings() async {
    try {
      final directory = await getApplicationDocumentsDirectory();
      final listFile = File('${directory.path}/settings.pb');
      final data = await listFile.readAsBytes();
      if (data.isEmpty) {
        return defaultSettings.deepCopy();
      }
      SettingsData s = defaultSettings.deepCopy();
      s.mergeFromBuffer(data);
      return s;
    } catch (e) {
      return defaultSettings.deepCopy();
    }
  }

  @override
  Future saveSettings(SettingsData settings) async {
    final directory = await getApplicationDocumentsDirectory();
    final listFile = File('${directory.path}/settings.pb');
    await listFile.writeAsBytes(settings.writeToBuffer());
  }
}
