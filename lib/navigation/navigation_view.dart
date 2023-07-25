import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../cylinderlist/cylinderlist_bloc.dart';
import '../cylinderlist/cylinderlist_view.dart';
import '../divecalculation/divecalculation_bloc.dart';
import '../divecalculation/divecalculation_view.dart';
import '../settings/settings_bloc.dart';
import '../settings/settings_view.dart';
import '../transfill/transfill_bloc.dart';
import '../transfill/transfill_view.dart';

class NavigationView extends StatefulWidget {
  @override
  _NavigationViewState createState() => _NavigationViewState();
}

class _NavigationViewState extends State<NavigationView> {
  @override
  Widget build(BuildContext context) {
    return DefaultTabController(
      length: 4,
      child: Scaffold(
        body: BodyWidget(),
        bottomNavigationBar: SafeArea(
          top: false,
          child: TabBar(
            indicatorColor: Theme.of(context).colorScheme.secondary,
            tabs: [
              Tab(icon: Icon(Icons.scuba_diving)),
              Tab(icon: Icon(Icons.equalizer)),
              Tab(icon: Icon(Icons.storage)),
              Tab(icon: Icon(Icons.tune)),
            ],
          ),
        ),
      ),
    );
  }
}

class BodyWidget extends StatefulWidget {
  const BodyWidget({
    Key? key,
  }) : super(key: key);

  @override
  _BodyWidgetState createState() => _BodyWidgetState();
}

class _BodyWidgetState extends State<BodyWidget> {
  final CylinderListBloc cylinderListBloc = CylinderListBloc();

  @override
  void dispose() {
    cylinderListBloc.close();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return MultiBlocProvider(
      providers: [
        BlocProvider(
          create: (_) => cylinderListBloc,
        ),
        BlocProvider(
          create: (_) => DiveCalculationBloc(context.read<SettingsBloc>()),
        ),
        BlocProvider(
          create: (_) => TransfillBloc(context.read<SettingsBloc>(), cylinderListBloc),
        ),
      ],
      child: TabBarView(
        physics: NeverScrollableScrollPhysics(),
        children: [
          DiveCalculationView(),
          TransfillView(),
          CylinderListView(),
          SettingsView(),
        ],
      ),
    );
  }
}
