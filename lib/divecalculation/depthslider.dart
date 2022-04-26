import 'dart:math';

import 'package:flaska/models/units.dart';
import 'package:flutter/material.dart';

class DepthSlider extends StatelessWidget {
  final Distance value;
  final bool metric;
  final Function(Distance) onChanged;
  final Distance minValue;
  final Distance maxValue;
  final bool gradual;

  double get _current => metric ? value.m.toDouble() : value.ft.toDouble();
  double get _min => metric ? minValue.m.toDouble() : minValue.ft.toDouble();
  double get _max => metric ? maxValue.m.toDouble() : maxValue.ft.toDouble();
  String get _unit => metric ? "m" : "ft";

  DepthSlider({
    required this.value,
    required this.metric,
    required this.onChanged,
    required this.minValue,
    required this.maxValue,
    this.gradual = false,
  });

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(right: 8.0),
      child: Row(
        children: [
          Expanded(
            child: Slider(
              value: toGradual(max(min(_current, _max), _min)),
              min: toGradual(_min),
              max: toGradual(_max),
              onChanged: (value) => onChanged(metric
                  ? DistanceM(fromGradual(value))
                  : DistanceFt(fromGradual(value))),
            ),
          ),
          Text(
            "${_current.toInt()} $_unit",
            textAlign: TextAlign.right,
            style: Theme.of(context).textTheme.caption,
          ),
        ],
      ),
    );
  }

  static const _pow = 2;

  double fromGradual(double v) {
    return pow(v, _pow) as double;
  }

  double toGradual(double v) {
    return pow(v, 1 / _pow) as double;
  }
}
