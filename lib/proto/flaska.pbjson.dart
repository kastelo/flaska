//
//  Generated code. Do not modify.
//  source: flaska.proto
//
// @dart = 2.12

// ignore_for_file: annotate_overrides, camel_case_types
// ignore_for_file: constant_identifier_names, library_prefixes
// ignore_for_file: non_constant_identifier_names, prefer_final_fields
// ignore_for_file: unnecessary_import, unnecessary_this, unused_import

import 'dart:convert' as $convert;
import 'dart:core' as $core;
import 'dart:typed_data' as $typed_data;

@$core.Deprecated('Use measurementSystemDescriptor instead')
const MeasurementSystem$json = {
  '1': 'MeasurementSystem',
  '2': [
    {'1': 'METRIC', '2': 0},
    {'1': 'IMPERIAL', '2': 1},
  ],
};

/// Descriptor for `MeasurementSystem`. Decode as a `google.protobuf.EnumDescriptorProto`.
final $typed_data.Uint8List measurementSystemDescriptor = $convert.base64Decode(
    'ChFNZWFzdXJlbWVudFN5c3RlbRIKCgZNRVRSSUMQABIMCghJTVBFUklBTBAB');

@$core.Deprecated('Use metalDescriptor instead')
const Metal$json = {
  '1': 'Metal',
  '2': [
    {'1': 'STEEL', '2': 0},
    {'1': 'ALUMINIUM', '2': 1},
  ],
};

/// Descriptor for `Metal`. Decode as a `google.protobuf.EnumDescriptorProto`.
final $typed_data.Uint8List metalDescriptor = $convert.base64Decode(
    'CgVNZXRhbBIJCgVTVEVFTBAAEg0KCUFMVU1JTklVTRAB');

@$core.Deprecated('Use themeColorDescriptor instead')
const ThemeColor$json = {
  '1': 'ThemeColor',
  '2': [
    {'1': 'BLUE', '2': 0},
    {'1': 'PINK', '2': 1},
    {'1': 'GREEN', '2': 2},
    {'1': 'ORANGE', '2': 3},
    {'1': 'PURPLE', '2': 4},
  ],
};

/// Descriptor for `ThemeColor`. Decode as a `google.protobuf.EnumDescriptorProto`.
final $typed_data.Uint8List themeColorDescriptor = $convert.base64Decode(
    'CgpUaGVtZUNvbG9yEggKBEJMVUUQABIICgRQSU5LEAESCQoFR1JFRU4QAhIKCgZPUkFOR0UQAx'
    'IKCgZQVVJQTEUQBA==');

@$core.Deprecated('Use principlesDescriptor instead')
const Principles$json = {
  '1': 'Principles',
  '2': [
    {'1': 'ROCKBOTTOM', '2': 0},
    {'1': 'MINGAS', '2': 1},
  ],
};

/// Descriptor for `Principles`. Decode as a `google.protobuf.EnumDescriptorProto`.
final $typed_data.Uint8List principlesDescriptor = $convert.base64Decode(
    'CgpQcmluY2lwbGVzEg4KClJPQ0tCT1RUT00QABIKCgZNSU5HQVMQAQ==');

@$core.Deprecated('Use usableGasDescriptor instead')
const UsableGas$json = {
  '1': 'UsableGas',
  '2': [
    {'1': 'ALL_USABLE', '2': 0},
    {'1': 'HALVES', '2': 1},
    {'1': 'THIRDS', '2': 2},
  ],
};

/// Descriptor for `UsableGas`. Decode as a `google.protobuf.EnumDescriptorProto`.
final $typed_data.Uint8List usableGasDescriptor = $convert.base64Decode(
    'CglVc2FibGVHYXMSDgoKQUxMX1VTQUJMRRAAEgoKBkhBTFZFUxABEgoKBlRISVJEUxAC');

@$core.Deprecated('Use cylinderSetDescriptor instead')
const CylinderSet$json = {
  '1': 'CylinderSet',
  '2': [
    {'1': 'cylinders', '3': 1, '4': 3, '5': 11, '6': '.CylinderData', '10': 'cylinders'},
  ],
};

