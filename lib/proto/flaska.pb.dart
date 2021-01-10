///
//  Generated code. Do not modify.
//  source: flaska.proto
//
// @dart = 2.3
// ignore_for_file: annotate_overrides,camel_case_types,unnecessary_const,non_constant_identifier_names,library_prefixes,unused_import,unused_shown_name,return_of_invalid_type,unnecessary_this,prefer_final_fields

import 'dart:core' as $core;

import 'package:protobuf/protobuf.dart' as $pb;

import 'flaska.pbenum.dart';

export 'flaska.pbenum.dart';

class CylinderSet extends $pb.GeneratedMessage {
  static final $pb.BuilderInfo _i = $pb.BuilderInfo(const $core.bool.fromEnvironment('protobuf.omit_message_names') ? '' : 'CylinderSet', createEmptyInstance: create)
    ..pc<CylinderData>(1, const $core.bool.fromEnvironment('protobuf.omit_field_names') ? '' : 'cylinders', $pb.PbFieldType.PM, subBuilder: CylinderData.create)
    ..hasRequiredFields = false
  ;

  CylinderSet._() : super();
  factory CylinderSet() => create();
  factory CylinderSet.fromBuffer($core.List<$core.int> i, [$pb.ExtensionRegistry r = $pb.ExtensionRegistry.EMPTY]) => create()..mergeFromBuffer(i, r);
  factory CylinderSet.fromJson($core.String i, [$pb.ExtensionRegistry r = $pb.ExtensionRegistry.EMPTY]) => create()..mergeFromJson(i, r);
  @$core.Deprecated(
  'Using this can add significant overhead to your binary. '
  'Use [GeneratedMessageGenericExtensions.deepCopy] instead. '
  'Will be removed in next major version')
  CylinderSet clone() => CylinderSet()..mergeFromMessage(this);
  @$core.Deprecated(
  'Using this can add significant overhead to your binary. '
  'Use [GeneratedMessageGenericExtensions.rebuild] instead. '
  'Will be removed in next major version')
  CylinderSet copyWith(void Function(CylinderSet) updates) => super.copyWith((message) => updates(message as CylinderSet)); // ignore: deprecated_member_use
  $pb.BuilderInfo get info_ => _i;
  @$core.pragma('dart2js:noInline')
  static CylinderSet create() => CylinderSet._();
  CylinderSet createEmptyInstance() => create();
  static $pb.PbList<CylinderSet> createRepeated() => $pb.PbList<CylinderSet>();
  @$core.pragma('dart2js:noInline')
  static CylinderSet getDefault() => _defaultInstance ??= $pb.GeneratedMessage.$_defaultFor<CylinderSet>(create);
  static CylinderSet _defaultInstance;

  @$pb.TagNumber(1)
  $core.List<CylinderData> get cylinders => $_getList(0);
}

class CylinderData extends $pb.GeneratedMessage {
  static final $pb.BuilderInfo _i = $pb.BuilderInfo(const $core.bool.fromEnvironment('protobuf.omit_message_names') ? '' : 'CylinderData', createEmptyInstance: create)
    ..aOS(1, const $core.bool.fromEnvironment('protobuf.omit_field_names') ? '' : 'id')
    ..aOS(2, const $core.bool.fromEnvironment('protobuf.omit_field_names') ? '' : 'name')
    ..e<Metal>(3, const $core.bool.fromEnvironment('protobuf.omit_field_names') ? '' : 'metal', $pb.PbFieldType.OE, defaultOrMaker: Metal.STEEL, valueOf: Metal.valueOf, enumValues: Metal.values)
    ..e<MeasurementSystem>(4, const $core.bool.fromEnvironment('protobuf.omit_field_names') ? '' : 'measurements', $pb.PbFieldType.OE, defaultOrMaker: MeasurementSystem.METRIC, valueOf: MeasurementSystem.valueOf, enumValues: MeasurementSystem.values)
    ..a<$core.double>(5, const $core.bool.fromEnvironment('protobuf.omit_field_names') ? '' : 'volume', $pb.PbFieldType.OD)
    ..a<$core.int>(6, const $core.bool.fromEnvironment('protobuf.omit_field_names') ? '' : 'workingPressure', $pb.PbFieldType.O3)
    ..a<$core.double>(7, const $core.bool.fromEnvironment('protobuf.omit_field_names') ? '' : 'weight', $pb.PbFieldType.OD)
    ..aOB(8, const $core.bool.fromEnvironment('protobuf.omit_field_names') ? '' : 'twinset')
    ..aOB(9, const $core.bool.fromEnvironment('protobuf.omit_field_names') ? '' : 'selected')
    ..hasRequiredFields = false
  ;

