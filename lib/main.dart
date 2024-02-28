import 'package:flutter/material.dart';
import 'package:vacapp_mobile/navigation_key.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';

import 'package:vacapp_mobile/pages/landing_page/screens/landing_page_screen.dart';
import 'package:vacapp_mobile/constants/values.dart';
import 'package:vacapp_mobile/services/authentication.dart';

Future<void> main() async {
  await dotenv.load(fileName: ".env");
  Authentication.authenticateClientApp();
  runApp(const MyApp());
}

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
        primarySwatch: const MaterialColor(0xFFFF961E, Values.colorCodes),
        scaffoldBackgroundColor: const MaterialColor(0xFF961E, Values.colorCodes)[900],
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
