import 'package:flutter/material.dart';
import 'package:flutter/cupertino.dart';

import 'package:vacapp_mobile/utils/constants.dart';

class DrawerMenu extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Drawer(
      child: ListView(
        padding: EdgeInsets.zero,
        children: <Widget>[
          DrawerHeader(
            child: Text(
              '',
              style: TextStyle(color: Colors.white, fontSize: 25),
            ),
            decoration: BoxDecoration(
                color: Colors.green,
                image: DecorationImage(
                    fit: BoxFit.fill,
                    image: NetworkImage(
                        Constants.BACKEND_URI + '/images/cover.jpg'))),
          ),
          ListTile(
            leading: Icon(Icons.info),
            title: Text('Sobre la app'),
            onTap: () => {},
          ),
          ListTile(
            leading: Icon(Icons.card_travel),
            title: Text('Cargar reporte de viaje'),
            onTap: () => {Navigator.of(context).pop()},
          ),
          ListTile(
            leading: Icon(Icons.verified_user),
            title: Text('Tutorial'),
            onTap: () => {Navigator.of(context).pop()},
          ),
          ListTile(
            leading: Icon(Icons.help),
            title: Text('Portal de ayuda'),
            onTap: () => {Navigator.of(context).pop()},
          ),
          ListTile(
            leading: Icon(Icons.settings),
            title: Text('Configuración'),
            onTap: () => {Navigator.of(context).pop()},
          ),
          ListTile(
            leading: Icon(Icons.notification_important),
            title: Text('Términos de uso'),
            onTap: () => {Navigator.of(context).pop()},
          ),
        ],
      ),
    );
  }
}
