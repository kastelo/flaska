///
//  Generated code. Do not modify.
//  source: flaska.proto
//
// @dart = 2.12
// ignore_for_file: annotate_overrides,camel_case_types,constant_identifier_names,deprecated_member_use_from_same_package,directives_ordering,library_prefixes,non_constant_identifier_names,prefer_final_fields,return_of_invalid_type,unnecessary_const,unnecessary_import,unnecessary_this,unused_import,unused_shown_name

import 'dart:core' as $core;
import 'dart:convert' as $convert;
import 'dart:typed_data' as $typed_data;
@$core.Deprecated('Use measurementSystemDescriptor instead')
const MeasurementSystem$json = const {
  '1': 'MeasurementSystem',
  '2': const [
    const {'1': 'METRIC', '2': 0},
    const {'1': 'IMPERIAL', '2': 1},
  ],
};

/// Descriptor for `MeasurementSystem`. Decode as a `google.protobuf.EnumDescriptorProto`.
final $typed_data.Uint8List measurementSystemDescriptor = $convert.base64Decode('ChFNZWFzdXJlbWVudFN5c3RlbRIKCgZNRVRSSUMQABIMCghJTVBFUklBTBAB');
@$core.Deprecated('Use metalDescriptor instead')
const Metal$json = const {
  '1': 'Metal',
  '2': const [
    const {'1': 'STEEL', '2': 0},
    const {'1': 'ALUMINIUM', '2': 1},
  ],
};

/// Descriptor for `Metal`. Decode as a `google.protobuf.EnumDescriptorProto`.
final $typed_data.Uint8List metalDescriptor = $convert.base64Decode('CgVNZXRhbBIJCgVTVEVFTBAAEg0KCUFMVU1JTklVTRAB');
@$core.Deprecated('Use cylinderSetDescriptor instead')
const CylinderSet$json = const {
  '1': 'CylinderSet',
  '2': const [
    const {'1': 'cylinders', '3': 1, '4': 3, '5': 11, '6': '.CylinderData', '10': 'cylinders'},
  ],
};

/// Descriptor for `CylinderSet`. Decode as a `google.protobuf.DescriptorProto`.
final $typed_data.Uint8List cylinderSetDescriptor = $convert.base64Decode('CgtDeWxpbmRlclNldBIrCgljeWxpbmRlcnMYASADKAsyDS5DeWxpbmRlckRhdGFSCWN5bGluZGVycw==');
@$core.Deprecated('Use cylinderDataDescriptor instead')
const CylinderData$json = const {
  '1': 'CylinderData',
  '2': const [
    const {'1': 'id', '3': 1, '4': 1, '5': 9, '10': 'id'},
    const {'1': 'name', '3': 2, '4': 1, '5': 9, '10': 'name'},
    const {'1': 'metal', '3': 3, '4': 1, '5': 14, '6': '.Metal', '10': 'metal'},
    const {'1': 'measurements', '3': 4, '4': 1, '5': 14, '6': '.MeasurementSystem', '10': 'measurements'},
    const {'1': 'volume', '3': 5, '4': 1, '5': 1, '10': 'volume'},
    const {'1': 'working_pressure', '3': 6, '4': 1, '5': 5, '10': 'workingPressure'},
    const {'1': 'weight', '3': 7, '4': 1, '5': 1, '10': 'weight'},
    const {'1': 'twinset', '3': 8, '4': 1, '5': 8, '10': 'twinset'},
    const {'1': 'selected', '3': 9, '4': 1, '5': 8, '10': 'selected'},
    const {'1': 'overfill', '3': 10, '4': 1, '5': 8, '10': 'overfill'},
  ],
};

