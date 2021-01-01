import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../cylinderlist/cylinderlist_bloc.dart';
import '../cylinderlist/cylinderlist_view.dart';
import '../divecalculation/divecalculation_bloc.dart';
import '../divecalculation/divecalculation_view.dart';

class NavigationView extends StatefulWidget {
  @override
  _NavigationViewState createState() => _NavigationViewState();
}

class _NavigationViewState extends State<NavigationView> {
  @override
  Widget build(BuildContext context) {
    return DefaultTabController(
      length: 3,
      child: Scaffold(
        appBar: AppBar(
          title: Text('Flaska'),
        ),
        body: BodyWidget(),
        bottomNavigationBar: SafeArea(
          top: false,
          child: TabBar(
            tabs: [
              Tab(text: "Calculator", icon: Icon(Icons.calculate)),
              Tab(text: "Cylinders", icon: Icon(Icons.list)),
              Tab(text: "Settings", icon: Icon(Icons.settings)),
            ],
          ),
        ),
      ),
    );
  }
}

class BodyWidget extends StatelessWidget {
  const BodyWidget({
    Key key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return MultiBlocProvider(
      providers: [
        BlocProvider(
          create: (_) => CylinderListBloc(),
        ),
        BlocProvider(
          create: (_) => DiveCalculationBloc(),
        ),
      ],
      child: TabBarView(
        children: [
          DiveCalculationView(),
          CylinderListView(),
          Placeholder(),
        ],
      ),
    );
  }
}
