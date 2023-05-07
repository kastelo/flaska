///
//  Generated code. Do not modify.
//  source: flaska.proto
//
// @dart = 2.12
// ignore_for_file: annotate_overrides,camel_case_types,constant_identifier_names,directives_ordering,library_prefixes,non_constant_identifier_names,prefer_final_fields,return_of_invalid_type,unnecessary_const,unnecessary_import,unnecessary_this,unused_import,unused_shown_name

// ignore_for_file: UNDEFINED_SHOWN_NAME
import 'dart:core' as $core;
import 'package:protobuf/protobuf.dart' as $pb;

class MeasurementSystem extends $pb.ProtobufEnum {
  static const MeasurementSystem METRIC = MeasurementSystem._(0, const $core.bool.fromEnvironment('protobuf.omit_enum_names') ? '' : 'METRIC');
  static const MeasurementSystem IMPERIAL = MeasurementSystem._(1, const $core.bool.fromEnvironment('protobuf.omit_enum_names') ? '' : 'IMPERIAL');

  static const $core.List<MeasurementSystem> values = <MeasurementSystem> [
    METRIC,
    IMPERIAL,
  ];

  static final $core.Map<$core.int, MeasurementSystem> _byValue = $pb.ProtobufEnum.initByValue(values);
  static MeasurementSystem? valueOf($core.int value) => _byValue[value];

  const MeasurementSystem._($core.int v, $core.String n) : super(v, n);
}

class Metal extends $pb.ProtobufEnum {
  static const Metal STEEL = Metal._(0, const $core.bool.fromEnvironment('protobuf.omit_enum_names') ? '' : 'STEEL');
  static const Metal ALUMINIUM = Metal._(1, const $core.bool.fromEnvironment('protobuf.omit_enum_names') ? '' : 'ALUMINIUM');

  static const $core.List<Metal> values = <Metal> [
    STEEL,
    ALUMINIUM,
  ];

  static final $core.Map<$core.int, Metal> _byValue = $pb.ProtobufEnum.initByValue(values);
  static Metal? valueOf($core.int value) => _byValue[value];

  const Metal._($core.int v, $core.String n) : super(v, n);
}

