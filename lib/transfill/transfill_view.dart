import 'dart:math';

import '../models/units.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../models/cylinder_model.dart';
import '../transfill/transfill_bloc.dart';

class TransfillView extends StatefulWidget {
  @override
  _TransfillViewState createState() => _TransfillViewState();
}

class _TransfillViewState extends State<TransfillView> {
  @override
  Widget build(BuildContext context) {
    return BlocBuilder<TransfillBloc, TransfillState>(
      builder: (context, state) {
        return Padding(
          padding: const EdgeInsets.all(8.0),
          child: CustomScrollView(
            slivers: [
              SliverAppBar(
                title: Text("Transfill"),
                pinned: true,
                floating: true,
              ),
              if (state.valid)
                SliverList(
                  delegate: SliverChildListDelegate([
                    Padding(
                      padding: const EdgeInsets.symmetric(vertical: 4.0),
                      child: TransfillCylinderEditView(
                        title: "FROM",
                        cylinders: state.cylinders,
                        selected: state.from,
                        onChanged: (m) =>
                            context.read<TransfillBloc>().add(NewFrom(m)),
                      ),
                    ),
                    Padding(
                      padding: const EdgeInsets.symmetric(vertical: 4.0),
                      child: TransfillCylinderEditView(
                        title: "TO",
                        cylinders: state.cylinders,
                        selected: state.to,
                        onChanged: (m) =>
                            context.read<TransfillBloc>().add(NewTo(m)),
                      ),
                    ),
                  ]),
                ),
            ],
          ),
        );
      },
    );
  }
}

class TransfillCylinderEditView extends StatelessWidget {
  final String title;
  final List<CylinderModel> cylinders;
  final TransfillCylinderModel selected;
  final Function(TransfillCylinderModel) onChanged;

  const TransfillCylinderEditView({
    @required this.title,
    @required this.cylinders,
    @required this.selected,
    @required this.onChanged,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        borderRadius: BorderRadius.all(Radius.circular(5)),
        color: Theme.of(context).cardColor,
      ),
      child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              Text(title),
              Divider(),
              DropdownButton(
                value: selected.cylinder,
                items: cylinders
                    .map((c) => DropdownMenuItem(value: c, child: Text(c.name)))
                    .toList(),
                onChanged: (cyl) {
                  onChanged(TransfillCylinderModel(
                    cylinder: cyl,
                    pressure: selected.pressure,
                    metric: selected.metric,
                  ));
                },
              ),
              _PressureSlider(
                value: selected.pressure,
                metric: selected.metric,
                onChanged: (pres) {
                  onChanged(TransfillCylinderModel(
                    cylinder: selected.cylinder,
                    pressure: pres,
                    metric: selected.metric,
                  ));
                },
              ),
            ],
          )),
    );
  }
}

class _PressureSlider extends StatelessWidget {
  final Pressure value;
  final bool metric;
  final Function(Pressure) onChanged;

  double get _current => metric ? value.bar.toDouble() : value.psi.toDouble();
  double get _max => metric ? 300 : 4000;
  String get _unit => metric ? "bar" : "psi";

  const _PressureSlider(
      {@required this.value, @required this.metric, @required this.onChanged});

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        Expanded(
          child: Slider(
              value: min(_current, _max),
              min: 0,
              max: _max,
              onChanged: (v) {
                final pressure =
                    metric ? PressureBar(v.toInt()) : PressurePsi(v.toInt());
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