  CylinderData._() : super();
  factory CylinderData() => create();
  factory CylinderData.fromBuffer($core.List<$core.int> i, [$pb.ExtensionRegistry r = $pb.ExtensionRegistry.EMPTY]) => create()..mergeFromBuffer(i, r);
  factory CylinderData.fromJson($core.String i, [$pb.ExtensionRegistry r = $pb.ExtensionRegistry.EMPTY]) => create()..mergeFromJson(i, r);
  @$core.Deprecated(
  'Using this can add significant overhead to your binary. '
  'Use [GeneratedMessageGenericExtensions.deepCopy] instead. '
  'Will be removed in next major version')
  CylinderData clone() => CylinderData()..mergeFromMessage(this);
  @$core.Deprecated(
  'Using this can add significant overhead to your binary. '
  'Use [GeneratedMessageGenericExtensions.rebuild] instead. '
  'Will be removed in next major version')
  CylinderData copyWith(void Function(CylinderData) updates) => super.copyWith((message) => updates(message as CylinderData)); // ignore: deprecated_member_use
  $pb.BuilderInfo get info_ => _i;
  @$core.pragma('dart2js:noInline')
  static CylinderData create() => CylinderData._();
  CylinderData createEmptyInstance() => create();
  static $pb.PbList<CylinderData> createRepeated() => $pb.PbList<CylinderData>();
  @$core.pragma('dart2js:noInline')
  static CylinderData getDefault() => _defaultInstance ??= $pb.GeneratedMessage.$_defaultFor<CylinderData>(create);
  static CylinderData _defaultInstance;

  @$pb.TagNumber(1)
  $core.String get id => $_getSZ(0);
  @$pb.TagNumber(1)
  set id($core.String v) { $_setString(0, v); }
  @$pb.TagNumber(1)
  $core.bool hasId() => $_has(0);
  @$pb.TagNumber(1)
  void clearId() => clearField(1);

  @$pb.TagNumber(2)
  $core.String get name => $_getSZ(1);
  @$pb.TagNumber(2)
  set name($core.String v) { $_setString(1, v); }
  @$pb.TagNumber(2)
  $core.bool hasName() => $_has(1);
  @$pb.TagNumber(2)
  void clearName() => clearField(2);

  @$pb.TagNumber(3)
  Metal get metal => $_getN(2);
  @$pb.TagNumber(3)
  set metal(Metal v) { setField(3, v); }
  @$pb.TagNumber(3)
  $core.bool hasMetal() => $_has(2);
  @$pb.TagNumber(3)
  void clearMetal() => clearField(3);

  @$pb.TagNumber(4)
  MeasurementSystem get measurements => $_getN(3);
  @$pb.TagNumber(4)
  set measurements(MeasurementSystem v) { setField(4, v); }
  @$pb.TagNumber(4)
  $core.bool hasMeasurements() => $_has(3);
  @$pb.TagNumber(4)
  void clearMeasurements() => clearField(4);

