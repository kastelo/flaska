///
//  Generated code. Do not modify.
//  source: flaska.proto
//
// @dart = 2.12
// ignore_for_file: annotate_overrides,camel_case_types,constant_identifier_names,directives_ordering,library_prefixes,non_constant_identifier_names,prefer_final_fields,return_of_invalid_type,unnecessary_const,unnecessary_import,unnecessary_this,unused_import,unused_shown_name

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
  factory CylinderSet({
    $core.Iterable<CylinderData>? cylinders,
  }) {
    final _result = create();
    if (cylinders != null) {
      _result.cylinders.addAll(cylinders);
    }
    return _result;
  }
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
  CylinderSet copyWith(void Function(CylinderSet) updates) => super.copyWith((message) => updates(message as CylinderSet)) as CylinderSet; // ignore: deprecated_member_use
  $pb.BuilderInfo get info_ => _i;
  @$core.pragma('dart2js:noInline')
  static CylinderSet create() => CylinderSet._();
  CylinderSet createEmptyInstance() => create();
  static $pb.PbList<CylinderSet> createRepeated() => $pb.PbList<CylinderSet>();
  @$core.pragma('dart2js:noInline')
  static CylinderSet getDefault() => _defaultInstance ??= $pb.GeneratedMessage.$_defaultFor<CylinderSet>(create);
  static CylinderSet? _defaultInstance;

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
    ..aOB(10, const $core.bool.fromEnvironment('protobuf.omit_field_names') ? '' : 'overfill')
    ..hasRequiredFields = false
  ;

  CylinderData._() : super();
  factory CylinderData({
    $core.String? id,
    $core.String? name,
    Metal? metal,
    MeasurementSystem? measurements,
    $core.double? volume,
    $core.int? workingPressure,
    $core.double? weight,
    $core.bool? twinset,
    $core.bool? selected,
    $core.bool? overfill,
  }) {
    final _result = create();
    if (id != null) {
      _result.id = id;
    }
    if (name != null) {
      _result.name = name;
    }
    if (metal != null) {
      _result.metal = metal;
    }
    if (measurements != null) {
      _result.measurements = measurements;
    }
    if (volume != null) {
      _result.volume = volume;
    }
    if (workingPressure != null) {
      _result.workingPressure = workingPressure;
    }
    if (weight != null) {
      _result.weight = weight;
    }
    if (twinset != null) {
      _result.twinset = twinset;
    }
    if (selected != null) {
      _result.selected = selected;
    }
    if (overfill != null) {
      _result.overfill = overfill;
    }
    return _result;
  }
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
  CylinderData copyWith(void Function(CylinderData) updates) => super.copyWith((message) => updates(message as CylinderData)) as CylinderData; // ignore: deprecated_member_use
  $pb.BuilderInfo get info_ => _i;
  @$core.pragma('dart2js:noInline')
  static CylinderData create() => CylinderData._();
  CylinderData createEmptyInstance() => create();
  static $pb.PbList<CylinderData> createRepeated() => $pb.PbList<CylinderData>();
  @$core.pragma('dart2js:noInline')
  static CylinderData getDefault() => _defaultInstance ??= $pb.GeneratedMessage.$_defaultFor<CylinderData>(create);
  static CylinderData? _defaultInstance;

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

  @$pb.TagNumber(10)
  $core.bool get overfill => $_getBF(9);
  @$pb.TagNumber(10)
  set overfill($core.bool v) { $_setBool(9, v); }
  @$pb.TagNumber(10)
  $core.bool hasOverfill() => $_has(9);
  @$pb.TagNumber(10)
  void clearOverfill() => clearField(10);
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
    ..aOB(9, const $core.bool.fromEnvironment('protobuf.omit_field_names') ? '' : 'hideNdlNotice')
    ..e<ThemeColor>(10, const $core.bool.fromEnvironment('protobuf.omit_field_names') ? '' : 'themeColor', $pb.PbFieldType.OE, defaultOrMaker: ThemeColor.BLUE, valueOf: ThemeColor.valueOf, enumValues: ThemeColor.values)
    ..hasRequiredFields = false
  ;

  SettingsData._() : super();
  factory SettingsData({
    MeasurementSystem? measurements,
    MeasurementDependentSettingsData? metric,
    MeasurementDependentSettingsData? imperial,
    $core.double? troubleSolvingDuration,
    $core.double? troubleSolvingSacMultiplier,
    $core.double? ascentSacMultiplier,
    $core.double? safetyStopDuration,
    $core.double? safetyStopSacMultiplier,
    $core.bool? hideNdlNotice,
    ThemeColor? themeColor,
  }) {
    final _result = create();
    if (measurements != null) {
      _result.measurements = measurements;
    }
    if (metric != null) {
      _result.metric = metric;
    }
    if (imperial != null) {
      _result.imperial = imperial;
    }
    if (troubleSolvingDuration != null) {
      _result.troubleSolvingDuration = troubleSolvingDuration;
    }
    if (troubleSolvingSacMultiplier != null) {
      _result.troubleSolvingSacMultiplier = troubleSolvingSacMultiplier;
    }
    if (ascentSacMultiplier != null) {
      _result.ascentSacMultiplier = ascentSacMultiplier;
    }
    if (safetyStopDuration != null) {
      _result.safetyStopDuration = safetyStopDuration;
    }
    if (safetyStopSacMultiplier != null) {
      _result.safetyStopSacMultiplier = safetyStopSacMultiplier;
    }
    if (hideNdlNotice != null) {
      _result.hideNdlNotice = hideNdlNotice;
    }
    if (themeColor != null) {
      _result.themeColor = themeColor;
    }
    return _result;
  }
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
  SettingsData copyWith(void Function(SettingsData) updates) => super.copyWith((message) => updates(message as SettingsData)) as SettingsData; // ignore: deprecated_member_use
  $pb.BuilderInfo get info_ => _i;
  @$core.pragma('dart2js:noInline')
  static SettingsData create() => SettingsData._();
  SettingsData createEmptyInstance() => create();
  static $pb.PbList<SettingsData> createRepeated() => $pb.PbList<SettingsData>();
  @$core.pragma('dart2js:noInline')
  static SettingsData getDefault() => _defaultInstance ??= $pb.GeneratedMessage.$_defaultFor<SettingsData>(create);
  static SettingsData? _defaultInstance;

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

  @$pb.TagNumber(9)
  $core.bool get hideNdlNotice => $_getBF(8);
  @$pb.TagNumber(9)
  set hideNdlNotice($core.bool v) { $_setBool(8, v); }
  @$pb.TagNumber(9)
  $core.bool hasHideNdlNotice() => $_has(8);
  @$pb.TagNumber(9)
  void clearHideNdlNotice() => clearField(9);

  @$pb.TagNumber(10)
  ThemeColor get themeColor => $_getN(9);
  @$pb.TagNumber(10)
  set themeColor(ThemeColor v) { setField(10, v); }
  @$pb.TagNumber(10)
  $core.bool hasThemeColor() => $_has(9);
  @$pb.TagNumber(10)
  void clearThemeColor() => clearField(10);
}

