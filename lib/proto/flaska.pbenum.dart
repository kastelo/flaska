//
//  Generated code. Do not modify.
//  source: flaska.proto
//
// @dart = 2.12

// ignore_for_file: annotate_overrides, camel_case_types
// ignore_for_file: constant_identifier_names, library_prefixes
// ignore_for_file: non_constant_identifier_names, prefer_final_fields
// ignore_for_file: unnecessary_import, unnecessary_this, unused_import

import 'dart:core' as $core;

import 'package:protobuf/protobuf.dart' as $pb;

class MeasurementSystem extends $pb.ProtobufEnum {
  static const MeasurementSystem METRIC = MeasurementSystem._(0, _omitEnumNames ? '' : 'METRIC');
  static const MeasurementSystem IMPERIAL = MeasurementSystem._(1, _omitEnumNames ? '' : 'IMPERIAL');

  static const $core.List<MeasurementSystem> values = <MeasurementSystem> [
    METRIC,
    IMPERIAL,
  ];

  static final $core.Map<$core.int, MeasurementSystem> _byValue = $pb.ProtobufEnum.initByValue(values);
  static MeasurementSystem? valueOf($core.int value) => _byValue[value];

  const MeasurementSystem._($core.int v, $core.String n) : super(v, n);
}

class Metal extends $pb.ProtobufEnum {
  static const Metal STEEL = Metal._(0, _omitEnumNames ? '' : 'STEEL');
  static const Metal ALUMINIUM = Metal._(1, _omitEnumNames ? '' : 'ALUMINIUM');

  static const $core.List<Metal> values = <Metal> [
    STEEL,
    ALUMINIUM,
  ];

  static final $core.Map<$core.int, Metal> _byValue = $pb.ProtobufEnum.initByValue(values);
  static Metal? valueOf($core.int value) => _byValue[value];

  const Metal._($core.int v, $core.String n) : super(v, n);
}

class ThemeColor extends $pb.ProtobufEnum {
  static const ThemeColor BLUE = ThemeColor._(0, _omitEnumNames ? '' : 'BLUE');
  static const ThemeColor PINK = ThemeColor._(1, _omitEnumNames ? '' : 'PINK');
  static const ThemeColor GREEN = ThemeColor._(2, _omitEnumNames ? '' : 'GREEN');
  static const ThemeColor ORANGE = ThemeColor._(3, _omitEnumNames ? '' : 'ORANGE');
  static const ThemeColor PURPLE = ThemeColor._(4, _omitEnumNames ? '' : 'PURPLE');

  static const $core.List<ThemeColor> values = <ThemeColor> [
    BLUE,
    PINK,
    GREEN,
    ORANGE,
    PURPLE,
  ];

  static final $core.Map<$core.int, ThemeColor> _byValue = $pb.ProtobufEnum.initByValue(values);
  static ThemeColor? valueOf($core.int value) => _byValue[value];

  const ThemeColor._($core.int v, $core.String n) : super(v, n);
}

class Principles extends $pb.ProtobufEnum {
  static const Principles ROCKBOTTOM = Principles._(0, _omitEnumNames ? '' : 'ROCKBOTTOM');
  static const Principles MINGAS = Principles._(1, _omitEnumNames ? '' : 'MINGAS');

  static const $core.List<Principles> values = <Principles> [
    ROCKBOTTOM,
    MINGAS,
  ];

  static final $core.Map<$core.int, Principles> _byValue = $pb.ProtobufEnum.initByValue(values);
  static Principles? valueOf($core.int value) => _byValue[value];

  const Principles._($core.int v, $core.String n) : super(v, n);
}

class UsableGas extends $pb.ProtobufEnum {
  static const UsableGas ALL_USABLE = UsableGas._(0, _omitEnumNames ? '' : 'ALL_USABLE');
  static const UsableGas HALVES = UsableGas._(1, _omitEnumNames ? '' : 'HALVES');
  static const UsableGas THIRDS = UsableGas._(2, _omitEnumNames ? '' : 'THIRDS');

  static const $core.List<UsableGas> values = <UsableGas> [
    ALL_USABLE,
    HALVES,
    THIRDS,
  ];

  static final $core.Map<$core.int, UsableGas> _byValue = $pb.ProtobufEnum.initByValue(values);
  static UsableGas? valueOf($core.int value) => _byValue[value];

  const UsableGas._($core.int v, $core.String n) : super(v, n);
}


const _omitEnumNames = $core.bool.fromEnvironment('protobuf.omit_enum_names');