/// Descriptor for `CylinderSet`. Decode as a `google.protobuf.DescriptorProto`.
final $typed_data.Uint8List cylinderSetDescriptor = $convert.base64Decode(
    'CgtDeWxpbmRlclNldBIrCgljeWxpbmRlcnMYASADKAsyDS5DeWxpbmRlckRhdGFSCWN5bGluZG'
    'Vycw==');

@$core.Deprecated('Use cylinderDataDescriptor instead')
const CylinderData$json = {
  '1': 'CylinderData',
  '2': [
    {'1': 'id', '3': 1, '4': 1, '5': 9, '10': 'id'},
    {'1': 'name', '3': 2, '4': 1, '5': 9, '10': 'name'},
    {'1': 'metal', '3': 3, '4': 1, '5': 14, '6': '.Metal', '10': 'metal'},
    {'1': 'measurements', '3': 4, '4': 1, '5': 14, '6': '.MeasurementSystem', '10': 'measurements'},
    {'1': 'volume', '3': 5, '4': 1, '5': 1, '10': 'volume'},
    {'1': 'working_pressure', '3': 6, '4': 1, '5': 5, '10': 'workingPressure'},
    {'1': 'weight', '3': 7, '4': 1, '5': 1, '10': 'weight'},
    {'1': 'twinset', '3': 8, '4': 1, '5': 8, '10': 'twinset'},
    {'1': 'selected', '3': 9, '4': 1, '5': 8, '10': 'selected'},
    {'1': 'overfill', '3': 10, '4': 1, '5': 8, '10': 'overfill'},
  ],
};

/// Descriptor for `CylinderData`. Decode as a `google.protobuf.DescriptorProto`.
final $typed_data.Uint8List cylinderDataDescriptor = $convert.base64Decode(
    'CgxDeWxpbmRlckRhdGESDgoCaWQYASABKAlSAmlkEhIKBG5hbWUYAiABKAlSBG5hbWUSHAoFbW'
    'V0YWwYAyABKA4yBi5NZXRhbFIFbWV0YWwSNgoMbWVhc3VyZW1lbnRzGAQgASgOMhIuTWVhc3Vy'
    'ZW1lbnRTeXN0ZW1SDG1lYXN1cmVtZW50cxIWCgZ2b2x1bWUYBSABKAFSBnZvbHVtZRIpChB3b3'
    'JraW5nX3ByZXNzdXJlGAYgASgFUg93b3JraW5nUHJlc3N1cmUSFgoGd2VpZ2h0GAcgASgBUgZ3'
    'ZWlnaHQSGAoHdHdpbnNldBgIIAEoCFIHdHdpbnNldBIaCghzZWxlY3RlZBgJIAEoCFIIc2VsZW'
    'N0ZWQSGgoIb3ZlcmZpbGwYCiABKAhSCG92ZXJmaWxs');

@$core.Deprecated('Use settingsDataDescriptor instead')
const SettingsData$json = {
  '1': 'SettingsData',
  '2': [
    {'1': 'measurements', '3': 1, '4': 1, '5': 14, '6': '.MeasurementSystem', '10': 'measurements'},
    {'1': 'metric', '3': 2, '4': 1, '5': 11, '6': '.MeasurementDependentSettingsData', '10': 'metric'},
    {'1': 'imperial', '3': 3, '4': 1, '5': 11, '6': '.MeasurementDependentSettingsData', '10': 'imperial'},
    {'1': 'trouble_solving_duration', '3': 4, '4': 1, '5': 1, '10': 'troubleSolvingDuration'},
    {'1': 'trouble_solving_sac_multiplier', '3': 5, '4': 1, '5': 1, '10': 'troubleSolvingSacMultiplier'},
    {'1': 'ascent_sac_multiplier', '3': 6, '4': 1, '5': 1, '10': 'ascentSacMultiplier'},
    {'1': 'safety_stop_duration', '3': 7, '4': 1, '5': 1, '10': 'safetyStopDuration'},
    {'1': 'safety_stop_sac_multiplier', '3': 8, '4': 1, '5': 1, '10': 'safetyStopSacMultiplier'},
    {'1': 'hide_ndl_notice', '3': 9, '4': 1, '5': 8, '10': 'hideNdlNotice'},
    {'1': 'theme_color', '3': 10, '4': 1, '5': 14, '6': '.ThemeColor', '10': 'themeColor'},
    {'1': 'principles', '3': 11, '4': 1, '5': 14, '6': '.Principles', '10': 'principles'},
    {'1': 'usable_gas', '3': 12, '4': 1, '5': 14, '6': '.UsableGas', '10': 'usableGas'},
  ],
};