  @$pb.TagNumber(5)
  $core.double get volume => $_getN(4);
  @$pb.TagNumber(5)
  set volume($core.double v) { $_setDouble(4, v); }
  @$pb.TagNumber(5)
  $core.bool hasVolume() => $_has(4);
  @$pb.TagNumber(5)
  void clearVolume() => clearField(5);

  @$pb.TagNumber(6)
  $core.int get workingPressure => $_getIZ(5);
  @$pb.TagNumber(6)
  set workingPressure($core.int v) { $_setSignedInt32(5, v); }
  @$pb.TagNumber(6)
  $core.bool hasWorkingPressure() => $_has(5);
  @$pb.TagNumber(6)
  void clearWorkingPressure() => clearField(6);

  @$pb.TagNumber(7)
  $core.double get weight => $_getN(6);
  @$pb.TagNumber(7)
  set weight($core.double v) { $_setDouble(6, v); }
  @$pb.TagNumber(7)
  $core.bool hasWeight() => $_has(6);
  @$pb.TagNumber(7)
  void clearWeight() => clearField(7);

  @$pb.TagNumber(8)
  $core.bool get twinset => $_getBF(7);
  @$pb.TagNumber(8)
  set twinset($core.bool v) { $_setBool(7, v); }
  @$pb.TagNumber(8)
  $core.bool hasTwinset() => $_has(7);
  @$pb.TagNumber(8)
  void clearTwinset() => clearField(8);

  @$pb.TagNumber(9)
  $core.bool get selected => $_getBF(8);
  @$pb.TagNumber(9)
  set selected($core.bool v) { $_setBool(8, v); }
  @$pb.TagNumber(9)
  $core.bool hasSelected() => $_has(8);
  @$pb.TagNumber(9)
  void clearSelected() => clearField(9);
}

class SettingsData extends $pb.GeneratedMessage {
  static final $pb.BuilderInfo _i = $pb.BuilderInfo(const $core.bool.fromEnvironment('protobuf.omit_message_names') ? '' : 'SettingsData', createEmptyInstance: create)
    ..e<MeasurementSystem>(1, const $core.bool.fromEnvironment('protobuf.omit_field_names') ? '' : 'measurements', $pb.PbFieldType.OE, defaultOrMaker: MeasurementSystem.METRIC, valueOf: MeasurementSystem.valueOf, enumValues: MeasurementSystem.values)
    ..aOM<MeasurementDependentSettingsData>(2, const $core.bool.fromEnvironment('protobuf.omit_field_names') ? '' : 'metric', subBuilder: MeasurementDependentSettingsData.create)
    ..aOM<MeasurementDependentSettingsData>(3, const $core.bool.fromEnvironment('protobuf.omit_field_names') ? '' : 'imperial', subBuilder: MeasurementDependentSettingsData.create)
    ..a<$core.double>(4, const $core.bool.fromEnvironment('protobuf.omit_field_names') ? '' : 'troubleSolvingDuration', $pb.PbFieldType.OD)
    ..a<$core.double>(5, const $core.bool.fromEnvironment('protobuf.omit_field_names') ? '' : 'troubleSolvingSacMultiplier', $pb.PbFieldType.OD)
    ..a<$core.double>(6, const $core.bool.fromEnvironment('protobuf.omit_field_names') ? '' : 'ascentSacMultiplier', $pb.PbFieldType.OD)
    ..a<$core.double>(7, const $core.bool.fromEnvironment('protobuf.omit_field_names') ? '' : 'safetyStopDuration', $pb.PbFieldType.OD)
    ..a<$core.double>(8, const $core.bool.fromEnvironment('protobuf.omit_field_names') ? '' : 'safetyStopSacMultiplier', $pb.PbFieldType.OD)
    ..hasRequiredFields = false
  ;

