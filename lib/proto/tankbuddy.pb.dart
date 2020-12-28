///
//  Generated code. Do not modify.
//  source: tankbuddy.proto
//
// @dart = 2.3
// ignore_for_file: annotate_overrides,camel_case_types,unnecessary_const,non_constant_identifier_names,library_prefixes,unused_import,unused_shown_name,return_of_invalid_type,unnecessary_this,prefer_final_fields

import 'dart:core' as $core;

import 'package:protobuf/protobuf.dart' as $pb;

import 'tankbuddy.pbenum.dart';

export 'tankbuddy.pbenum.dart';

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
    ..aOS(1, const $core.bool.fromEnvironment('protobuf.omit_field_names') ? '' : 'name')
    ..e<Metal>(2, const $core.bool.fromEnvironment('protobuf.omit_field_names') ? '' : 'metal', $pb.PbFieldType.OE, defaultOrMaker: Metal.STEEL, valueOf: Metal.valueOf, enumValues: Metal.values)
    ..e<MeasurementSystem>(3, const $core.bool.fromEnvironment('protobuf.omit_field_names') ? '' : 'measurements', $pb.PbFieldType.OE, defaultOrMaker: MeasurementSystem.METRIC, valueOf: MeasurementSystem.valueOf, enumValues: MeasurementSystem.values)
    ..a<$core.double>(4, const $core.bool.fromEnvironment('protobuf.omit_field_names') ? '' : 'volume', $pb.PbFieldType.OD)
    ..a<$core.double>(5, const $core.bool.fromEnvironment('protobuf.omit_field_names') ? '' : 'workingPressure', $pb.PbFieldType.OD)
    ..a<$core.double>(6, const $core.bool.fromEnvironment('protobuf.omit_field_names') ? '' : 'weight', $pb.PbFieldType.OD)
    ..aOB(7, const $core.bool.fromEnvironment('protobuf.omit_field_names') ? '' : 'selected')
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
  $core.String get name => $_getSZ(0);
  @$pb.TagNumber(1)
  set name($core.String v) { $_setString(0, v); }
  @$pb.TagNumber(1)
  $core.bool hasName() => $_has(0);
  @$pb.TagNumber(1)
  void clearName() => clearField(1);

  @$pb.TagNumber(2)
  Metal get metal => $_getN(1);
  @$pb.TagNumber(2)
  set metal(Metal v) { setField(2, v); }
  @$pb.TagNumber(2)
  $core.bool hasMetal() => $_has(1);
  @$pb.TagNumber(2)
  void clearMetal() => clearField(2);

  @$pb.TagNumber(3)
  MeasurementSystem get measurements => $_getN(2);
  @$pb.TagNumber(3)
  set measurements(MeasurementSystem v) { setField(3, v); }
  @$pb.TagNumber(3)
  $core.bool hasMeasurements() => $_has(2);
  @$pb.TagNumber(3)
  void clearMeasurements() => clearField(3);

  @$pb.TagNumber(4)
  $core.double get volume => $_getN(3);
  @$pb.TagNumber(4)
  set volume($core.double v) { $_setDouble(3, v); }
  @$pb.TagNumber(4)
  $core.bool hasVolume() => $_has(3);
  @$pb.TagNumber(4)
  void clearVolume() => clearField(4);

  @$pb.TagNumber(5)
  $core.double get workingPressure => $_getN(4);
  @$pb.TagNumber(5)
  set workingPressure($core.double v) { $_setDouble(4, v); }
  @$pb.TagNumber(5)
  $core.bool hasWorkingPressure() => $_has(4);
  @$pb.TagNumber(5)
  void clearWorkingPressure() => clearField(5);

  @$pb.TagNumber(6)
  $core.double get weight => $_getN(5);
  @$pb.TagNumber(6)
  set weight($core.double v) { $_setDouble(5, v); }
  @$pb.TagNumber(6)
  $core.bool hasWeight() => $_has(5);
  @$pb.TagNumber(6)
  void clearWeight() => clearField(6);

  @$pb.TagNumber(7)
  $core.bool get selected => $_getBF(6);
  @$pb.TagNumber(7)
  set selected($core.bool v) { $_setBool(6, v); }
  @$pb.TagNumber(7)
  $core.bool hasSelected() => $_has(6);
  @$pb.TagNumber(7)
  void clearSelected() => clearField(7);
}