/// Descriptor for `CylinderData`. Decode as a `google.protobuf.DescriptorProto`.
final $typed_data.Uint8List cylinderDataDescriptor = $convert.base64Decode('CgxDeWxpbmRlckRhdGESDgoCaWQYASABKAlSAmlkEhIKBG5hbWUYAiABKAlSBG5hbWUSHAoFbWV0YWwYAyABKA4yBi5NZXRhbFIFbWV0YWwSNgoMbWVhc3VyZW1lbnRzGAQgASgOMhIuTWVhc3VyZW1lbnRTeXN0ZW1SDG1lYXN1cmVtZW50cxIWCgZ2b2x1bWUYBSABKAFSBnZvbHVtZRIpChB3b3JraW5nX3ByZXNzdXJlGAYgASgFUg93b3JraW5nUHJlc3N1cmUSFgoGd2VpZ2h0GAcgASgBUgZ3ZWlnaHQSGAoHdHdpbnNldBgIIAEoCFIHdHdpbnNldBIaCghzZWxlY3RlZBgJIAEoCFIIc2VsZWN0ZWQSGgoIb3ZlcmZpbGwYCiABKAhSCG92ZXJmaWxs');
@$core.Deprecated('Use settingsDataDescriptor instead')
const SettingsData$json = const {
  '1': 'SettingsData',
  '2': const [
    const {'1': 'measurements', '3': 1, '4': 1, '5': 14, '6': '.MeasurementSystem', '10': 'measurements'},
    const {'1': 'metric', '3': 2, '4': 1, '5': 11, '6': '.MeasurementDependentSettingsData', '10': 'metric'},
    const {'1': 'imperial', '3': 3, '4': 1, '5': 11, '6': '.MeasurementDependentSettingsData', '10': 'imperial'},
    const {'1': 'trouble_solving_duration', '3': 4, '4': 1, '5': 1, '10': 'troubleSolvingDuration'},
    const {'1': 'trouble_solving_sac_multiplier', '3': 5, '4': 1, '5': 1, '10': 'troubleSolvingSacMultiplier'},
    const {'1': 'ascent_sac_multiplier', '3': 6, '4': 1, '5': 1, '10': 'ascentSacMultiplier'},
    const {'1': 'safety_stop_duration', '3': 7, '4': 1, '5': 1, '10': 'safetyStopDuration'},
    const {'1': 'safety_stop_sac_multiplier', '3': 8, '4': 1, '5': 1, '10': 'safetyStopSacMultiplier'},
    const {'1': 'hide_ndl_notice', '3': 9, '4': 1, '5': 8, '10': 'hideNdlNotice'},
  ],
};

/// Descriptor for `SettingsData`. Decode as a `google.protobuf.DescriptorProto`.
final $typed_data.Uint8List settingsDataDescriptor = $convert.base64Decode('CgxTZXR0aW5nc0RhdGESNgoMbWVhc3VyZW1lbnRzGAEgASgOMhIuTWVhc3VyZW1lbnRTeXN0ZW1SDG1lYXN1cmVtZW50cxI5CgZtZXRyaWMYAiABKAsyIS5NZWFzdXJlbWVudERlcGVuZGVudFNldHRpbmdzRGF0YVIGbWV0cmljEj0KCGltcGVyaWFsGAMgASgLMiEuTWVhc3VyZW1lbnREZXBlbmRlbnRTZXR0aW5nc0RhdGFSCGltcGVyaWFsEjgKGHRyb3VibGVfc29sdmluZ19kdXJhdGlvbhgEIAEoAVIWdHJvdWJsZVNvbHZpbmdEdXJhdGlvbhJDCh50cm91YmxlX3NvbHZpbmdfc2FjX211bHRpcGxpZXIYBSABKAFSG3Ryb3VibGVTb2x2aW5nU2FjTXVsdGlwbGllchIyChVhc2NlbnRfc2FjX211bHRpcGxpZXIYBiABKAFSE2FzY2VudFNhY011bHRpcGxpZXISMAoUc2FmZXR5X3N0b3BfZHVyYXRpb24YByABKAFSEnNhZmV0eVN0b3BEdXJhdGlvbhI7ChpzYWZldHlfc3RvcF9zYWNfbXVsdGlwbGllchgIIAEoAVIXc2FmZXR5U3RvcFNhY011bHRpcGxpZXISJgoPaGlkZV9uZGxfbm90aWNlGAkgASgIUg1oaWRlTmRsTm90aWNl');
@$core.Deprecated('Use measurementDependentSettingsDataDescriptor instead')
const MeasurementDependentSettingsData$json = const {
  '1': 'MeasurementDependentSettingsData',
  '2': const [
    const {'1': 'sac_rate', '3': 1, '4': 1, '5': 1, '10': 'sacRate'},
    const {'1': 'safety_stop_depth', '3': 3, '4': 1, '5': 1, '10': 'safetyStopDepth'},
  ],
  '9': const [
    const {'1': 2, '2': 3},
    const {'1': 4, '2': 9},
  ],
};

/// Descriptor for `MeasurementDependentSettingsData`. Decode as a `google.protobuf.DescriptorProto`.
final $typed_data.Uint8List measurementDependentSettingsDataDescriptor = $convert.base64Decode('CiBNZWFzdXJlbWVudERlcGVuZGVudFNldHRpbmdzRGF0YRIZCghzYWNfcmF0ZRgBIAEoAVIHc2FjUmF0ZRIqChFzYWZldHlfc3RvcF9kZXB0aBgDIAEoAVIPc2FmZXR5U3RvcERlcHRoSgQIAhADSgQIBBAJ');
