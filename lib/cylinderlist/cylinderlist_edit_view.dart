import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:uuid/uuid.dart';

import '../models/cylinder_model.dart';
import '../proto/proto.dart';

final _decimalExp = RegExp(r'[0-9\.,]');
double parseDouble(String s) {
  return double.tryParse(s.trim().replaceAll(",", ".")) ?? 0.0;
}

class CylinderEditView extends StatefulWidget {
  final CylinderData cylinder;
  final Function(CylinderModel) onChange;
  final Function(UuidValue) onDelete;

  const CylinderEditView({
    required this.cylinder,
    required this.onChange,
    required this.onDelete,
  });

  @override
  _CylinderEditViewState createState() => _CylinderEditViewState(cylinder);
}

class _CylinderEditViewState extends State<CylinderEditView> {
  CylinderData cylinder;

  _CylinderEditViewState(this.cylinder);

  final _formKey = GlobalKey<FormState>();

  @override
  Widget build(BuildContext context) {
    final valid = _formKey.currentState?.validate() ?? false;
    return Scaffold(
      appBar: AppBar(
        title: Text(
          cylinder.id.isEmpty ? "Add Cylinder" : "Edit Cylinder",
        ),
      ),
      body: Padding(
        padding: const EdgeInsets.all(8.0),
        child: Form(
          key: _formKey,
          child: ListView(
            children: [
              formTable(),
              Divider(
                height: 32,
              ),
              Wrap(
                alignment: WrapAlignment.spaceEvenly,
                children: [
                  OutlinedButton(
                    child: Text("Save"),
                    style: OutlinedButton.styleFrom(foregroundColor: Colors.greenAccent),
                    onPressed: valid
                        ? () async {
                            if (cylinder.id.isEmpty) {
                              // This is a new cylinder
                              cylinder.id = Uuid().v4();
                            }
                            widget.onChange(CylinderModel.fromData(cylinder));
                            Navigator.pop(context);
                          }
                        : null,
                  ),
                  OutlinedButton(
                    child: Text("Cancel"),
                    onPressed: () async {
                      Navigator.pop(context);
                    },
                  ),
                  if (cylinder.id.isNotEmpty)
                    OutlinedButton(
                      child: Text("Delete"),
                      style: OutlinedButton.styleFrom(foregroundColor: Colors.redAccent),
                      onPressed: () async {
                        await widget.onDelete(CylinderModel.fromData(cylinder).id);
                        Navigator.pop(context);
                      },
                    ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget formTable() {
    return Table(
      columnWidths: {
        0: IntrinsicColumnWidth(),
        2: IntrinsicColumnWidth(),
      },
      defaultVerticalAlignment: TableCellVerticalAlignment.baseline,
      textBaseline: TextBaseline.alphabetic,
      children: <TableRow>[
        titledRow(
          title: "Name",
          child: TextFormField(
            decoration: InputDecoration(hintText: "Enter a cylinder name"),
            initialValue: cylinder.name,
            onChanged: (value) {
              setState(() => cylinder.name = value);
            },
            validator: (value) {
              if (value!.isEmpty) {
                return 'The cylinder needs a name';
              }
              return null;
            },
          ),
        ),
        titledRow(
          title: "System",
          child: Padding(
            padding: const EdgeInsets.symmetric(vertical: 6.0),
            child: SegmentedButton<MeasurementSystem>(
              segments: [
                ButtonSegment(value: MeasurementSystem.METRIC, label: Text("Metric")),
                ButtonSegment(value: MeasurementSystem.IMPERIAL, label: Text("Imperial")),
              ],
              selected: <MeasurementSystem>{cylinder.measurements},
              onSelectionChanged: (value) {
                setState(() => cylinder.measurements = value.first);
              },
            ),
          ),
        ),
        titledRow(
          title: "Material",
          child: Padding(
            padding: const EdgeInsets.symmetric(vertical: 6.0),
            child: SegmentedButton<Metal>(
              segments: [
                ButtonSegment(value: Metal.ALUMINIUM, label: Text("Aluminium")),
                ButtonSegment(value: Metal.STEEL, label: Text("Steel")),
              ],
              selected: <Metal>{cylinder.metal},
              onSelectionChanged: (value) {
                setState(() => cylinder.metal = value.first);
              },
            ),
          ),
        ),
        titledUnitRow(
          title: "Volume",
          child: TextFormField(
            decoration: InputDecoration(hintText: cylinder.measurements == MeasurementSystem.METRIC ? "Water volume in liters" : "Air volume in cuft"),
            keyboardType: TextInputType.numberWithOptions(decimal: true),
            inputFormatters: [FilteringTextInputFormatter.allow(_decimalExp)],
            initialValue: cylinder.volume.toString(),
            onChanged: (value) {
              setState(() => cylinder.volume = parseDouble(value));
            },
            validator: (value) {
              if (value!.isEmpty) {
                return 'The cylinder needs a volume';
              }
              if (parseDouble(value) <= 0) {
                return 'Must be a positive number';
              }
              return null;
            },
          ),
          metric: "L",
          imperial: "cuft",
        ),
        titledUnitRow(
          title: "Pressure",
          child: TextFormField(
            decoration: InputDecoration(hintText: cylinder.measurements == MeasurementSystem.METRIC ? "Working pressure in psi" : "Working pressure in bar"),
            keyboardType: TextInputType.number,
            inputFormatters: [FilteringTextInputFormatter.allow(RegExp(r'[0-9]'))],
            initialValue: cylinder.workingPressure.toString(),
            onChanged: (value) {
              setState(() => cylinder.workingPressure = int.parse(value));
            },
            autovalidateMode: AutovalidateMode.always,
            validator: (value) {
              if (value!.isEmpty) {
                return 'The cylinder needs a working pressure';
              }
              try {
                if (int.parse(value) <= 0) {
                  return 'Must be a positive number';
                }
              } catch (e) {
                return 'Must be a valid number';
              }
              return null;
            },
          ),
          metric: "bar",
          imperial: "psi",
        ),
        titledUnitRow(
          title: "Weight",
          child: TextFormField(
            decoration: InputDecoration(hintText: cylinder.measurements == MeasurementSystem.METRIC ? "Empty weight in kg" : "Empty weight in lb"),
            keyboardType: TextInputType.numberWithOptions(decimal: true),
            inputFormatters: [FilteringTextInputFormatter.allow(_decimalExp)],
            initialValue: cylinder.weight.toString(),
            onChanged: (value) {
              setState(() => cylinder.weight = parseDouble(value));
            },
            validator: (value) {
              if (value!.isEmpty) {
                return 'The cylinder needs a weight';
              }
              if (parseDouble(value) <= 0) {
                return 'Must be a positive number';
              }
              return null;
            },
          ),
          metric: "kg",
          imperial: "lb",
        ),
        TableRow(
          children: [
            TableCell(
              verticalAlignment: TableCellVerticalAlignment.middle,
              child: Padding(
                padding: const EdgeInsets.only(right: 16.0),
                child: Text(
                  "Twinset:",
                  textAlign: TextAlign.right,
                ),
              ),
            ),
            Row(
              children: [
                Switch(
                  value: cylinder.twinset,
                  onChanged: (value) {
                    setState(() => cylinder.twinset = value);
                  },
                ),
              ],
            ),
            Container(),
          ],
        ),
        TableRow(
          children: [
            TableCell(
              verticalAlignment: TableCellVerticalAlignment.middle,
              child: Padding(
                padding: const EdgeInsets.only(right: 16.0),
                child: Text(
                  "Allow overfills:",
                  textAlign: TextAlign.right,
                ),
              ),
            ),
            Row(
              children: [
                Switch(
                  value: cylinder.overfill,
                  onChanged: (value) {
                    setState(() => cylinder.overfill = value);
                  },
                ),
              ],
            ),
            Container(),
          ],
        ),
      ],
    );
  }

  TableRow titledRow({required String title, required Widget child}) {
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

  TableRow titledUnitRow({required String title, required Widget child, required String metric, required String imperial}) {
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
        child: Text(cylinder.measurements == MeasurementSystem.METRIC ? metric : imperial),
      )
    ]);
  }
}

class WithUnit extends StatelessWidget {
  final MeasurementSystem measurements;
  final String metric;
  final String imperial;
  final Widget child;

  const WithUnit({required this.measurements, required this.metric, required this.imperial, required this.child});

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
