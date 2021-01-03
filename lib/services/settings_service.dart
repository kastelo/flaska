import 'dart:io';

import 'package:path_provider/path_provider.dart';

import '../proto/proto.dart';

abstract class SettingsService {
  Future<SettingsData> getSettings();
  Future saveSettings(SettingsData settings);
}

final defaultSettings = SettingsData()
  ..measurements = MeasurementSystem.METRIC
  ..sacRate = 15
  ..ascentRate = 10
  ..ascentSacMultiplier = 4
  ..safetystopDepth = 5
  ..safetystopDuration = 3
  ..safetystopSacMultiplier = 2
  ..troubleSolvingDuration = 4
  ..troubleSolvingSacMultiplier = 4;

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
        return SettingsData.fromBuffer(defaultSettings.writeToBuffer());
      }
      return SettingsData.fromBuffer(data);
    } catch (e) {
      return SettingsData.fromBuffer(defaultSettings.writeToBuffer());
    }
  }

  @override
  Future saveSettings(SettingsData settings) async {
    final directory = await getApplicationDocumentsDirectory();
    final listFile = File('${directory.path}/settings.pb');
    await listFile.writeAsBytes(settings.writeToBuffer());
  }
}
