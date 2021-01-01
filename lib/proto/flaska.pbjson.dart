///
//  Generated code. Do not modify.
//  source: flaska.proto
//
// @dart = 2.3
// ignore_for_file: annotate_overrides,camel_case_types,unnecessary_const,non_constant_identifier_names,library_prefixes,unused_import,unused_shown_name,return_of_invalid_type,unnecessary_this,prefer_final_fields

const MeasurementSystem$json = const {
  '1': 'MeasurementSystem',
  '2': const [
    const {'1': 'METRIC', '2': 0},
    const {'1': 'IMPERIAL', '2': 1},
  ],
};

const Metal$json = const {
  '1': 'Metal',
  '2': const [
    const {'1': 'STEEL', '2': 0},
    const {'1': 'ALUMINIUM', '2': 1},
  ],
};

const CylinderSet$json = const {
  '1': 'CylinderSet',
  '2': const [
    const {'1': 'cylinders', '3': 1, '4': 3, '5': 11, '6': '.CylinderData', '10': 'cylinders'},
  ],
};

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
  ],
};

