import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_guid/flutter_guid.dart';

import '../proto/flaska.pb.dart';
import '../models/cylinder_model.dart';

class CylinderEditView extends StatefulWidget {
  final CylinderData cylinder;
  final Function(CylinderModel) onChange;
  final Function(Guid) onDelete;

  const CylinderEditView({
    @required this.cylinder,
    @required this.onChange,
    @required this.onDelete,
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
        title: Text("Edit Cylinder"),
      ),
      body: Padding(
        padding: const EdgeInsets.all(8.0),
        child: Form(
          key: _formKey,
          child: Column(
            children: [
              formTable(),
              Divider(
                height: 32,
              ),
              Wrap(
                alignment: WrapAlignment.center,
                children: [
                  FlatButton(
                    child: Text("Save"),
                    textColor: Colors.greenAccent,
                    onPressed: valid
                        ? () async {
                            if (cylinder.id.isEmpty) {
                              // This is a new cylinder
                              cylinder.id = Guid.newGuid.toString();
                            }
                            widget.onChange(CylinderModel.fromData(cylinder));
                            Navigator.pop(context);
                          }
                        : null,
                  ),
                  FlatButton(
                    child: Text("Cancel"),
                    onPressed: () async {
                      Navigator.pop(context);
                    },
                  ),
                  FlatButton(
                    child: Text("Delete"),
                    textColor: Colors.redAccent,
                    onPressed: () async {
                      await widget
                          .onDelete(CylinderModel.fromData(cylinder).id);
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
        // 1: FixedColumnWidth(300),
        2: IntrinsicColumnWidth(),
      },
      defaultVerticalAlignment: TableCellVerticalAlignment.baseline,
      children: <TableRow>[
        titledRow(
          title: "Name",
          child: TextFormField(
            decoration: InputDecoration(hintText: "Enter a cylinder name"),
            initialValue: cylinder.name,
            onChanged: (value) {
              setState(() {
                cylinder.name = value;
              });
            },
            validator: (value) {
              if (value.isEmpty) {
                return 'The cylinder needs a name';
              }
              return null;
            },
          ),
        ),
        titledRow(
          title: "System",
          child: DropdownButtonFormField<MeasurementSystem>(
            value: cylinder.measurements,
            items: [
              DropdownMenuItem(
                  value: MeasurementSystem.METRIC, child: Text("Metric")),
              DropdownMenuItem(
                  value: MeasurementSystem.IMPERIAL, child: Text("Imperial")),
            ],
            onChanged: (value) {
              setState(() {
                cylinder.measurements = value;
              });
            },
          ),
        ),
        titledRow(
          title: "Material",
          child: DropdownButtonFormField<Metal>(
            value: cylinder.metal,
            items: [
              DropdownMenuItem(value: Metal.STEEL, child: Text("Steel")),
              DropdownMenuItem(
                  value: Metal.ALUMINIUM, child: Text("Aluminium")),
            ],
            onChanged: (value) {
              setState(() {
                cylinder.metal = value;
              });
            },
          ),
        ),
        titledUnitRow(
          title: "Volume",
          child: TextFormField(
            decoration: InputDecoration(
                hintText: cylinder.measurements == MeasurementSystem.METRIC
                    ? "Water volume in liters"
                    : "Air volume in cuft"),
            keyboardType: TextInputType.number,
            inputFormatters: [
              FilteringTextInputFormatter.allow(RegExp(r'[0-9\.]'))
            ],
            initialValue: cylinder.volume.toString(),
            onChanged: (value) {
              setState(() {
                cylinder.volume = double.parse(value);
              });
            },
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
        ),
        titledUnitRow(
          title: "Pressure",
          child: TextFormField(
            decoration: InputDecoration(
                hintText: cylinder.measurements == MeasurementSystem.METRIC
                    ? "Working pressure in psi"
                    : "Working pressure in bar"),
            keyboardType: TextInputType.number,
            inputFormatters: [
              FilteringTextInputFormatter.allow(RegExp(r'[0-9]'))
            ],
            initialValue: cylinder.workingPressure.toString(),
            onChanged: (value) {
              setState(() {
                cylinder.workingPressure = int.parse(value);
              });
            },
            autovalidateMode: AutovalidateMode.always,
            validator: (value) {
              if (value.isEmpty) {
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
            decoration: InputDecoration(
                hintText: cylinder.measurements == MeasurementSystem.METRIC
                    ? "Empty weight in kg"
                    : "Empty weight in lb"),
            keyboardType: TextInputType.number,
            inputFormatters: [
              FilteringTextInputFormatter.allow(RegExp(r'[0-9\.]'))
            ],
            initialValue: cylinder.weight.toString(),
            onChanged: (value) {
              setState(() {
                cylinder.weight = double.parse(value);
              });
            },
            validator: (value) {
              if (value.isEmpty) {
                return 'The cylinder needs a weight';
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
          metric: "kg",
          imperial: "lb",
        ),
        titledRow(
          title: "Twinset",
          child: Checkbox(
            value: cylinder.twinset,
            onChanged: (value) {
              setState(() {
                cylinder.twinset = value;
              });
            },
          ),
        ),
        titledRow(
          title: "Selected",
          child: Checkbox(
            value: cylinder.selected,
            onChanged: (value) {
              setState(() {
                cylinder.selected = value;
              });
            },
          ),
        )
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
      {String title, Widget child, String metric, String imperial}) {
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
        child: Text(cylinder.measurements == MeasurementSystem.METRIC
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
