import 'dart:math';

import 'package:flutter/material.dart';

import '../models/units.dart';

class PressureSlider extends StatelessWidget {
  final Pressure value;
  final bool metric;
  final bool withMin;
  final Function(Pressure) onChanged;

  double get _current => metric ? value.bar.toDouble() : value.psi.toDouble();
  double get _max => metric ? 300 : 4000;
  double get _min => withMin ? (metric ? 35 : 500) : 0;
  String get _unit => metric ? "bar" : "psi";

  const PressureSlider(
      {@required this.value,
      @required this.metric,
      @required this.onChanged,
      this.withMin = false});

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        Expanded(
          child: Slider(
              value: max(_min, min(_current, _max)),
              min: _min,
              max: _max,
              onChanged: (v) {
                final pressure = metric
                    ? PressureBar(v.toInt().roundi(5))
                    : PressurePsi(v.toInt().roundi(100));
                onChanged(pressure);
              }),
        ),
        Text(
          "${_current.toInt()} $_unit",
          textAlign: TextAlign.right,
          style: Theme.of(context).textTheme.caption,
        ),
      ],
    );
  }
}
