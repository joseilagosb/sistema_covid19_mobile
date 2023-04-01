import 'package:flutter/material.dart';
import 'package:vacapp_mobile/pages/about/screens/about_screen.dart';
import 'package:vacapp_mobile/pages/load_travel_report/screens/load_travel_report_screen.dart';
import 'package:vacapp_mobile/pages/settings/screens/settings_screen.dart';

class DrawerMenu extends StatelessWidget {
  const DrawerMenu({Key? key}) : super(key: key);

  void navigateToScreen(Widget screen, BuildContext context) {
    Navigator.of(context).push(
      MaterialPageRoute<void>(
        fullscreenDialog: true,
        builder: (context) => screen,
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Drawer(
      child: ListView(
        padding: EdgeInsets.zero,
        children: <Widget>[
          const DrawerHeader(
            decoration: BoxDecoration(
              color: Colors.green,
              image: DecorationImage(
                fit: BoxFit.fill,
                image: AssetImage("assets/images/cover.jpg"),
              ),
            ),
            child: Text('', style: TextStyle(color: Colors.white, fontSize: 25)),
          ),
          ListTile(
            leading: const Icon(Icons.info),
            title: const Text('Sobre la app'),
            onTap: () => navigateToScreen(const AboutScreen(), context),
          ),
          ListTile(
            leading: const Icon(Icons.card_travel),
            title: const Text('Cargar reporte de viaje'),
            onTap: () => navigateToScreen(const LoadTravelReportScreen(), context),
          ),
          ListTile(
            leading: const Icon(Icons.verified_user),
            title: const Text('Tutorial'),
            onTap: () => {Navigator.of(context).pop()},
          ),
          ListTile(
            leading: const Icon(Icons.help),
            title: const Text('Portal de ayuda'),
            onTap: () => {Navigator.of(context).pop()},
          ),
          ListTile(
            leading: const Icon(Icons.settings),
            title: const Text('Configuración'),
            onTap: () => navigateToScreen(const SettingsScreen(), context),
          ),
          ListTile(
            leading: const Icon(Icons.notification_important),
            title: const Text('Términos de uso'),
            onTap: () => {Navigator.of(context).pop()},
          ),
        ],
      ),
    );
  }
}
