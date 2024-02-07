import 'package:flutter/material.dart';

import 'package:vacapp_mobile/navigation_key.dart';

import 'package:vacapp_mobile/pages/landing_page/screens/landing_page_screen.dart';

import 'package:vacapp_mobile/utils/constants.dart';

void main() => runApp(const MyApp());

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      initialRoute: '/',
      routes: {'/': (context) => LandingPageScreen.create()},
      title: 'Sistema COVID-19',
      navigatorKey: navigatorKey,
      theme: ThemeData(
        fontFamily: 'OpenSans',
        primarySwatch: MaterialColor(0xFFFF961E, Constants.COLOR_CODES),
        scaffoldBackgroundColor: MaterialColor(0xFF961E, Constants.COLOR_CODES)[900],
        primaryIconTheme: const IconThemeData(color: Colors.white),
        primaryTextTheme:
            Theme.of(context).textTheme.apply(displayColor: Colors.black, fontFamily: 'OpenSans'),
        textTheme:
            Theme.of(context).textTheme.apply(displayColor: Colors.black, fontFamily: 'OpenSans'),
        visualDensity: VisualDensity.adaptivePlatformDensity,
      ),
    );
  }
}
