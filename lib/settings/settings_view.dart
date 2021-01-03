import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../proto/flaska.pb.dart';
import 'settings_bloc.dart';

const _appBuild = int.fromEnvironment("BUILD", defaultValue: 0);
const _marketingVer =
    String.fromEnvironment("MARKETINGVERSION", defaultValue: "0.0.0");
const _gitVer =
    String.fromEnvironment("GITVERSION", defaultValue: "unknown-dev");

class SettingsView extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(8.0),
      child: BlocBuilder<SettingsBloc, SettingsState>(
        builder: (context, state) => GestureDetector(
          onTap: () {
            var currentFocus = FocusScope.of(context);
            if (!currentFocus.hasPrimaryFocus) {
              currentFocus.unfocus();
            }
          },
          child: SingleChildScrollView(
            child: Column(
              children: [
                formTable(context, state.settings),
                Divider(
                  height: 32,
                  indent: 32,
                  endIndent: 32,
                ),
                Text(
                  "Version $_marketingVer ($_appBuild)\n[$_gitVer]",
                  style: Theme.of(context).textTheme.caption,
                  textAlign: TextAlign.center,
                )
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget formTable(BuildContext context, SettingsData settings) {
    return Form(
      child: Table(
        columnWidths: {
          0: IntrinsicColumnWidth(),
          2: IntrinsicColumnWidth(),
        },
        defaultVerticalAlignment: TableCellVerticalAlignment.baseline,
        children: <TableRow>[
          headerRow(context: context, title: "General"),
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
              keyboardType: TextInputType.number,
              inputFormatters: [
                FilteringTextInputFormatter.allow(RegExp(r'[0-9\.]'))
              ],
              initialValue: settings.sacRate.toString(),
              onChanged: (value) {},
              validator: (value) {
                if (value.isEmpty) {
                  return 'Must enter a SAC rate';
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
            metric: "L/min",
            imperial: "ft³/min",
            settings: settings,
          ),
          headerRow(context: context, title: "Trouble solving"),
          titledRow(
            title: "Duration",
            child: TextFormField(
              keyboardType: TextInputType.number,
              inputFormatters: [
                FilteringTextInputFormatter.allow(RegExp(r'[0-9\.]'))
              ],
              initialValue: settings.troubleSolvingDuration.toString(),
              onChanged: (value) {},
              validator: (value) {
                if (value.isEmpty) {
                  return 'Must enter a trouble solving duration';
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
            trailer: "min",
          ),
          titledRow(
            title: "SAC multiplier",
            child: TextFormField(
              keyboardType: TextInputType.number,
              inputFormatters: [
                FilteringTextInputFormatter.allow(RegExp(r'[0-9\.]'))
              ],
              initialValue: settings.troubleSolvingDuration.toString(),
              onChanged: (value) {},
              validator: (value) {
                if (value.isEmpty) {
                  return 'Must enter a trouble solving SAC multiplier';
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
            trailer: "×",
          ),
          headerRow(context: context, title: "Ascent"),
          titledUnitRow(
            title: "Ascent rate",
            child: TextFormField(
              keyboardType: TextInputType.number,
              inputFormatters: [
                FilteringTextInputFormatter.allow(RegExp(r'[0-9\.]'))
              ],
              initialValue: settings.ascentRate.toString(),
              onChanged: (value) {},
              validator: (value) {
                if (value.isEmpty) {
                  return 'Must enter a trouble solving duration';
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
            metric: "m/min",
            imperial: "ft/min",
            settings: settings,
          ),
          titledRow(
            title: "SAC multiplier",
            child: TextFormField(
              keyboardType: TextInputType.number,
              inputFormatters: [
                FilteringTextInputFormatter.allow(RegExp(r'[0-9\.]'))
              ],
              initialValue: settings.ascentSacMultiplier.toString(),
              onChanged: (value) {},
              validator: (value) {
                if (value.isEmpty) {
                  return 'Must enter a trouble solving SAC multiplier';
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
            trailer: "×",
          ),
          headerRow(context: context, title: "Safety stop"),
          titledRow(
            title: "Duration",
            child: TextFormField(
              keyboardType: TextInputType.number,
              inputFormatters: [
                FilteringTextInputFormatter.allow(RegExp(r'[0-9\.]'))
              ],
              initialValue: settings.safetystopDuration.toString(),
              onChanged: (value) {},
              validator: (value) {
                if (value.isEmpty) {
                  return 'Must enter a trouble solving duration';
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
            trailer: "min",
          ),
          titledUnitRow(
            title: "Depth",
            child: TextFormField(
              keyboardType: TextInputType.number,
              inputFormatters: [
                FilteringTextInputFormatter.allow(RegExp(r'[0-9\.]'))
              ],
              initialValue: settings.safetystopDepth.toString(),
              onChanged: (value) {},
              validator: (value) {
                if (value.isEmpty) {
                  return 'Must enter a trouble solving duration';
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
            metric: "m",
            imperial: "ft",
            settings: settings,
          ),
          titledRow(
            title: "SAC multiplier",
            child: TextFormField(
              keyboardType: TextInputType.number,
              inputFormatters: [
                FilteringTextInputFormatter.allow(RegExp(r'[0-9\.]'))
              ],
              initialValue: settings.safetystopSacMultiplier.toString(),
              onChanged: (value) {},
              validator: (value) {
                if (value.isEmpty) {
                  return 'Must enter a trouble solving SAC multiplier';
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
            trailer: "×",
          ),
        ],
      ),
    );
  }

  Widget troubleSolvingTable(SettingsData settings) {
    return Form(
      child: Table(
        columnWidths: {
          0: IntrinsicColumnWidth(),
          2: IntrinsicColumnWidth(),
        },
        defaultVerticalAlignment: TableCellVerticalAlignment.baseline,
        children: <TableRow>[],
      ),
    );
  }

  TableRow headerRow({
    BuildContext context,
    String title,
  }) {
    return TableRow(children: [
      Container(),
      Padding(
        padding: const EdgeInsets.only(top: 16.0),
        child: Text(title,
            style: Theme.of(context)
                .textTheme
                .subtitle1
                .copyWith(color: Colors.grey)),
      ),
      Container(),
    ]);
  }

  TableRow titledRow({String title, Widget child, String trailer}) {
    return TableRow(children: [
      Padding(
        padding: const EdgeInsets.only(right: 16.0),
        child: Text(
          title + ":",
          textAlign: TextAlign.right,
        ),
      ),
      child,
      trailer == null || trailer.isEmpty
          ? Container()
          : Padding(
              padding: const EdgeInsets.only(left: 16.0), child: Text(trailer)),
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
