import 'dart:math';

import 'package:flaska/models/units.dart';
import 'package:flutter/material.dart';

class DepthSlider extends StatelessWidget {
  final bool metric;
  final Distance value;
  final Distance maxValue;
  final Function(Distance) onChanged;

  double get _current => metric ? value.m.toDouble() : value.ft.toDouble();
  double get _max => metric ? maxValue.m.toDouble() : maxValue.ft.toDouble();
  String get _unit => metric ? "m" : "ft";

  DepthSlider({
    @required this.metric,
    @required this.value,
    @required this.maxValue,
    @required this.onChanged,
  });

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(right: 8.0),
      child: Row(
        children: [
          Expanded(
            child: Slider(
              value: min(_current, _max),
              min: 0,
              max: _max,
              onChanged: (value) =>
                  onChanged(metric ? DistanceM(value) : DistanceFt(value)),
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
}