class MeasurementDependentSettingsData extends $pb.GeneratedMessage {
  static final $pb.BuilderInfo _i = $pb.BuilderInfo(const $core.bool.fromEnvironment('protobuf.omit_message_names') ? '' : 'MeasurementDependentSettingsData', createEmptyInstance: create)
    ..a<$core.double>(1, const $core.bool.fromEnvironment('protobuf.omit_field_names') ? '' : 'sacRate', $pb.PbFieldType.OD)
    ..a<$core.double>(3, const $core.bool.fromEnvironment('protobuf.omit_field_names') ? '' : 'safetyStopDepth', $pb.PbFieldType.OD)
    ..hasRequiredFields = false
  ;

  MeasurementDependentSettingsData._() : super();
  factory MeasurementDependentSettingsData({
    $core.double? sacRate,
    $core.double? safetyStopDepth,
  }) {
    final _result = create();
    if (sacRate != null) {
      _result.sacRate = sacRate;
    }
    if (safetyStopDepth != null) {
      _result.safetyStopDepth = safetyStopDepth;
    }
    return _result;
  }
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
  MeasurementDependentSettingsData copyWith(void Function(MeasurementDependentSettingsData) updates) => super.copyWith((message) => updates(message as MeasurementDependentSettingsData)) as MeasurementDependentSettingsData; // ignore: deprecated_member_use
  $pb.BuilderInfo get info_ => _i;
  @$core.pragma('dart2js:noInline')
  static MeasurementDependentSettingsData create() => MeasurementDependentSettingsData._();
  MeasurementDependentSettingsData createEmptyInstance() => create();
  static $pb.PbList<MeasurementDependentSettingsData> createRepeated() => $pb.PbList<MeasurementDependentSettingsData>();
  @$core.pragma('dart2js:noInline')
  static MeasurementDependentSettingsData getDefault() => _defaultInstance ??= $pb.GeneratedMessage.$_defaultFor<MeasurementDependentSettingsData>(create);
  static MeasurementDependentSettingsData? _defaultInstance;

  @$pb.TagNumber(1)
  $core.double get sacRate => $_getN(0);
  @$pb.TagNumber(1)
  set sacRate($core.double v) { $_setDouble(0, v); }
  @$pb.TagNumber(1)
  $core.bool hasSacRate() => $_has(0);
  @$pb.TagNumber(1)
  void clearSacRate() => clearField(1);

  @$pb.TagNumber(3)
  $core.double get safetyStopDepth => $_getN(1);
  @$pb.TagNumber(3)
  set safetyStopDepth($core.double v) { $_setDouble(1, v); }
  @$pb.TagNumber(3)
  $core.bool hasSafetyStopDepth() => $_has(1);
  @$pb.TagNumber(3)
  void clearSafetyStopDepth() => clearField(3);
}