  SettingsData._() : super();
  factory SettingsData() => create();
  factory SettingsData.fromBuffer($core.List<$core.int> i, [$pb.ExtensionRegistry r = $pb.ExtensionRegistry.EMPTY]) => create()..mergeFromBuffer(i, r);
  factory SettingsData.fromJson($core.String i, [$pb.ExtensionRegistry r = $pb.ExtensionRegistry.EMPTY]) => create()..mergeFromJson(i, r);
  @$core.Deprecated(
  'Using this can add significant overhead to your binary. '
  'Use [GeneratedMessageGenericExtensions.deepCopy] instead. '
  'Will be removed in next major version')
  SettingsData clone() => SettingsData()..mergeFromMessage(this);
  @$core.Deprecated(
  'Using this can add significant overhead to your binary. '
  'Use [GeneratedMessageGenericExtensions.rebuild] instead. '
  'Will be removed in next major version')
  SettingsData copyWith(void Function(SettingsData) updates) => super.copyWith((message) => updates(message as SettingsData)); // ignore: deprecated_member_use
  $pb.BuilderInfo get info_ => _i;
  @$core.pragma('dart2js:noInline')
  static SettingsData create() => SettingsData._();
  SettingsData createEmptyInstance() => create();
  static $pb.PbList<SettingsData> createRepeated() => $pb.PbList<SettingsData>();
  @$core.pragma('dart2js:noInline')
  static SettingsData getDefault() => _defaultInstance ??= $pb.GeneratedMessage.$_defaultFor<SettingsData>(create);
  static SettingsData _defaultInstance;

  @$pb.TagNumber(1)
  MeasurementSystem get measurements => $_getN(0);
  @$pb.TagNumber(1)
  set measurements(MeasurementSystem v) { setField(1, v); }
  @$pb.TagNumber(1)
  $core.bool hasMeasurements() => $_has(0);
  @$pb.TagNumber(1)
  void clearMeasurements() => clearField(1);

  @$pb.TagNumber(2)
  MeasurementDependentSettingsData get metric => $_getN(1);
  @$pb.TagNumber(2)
  set metric(MeasurementDependentSettingsData v) { setField(2, v); }
  @$pb.TagNumber(2)
  $core.bool hasMetric() => $_has(1);
  @$pb.TagNumber(2)
  void clearMetric() => clearField(2);
  @$pb.TagNumber(2)
  MeasurementDependentSettingsData ensureMetric() => $_ensure(1);

  @$pb.TagNumber(3)
  MeasurementDependentSettingsData get imperial => $_getN(2);
  @$pb.TagNumber(3)
  set imperial(MeasurementDependentSettingsData v) { setField(3, v); }
  @$pb.TagNumber(3)
  $core.bool hasImperial() => $_has(2);
  @$pb.TagNumber(3)
  void clearImperial() => clearField(3);
  @$pb.TagNumber(3)
  MeasurementDependentSettingsData ensureImperial() => $_ensure(2);

  @$pb.TagNumber(4)
  $core.double get troubleSolvingDuration => $_getN(3);
  @$pb.TagNumber(4)
  set troubleSolvingDuration($core.double v) { $_setDouble(3, v); }
  @$pb.TagNumber(4)
  $core.bool hasTroubleSolvingDuration() => $_has(3);
  @$pb.TagNumber(4)
  void clearTroubleSolvingDuration() => clearField(4);

  @$pb.TagNumber(5)
  $core.double get troubleSolvingSacMultiplier => $_getN(4);
  @$pb.TagNumber(5)
  set troubleSolvingSacMultiplier($core.double v) { $_setDouble(4, v); }
  @$pb.TagNumber(5)
  $core.bool hasTroubleSolvingSacMultiplier() => $_has(4);
  @$pb.TagNumber(5)
  void clearTroubleSolvingSacMultiplier() => clearField(5);

  @$pb.TagNumber(6)
  $core.double get ascentSacMultiplier => $_getN(5);
  @$pb.TagNumber(6)
  set ascentSacMultiplier($core.double v) { $_setDouble(5, v); }
  @$pb.TagNumber(6)
  $core.bool hasAscentSacMultiplier() => $_has(5);
  @$pb.TagNumber(6)
  void clearAscentSacMultiplier() => clearField(6);

