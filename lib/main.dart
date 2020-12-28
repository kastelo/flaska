import 'package:flutter/material.dart';

import 'cylinders/cylinderlist_view.dart';
import 'services/service_locator.dart';

void main() {
  setupServiceLocator();
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Tank Buddy',
      theme: ThemeData(
        primarySwatch: Colors.blue,
        visualDensity: VisualDensity.adaptivePlatformDensity,
        brightness: Brightness.light,
        textTheme: Typography.englishLike2018.apply(fontSizeFactor: 1.15),
      ),
      darkTheme: ThemeData(
        primarySwatch: Colors.blue,
        visualDensity: VisualDensity.adaptivePlatformDensity,
        brightness: Brightness.dark,
        textTheme: Typography.englishLike2018.apply(fontSizeFactor: 1.15),
        primaryColor: Color.fromRGBO(16, 16, 16, 1),
        canvasColor: Color.fromRGBO(0, 0, 0, 1),
        cardColor: Color.fromRGBO(24, 24, 24, 1),
        accentColor: Colors.blueAccent,
      ),
      home: Scaffold(
        appBar: AppBar(
          title: Text("Tank Buddy"),
        ),
        body: CylinderListView(),
      ),
      debugShowCheckedModeBanner: false,
    );
  }
}
