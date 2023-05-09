import 'package:flaska/settings/settings_bloc.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import 'services/service_locator.dart';
import 'navigation/navigation_view.dart';

void main() {
  setupServiceLocator();
  runApp(FlaskaApp());
}

class FlaskaApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (_) => SettingsBloc(),
      child: BlocBuilder<SettingsBloc, SettingsState>(
        buildWhen: (previous, current) => previous.settings.themeColor != current.settings.themeColor,
        builder: (context, state) {
          final accent = state.themeColor;
          return MaterialApp(
            title: 'Flaska',
            themeMode: ThemeMode.dark,
            darkTheme: ThemeData(
              visualDensity: VisualDensity.adaptivePlatformDensity,
              brightness: Brightness.dark,
              primaryColor: Colors.black,
              canvasColor: Colors.black,
              cardColor: const Color.fromRGBO(24, 24, 24, 1),
              dialogBackgroundColor: const Color.fromRGBO(32, 32, 32, 1),
              dividerColor: const Color.fromRGBO(64, 64, 64, 1),
              outlinedButtonTheme: OutlinedButtonThemeData(
                style: OutlinedButton.styleFrom(
                  foregroundColor: Colors.white,
                  side: BorderSide(
                    color: const Color.fromRGBO(128, 128, 128, 1),
                    width: 1,
                  ),
                ),
              ),
              sliderTheme: SliderThemeData.fromPrimaryColors(
                primaryColor: accent,
                primaryColorDark: accent,
                primaryColorLight: accent,
                valueIndicatorTextStyle: TextStyle(),
              ),
              colorScheme: ColorScheme.dark(
                primary: accent,
                secondary: accent,
                surface: Color.fromRGBO(0, 0, 0, 1),
                background: Color.fromRGBO(32, 32, 32, 1),
                error: Colors.redAccent,
                onPrimary: Colors.white,
              ),
            ),
            debugShowCheckedModeBanner: false,
            home: NavigationView(),
          );
        },
      ),
    );
  }
}