  @$pb.TagNumber(7)
  $core.double get safetyStopDuration => $_getN(6);
  @$pb.TagNumber(7)
  set safetyStopDuration($core.double v) { $_setDouble(6, v); }
  @$pb.TagNumber(7)
  $core.bool hasSafetyStopDuration() => $_has(6);
  @$pb.TagNumber(7)
  void clearSafetyStopDuration() => clearField(7);

  @$pb.TagNumber(8)
  $core.double get safetyStopSacMultiplier => $_getN(7);
  @$pb.TagNumber(8)
  set safetyStopSacMultiplier($core.double v) { $_setDouble(7, v); }
  @$pb.TagNumber(8)
  $core.bool hasSafetyStopSacMultiplier() => $_has(7);
  @$pb.TagNumber(8)
  void clearSafetyStopSacMultiplier() => clearField(8);
}

class MeasurementDependentSettingsData extends $pb.GeneratedMessage {
  static final $pb.BuilderInfo _i = $pb.BuilderInfo(const $core.bool.fromEnvironment('protobuf.omit_message_names') ? '' : 'MeasurementDependentSettingsData', createEmptyInstance: create)
    ..a<$core.double>(1, const $core.bool.fromEnvironment('protobuf.omit_field_names') ? '' : 'sacRate', $pb.PbFieldType.OD)
    ..a<$core.double>(2, const $core.bool.fromEnvironment('protobuf.omit_field_names') ? '' : 'ascentRate', $pb.PbFieldType.OD)
    ..a<$core.double>(3, const $core.bool.fromEnvironment('protobuf.omit_field_names') ? '' : 'safetyStopDepth', $pb.PbFieldType.OD)
    ..a<$core.int>(4, const $core.bool.fromEnvironment('protobuf.omit_field_names') ? '' : 'minPressure', $pb.PbFieldType.O3)
    ..a<$core.int>(5, const $core.bool.fromEnvironment('protobuf.omit_field_names') ? '' : 'maxPressure', $pb.PbFieldType.O3)
    ..a<$core.int>(6, const $core.bool.fromEnvironment('protobuf.omit_field_names') ? '' : 'pressureStep', $pb.PbFieldType.O3)
    ..a<$core.int>(7, const $core.bool.fromEnvironment('protobuf.omit_field_names') ? '' : 'minDepth', $pb.PbFieldType.O3)
    ..a<$core.int>(8, const $core.bool.fromEnvironment('protobuf.omit_field_names') ? '' : 'maxDepth', $pb.PbFieldType.O3)
    ..hasRequiredFields = false
  ;

  MeasurementDependentSettingsData._() : super();
  factory MeasurementDependentSettingsData() => create();
  factory MeasurementDependentSettingsData.fromBuffer($core.List<$core.int> i, [$pb.ExtensionRegistry r = $pb.ExtensionRegistry.EMPTY]) => create()..mergeFromBuffer(i, r);
  factory MeasurementDependentSettingsData.fromJson($core.String i, [$pb.ExtensionRegistry r = $pb.ExtensionRegistry.EMPTY]) => create()..mergeFromJson(i, r);
  @$core.Deprecated(
  'Using this can add significant overhead to your binary. '
  'Use [GeneratedMessageGenericExtensions.deepCopy] instead. '
  'Will be removed in next major version')
  MeasurementDependentSettingsData clone() => MeasurementDependentSettingsData()..mergeFromMessage(this);
  @$core.Deprecated(
  'Using this can add significant overhead to your binary. '
  'Use [GeneratedMessageGenericExtensions.rebuild] instead. '
  'Will be removed in next major version')
  MeasurementDependentSettingsData copyWith(void Function(MeasurementDependentSettingsData) updates) => super.copyWith((message) => updates(message as MeasurementDependentSettingsData)); // ignore: deprecated_member_use
  $pb.BuilderInfo get info_ => _i;
  @$core.pragma('dart2js:noInline')
  static MeasurementDependentSettingsData create() => MeasurementDependentSettingsData._();
  MeasurementDependentSettingsData createEmptyInstance() => create();
  static $pb.PbList<MeasurementDependentSettingsData> createRepeated() => $pb.PbList<MeasurementDependentSettingsData>();
  @$core.pragma('dart2js:noInline')
  static MeasurementDependentSettingsData getDefault() => _defaultInstance ??= $pb.GeneratedMessage.$_defaultFor<MeasurementDependentSettingsData>(create);
  static MeasurementDependentSettingsData _defaultInstance;

