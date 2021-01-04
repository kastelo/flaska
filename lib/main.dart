import 'package:flutter/material.dart';

import 'services/service_locator.dart';
import 'navigation/navigation_view.dart';

void main() {
  setupServiceLocator();
  runApp(FlaskaApp());
}

class FlaskaApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    final accent = Color.fromRGBO(64, 224, 255, 1);
    return MaterialApp(
      title: 'Flaska',
      themeMode: ThemeMode.dark,
      // theme: ThemeData(
      //   primarySwatch: Colors.blue,
      //   visualDensity: VisualDensity.adaptivePlatformDensity,
      //   brightness: Brightness.light,
      //   canvasColor: Colors.white,
      //   cardColor: Colors.grey.shade200,
      //   tabBarTheme: TabBarTheme(
      //       labelColor: Colors.blue,
      //       unselectedLabelColor: Colors.grey.shade800),
      //   toggleableActiveColor: Colors.blueAccent,
      // ),
      darkTheme: ThemeData(
        primarySwatch: Colors.blue,
        visualDensity: VisualDensity.adaptivePlatformDensity,
        brightness: Brightness.dark,
        primaryColor: Color.fromRGBO(16, 16, 16, 1),
        canvasColor: Color.fromRGBO(0, 0, 0, 1),
        cardColor: Color.fromRGBO(24, 24, 24, 1),
        dialogBackgroundColor: Color.fromRGBO(32, 32, 32, 1),
        accentColor: accent,
        dividerColor: Color.fromRGBO(64, 64, 64, 1),
        toggleableActiveColor: accent,
        outlinedButtonTheme: OutlinedButtonThemeData(
          style: OutlinedButton.styleFrom(primary: Colors.white),
        ),
        sliderTheme: SliderThemeData.fromPrimaryColors(
            primaryColor: accent,
            primaryColorDark: accent,
            primaryColorLight: accent,
            valueIndicatorTextStyle: TextStyle()),
      ),
      debugShowCheckedModeBanner: false,
      home: NavigationView(),
    );
  }
}
