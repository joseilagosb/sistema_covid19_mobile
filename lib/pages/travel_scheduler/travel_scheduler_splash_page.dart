import 'package:flutter/material.dart';
import 'package:flutter/cupertino.dart';
import 'package:vacapp_mobile/pages/travel_scheduler/travel_scheduler_input_page.dart';

class ScheduleTravelPage extends StatefulWidget {
  const ScheduleTravelPage({super.key});

  @override
  _ScheduleTravelPageState createState() => _ScheduleTravelPageState();
}

class _ScheduleTravelPageState extends State<ScheduleTravelPage> {
  final GlobalKey<ScaffoldState> _scaffoldKey = GlobalKey();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      key: _scaffoldKey,
      appBar: AppBar(
        title: Text(
          "Programa tu salida",
          style: Theme.of(context).textTheme.titleLarge!.copyWith(
                fontSize: 16.0,
                fontWeight: FontWeight.w800,
              ),
        ),
        centerTitle: true,
        iconTheme: const IconThemeData(color: Colors.black),
        leading: IconButton(
          splashColor: Colors.grey,
          icon: const Icon(Icons.menu),
          onPressed: () {
            _scaffoldKey.currentState?.openDrawer();
          },
        ),
      ),
      body: Container(
        alignment: Alignment.bottomCenter,
        padding: const EdgeInsets.all(20.0),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.end,
          children: <Widget>[
            const Expanded(
              child: Center(
                child: FlutterLogo(size: 100.0),
              ),
            ),
            Text(
              'Programador de salidas',
              style: Theme.of(context).textTheme.titleLarge!.copyWith(
                    fontSize: 30.0,
                    color: Colors.orange,
                    fontWeight: FontWeight.w800,
                  ),
            ),
            const SizedBox(height: 16.0),
            Container(
              alignment: Alignment.centerLeft,
              child: Text(
                'Transita con seguridad y evitando filas interminables.',
                style: Theme.of(context).textTheme.headlineSmall!.copyWith(
                      fontSize: 18.0,
                      fontWeight: FontWeight.w700,
                    ),
              ),
            ),
            const SizedBox(height: 16.0),
            Container(
              alignment: Alignment.centerLeft,
              child: Text(
                'Completa el siguiente formulario, el sistema te generará una hoja de ruta de los mejores lugares en la ciudad para desarrollar tus actividades.',
                style: Theme.of(context)
                    .textTheme
                    .headlineSmall!
                    .copyWith(fontSize: 16.0),
              ),
            ),
            const SizedBox(height: 20.0),
            const Divider(),
            ListTile(
              onTap: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) => const TravelSchedulerInputPage(),
                  ),
                );
              },
              title: Text(
                "Comenzar",
                style: Theme.of(context)
                    .textTheme
                    .titleLarge!
                    .copyWith(fontSize: 20.0, fontWeight: FontWeight.w700),
              ),
              trailing:
                  const Icon(Icons.play_arrow, size: 40.0, color: Colors.green),
              contentPadding: const EdgeInsets.all(0.0),
            ),
            const SizedBox(height: 10.0),
          ],
        ),
      ),
    );
  }
}