  @$pb.TagNumber(1)
  $core.double get sacRate => $_getN(0);
  @$pb.TagNumber(1)
  set sacRate($core.double v) { $_setDouble(0, v); }
  @$pb.TagNumber(1)
  $core.bool hasSacRate() => $_has(0);
  @$pb.TagNumber(1)
  void clearSacRate() => clearField(1);

  @$pb.TagNumber(2)
  $core.double get ascentRate => $_getN(1);
  @$pb.TagNumber(2)
  set ascentRate($core.double v) { $_setDouble(1, v); }
  @$pb.TagNumber(2)
  $core.bool hasAscentRate() => $_has(1);
  @$pb.TagNumber(2)
  void clearAscentRate() => clearField(2);

  @$pb.TagNumber(3)
  $core.double get safetyStopDepth => $_getN(2);
  @$pb.TagNumber(3)
  set safetyStopDepth($core.double v) { $_setDouble(2, v); }
  @$pb.TagNumber(3)
  $core.bool hasSafetyStopDepth() => $_has(2);
  @$pb.TagNumber(3)
  void clearSafetyStopDepth() => clearField(3);

  @$pb.TagNumber(4)
  $core.int get minPressure => $_getIZ(3);
  @$pb.TagNumber(4)
  set minPressure($core.int v) { $_setSignedInt32(3, v); }
  @$pb.TagNumber(4)
  $core.bool hasMinPressure() => $_has(3);
  @$pb.TagNumber(4)
  void clearMinPressure() => clearField(4);

  @$pb.TagNumber(5)
  $core.int get maxPressure => $_getIZ(4);
  @$pb.TagNumber(5)
  set maxPressure($core.int v) { $_setSignedInt32(4, v); }
  @$pb.TagNumber(5)
  $core.bool hasMaxPressure() => $_has(4);
  @$pb.TagNumber(5)
  void clearMaxPressure() => clearField(5);

  @$pb.TagNumber(6)
  $core.int get pressureStep => $_getIZ(5);
  @$pb.TagNumber(6)
  set pressureStep($core.int v) { $_setSignedInt32(5, v); }
  @$pb.TagNumber(6)
  $core.bool hasPressureStep() => $_has(5);
  @$pb.TagNumber(6)
  void clearPressureStep() => clearField(6);

  @$pb.TagNumber(7)
  $core.int get minDepth => $_getIZ(6);
  @$pb.TagNumber(7)
  set minDepth($core.int v) { $_setSignedInt32(6, v); }
  @$pb.TagNumber(7)
  $core.bool hasMinDepth() => $_has(6);
  @$pb.TagNumber(7)
  void clearMinDepth() => clearField(7);

  @$pb.TagNumber(8)
  $core.int get maxDepth => $_getIZ(7);
  @$pb.TagNumber(8)
  set maxDepth($core.int v) { $_setSignedInt32(7, v); }
  @$pb.TagNumber(8)
  $core.bool hasMaxDepth() => $_has(7);
  @$pb.TagNumber(8)
  void clearMaxDepth() => clearField(8);
}

