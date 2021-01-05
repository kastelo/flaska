import 'dart:math';

import 'package:flutter/material.dart';

import '../models/units.dart';

class PressureSlider extends StatelessWidget {
  final Pressure value;
  final bool metric;
  final Pressure minValue;
  final Pressure maxValue;
  final Pressure step;
  final Function(Pressure) onChanged;

  double get _current => metric ? value.bar.toDouble() : value.psi.toDouble();
  double get _min => metric ? minValue.bar.toDouble() : minValue.psi.toDouble();
  double get _max => metric ? maxValue.bar.toDouble() : maxValue.psi.toDouble();
  String get _unit => metric ? "bar" : "psi";

  const PressureSlider({
    @required this.value,
    @required this.metric,
    @required this.onChanged,
    @required this.minValue,
    @required this.maxValue,
    @required this.step,
  });

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        Expanded(
          child: Slider(
              value: max(min(_current, _max), _min),
              min: _min,
              max: _max,
              onChanged: (v) {
                final pressure = metric
                    ? PressureBar(v.toInt().roundi(step.bar))
                    : PressurePsi(v.toInt().roundi(step.psi));
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
