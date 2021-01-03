import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../proto/flaska.pb.dart';
import 'settings_bloc.dart';

class SettingsView extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(8.0),
      child: BlocBuilder<SettingsBloc, SettingsState>(
        builder: (context, state) => formTable(state.settings),
      ),
    );
  }

  Widget formTable(SettingsData settings) {
    return Table(
      columnWidths: {
        0: IntrinsicColumnWidth(),
        2: IntrinsicColumnWidth(),
      },
      defaultVerticalAlignment: TableCellVerticalAlignment.baseline,
      children: <TableRow>[
        titledRow(
          title: "System",
          child: DropdownButtonFormField<MeasurementSystem>(
            value: settings.measurements,
            items: [
              DropdownMenuItem(
                  value: MeasurementSystem.METRIC, child: Text("Metric")),
              DropdownMenuItem(
                  value: MeasurementSystem.IMPERIAL, child: Text("Imperial")),
            ],
            onChanged: (value) {},
          ),
        ),
        titledUnitRow(
            title: "SAC Rate",
            child: TextFormField(
              decoration: InputDecoration(
                  hintText: settings.measurements == MeasurementSystem.METRIC
                      ? "SAC rate in liters per minute"
                      : "SAC rate in cuft per minute"),
              keyboardType: TextInputType.number,
              inputFormatters: [
                FilteringTextInputFormatter.allow(RegExp(r'[0-9\.]'))
              ],
              initialValue: settings.sacRate.toString(),
              onChanged: (value) {},
              validator: (value) {
                if (value.isEmpty) {
                  return 'The cylinder needs a volume';
                }
                try {
                  if (double.parse(value) <= 0) {
                    return 'Must be a positive number';
                  }
                } catch (e) {
                  return 'Must be a valid number';
                }
                return null;
              },
            ),
            metric: "L",
            imperial: "ft³",
            settings: settings),
      ],
    );
  }

  TableRow titledRow({String title, Widget child}) {
    return TableRow(children: [
      Padding(
        padding: const EdgeInsets.only(right: 16.0),
        child: Text(
          title + ":",
          textAlign: TextAlign.right,
        ),
      ),
      child,
      Container(),
    ]);
  }

  TableRow titledUnitRow(
      {String title,
      Widget child,
      String metric,
      String imperial,
      SettingsData settings}) {
    return TableRow(children: [
      Padding(
        padding: const EdgeInsets.only(right: 16.0),
        child: Text(
          title + ":",
          textAlign: TextAlign.right,
        ),
      ),
      child,
      Padding(
        padding: const EdgeInsets.only(left: 16.0),
        child: Text(settings.measurements == MeasurementSystem.METRIC
            ? metric
            : imperial),
      )
    ]);
  }
}

class WithUnit extends StatelessWidget {
  final MeasurementSystem measurements;
  final String metric;
  final String imperial;
  final Widget child;

  const WithUnit(
      {@required this.measurements,
      @required this.metric,
      @required this.imperial,
      @required this.child});

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        Expanded(child: child),
        Text(measurements == MeasurementSystem.METRIC ? metric : imperial),
      ],
    );
  }
}