/// Descriptor for `SettingsData`. Decode as a `google.protobuf.DescriptorProto`.
final $typed_data.Uint8List settingsDataDescriptor = $convert.base64Decode(
    'CgxTZXR0aW5nc0RhdGESNgoMbWVhc3VyZW1lbnRzGAEgASgOMhIuTWVhc3VyZW1lbnRTeXN0ZW'
    '1SDG1lYXN1cmVtZW50cxI5CgZtZXRyaWMYAiABKAsyIS5NZWFzdXJlbWVudERlcGVuZGVudFNl'
    'dHRpbmdzRGF0YVIGbWV0cmljEj0KCGltcGVyaWFsGAMgASgLMiEuTWVhc3VyZW1lbnREZXBlbm'
    'RlbnRTZXR0aW5nc0RhdGFSCGltcGVyaWFsEjgKGHRyb3VibGVfc29sdmluZ19kdXJhdGlvbhgE'
    'IAEoAVIWdHJvdWJsZVNvbHZpbmdEdXJhdGlvbhJDCh50cm91YmxlX3NvbHZpbmdfc2FjX211bH'
    'RpcGxpZXIYBSABKAFSG3Ryb3VibGVTb2x2aW5nU2FjTXVsdGlwbGllchIyChVhc2NlbnRfc2Fj'
    'X211bHRpcGxpZXIYBiABKAFSE2FzY2VudFNhY011bHRpcGxpZXISMAoUc2FmZXR5X3N0b3BfZH'
    'VyYXRpb24YByABKAFSEnNhZmV0eVN0b3BEdXJhdGlvbhI7ChpzYWZldHlfc3RvcF9zYWNfbXVs'
    'dGlwbGllchgIIAEoAVIXc2FmZXR5U3RvcFNhY011bHRpcGxpZXISJgoPaGlkZV9uZGxfbm90aW'
    'NlGAkgASgIUg1oaWRlTmRsTm90aWNlEiwKC3RoZW1lX2NvbG9yGAogASgOMgsuVGhlbWVDb2xv'
    'clIKdGhlbWVDb2xvchIrCgpwcmluY2lwbGVzGAsgASgOMgsuUHJpbmNpcGxlc1IKcHJpbmNpcG'
    'xlcxIpCgp1c2FibGVfZ2FzGAwgASgOMgouVXNhYmxlR2FzUgl1c2FibGVHYXM=');

@$core.Deprecated('Use measurementDependentSettingsDataDescriptor instead')
const MeasurementDependentSettingsData$json = {
  '1': 'MeasurementDependentSettingsData',
  '2': [
    {'1': 'sac_rate', '3': 1, '4': 1, '5': 1, '10': 'sacRate'},
  ],
  '9': [
    {'1': 2, '2': 9},
  ],
};

/// Descriptor for `MeasurementDependentSettingsData`. Decode as a `google.protobuf.DescriptorProto`.
final $typed_data.Uint8List measurementDependentSettingsDataDescriptor = $convert.base64Decode(
    'CiBNZWFzdXJlbWVudERlcGVuZGVudFNldHRpbmdzRGF0YRIZCghzYWNfcmF0ZRgBIAEoAVIHc2'
    'FjUmF0ZUoECAIQCQ==');

