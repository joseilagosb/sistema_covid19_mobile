import 'package:flutter/material.dart';
import 'package:flutter/cupertino.dart';
import 'package:url_launcher/url_launcher.dart';
import 'package:vacapp_mobile/classes/indicator.dart';
import 'package:vacapp_mobile/classes/place.dart';
import 'package:vacapp_mobile/pages/send_feedback/send_feedback_input_page.dart';
import 'package:vacapp_mobile/pages/send_feedback/login_page.dart';
import 'package:vacapp_mobile/services/dummy_functions.dart';
import 'package:vacapp_mobile/services/graphql_functions.dart';
import 'package:vacapp_mobile/utils/constants.dart';

class SendFeedbackPage extends StatefulWidget {
  const SendFeedbackPage({super.key});

  @override
  _SendFeedbackPageState createState() => _SendFeedbackPageState();
}

class _SendFeedbackPageState extends State<SendFeedbackPage> {
  final GlobalKey<ScaffoldState> _scaffoldKey = GlobalKey();
  late List<Place> lastVisitedPlaces;
  late List<Indicator> indicators;
  bool isLoading = true;

  int selectedIndex = 1;

  void _openRegistrationInBrowser() async {
    Uri uri = Uri(path: 'http://192.168.0.9:3000/collab');
    if (await canLaunchUrl(uri)) {
      await launchUrl(uri);
      print('hi im here bro');
    } else {
      throw "No se pudo abrir ${uri.path}";
    }
  }

  void _openLoginPage(BuildContext context) {
    Navigator.push(
        context, MaterialPageRoute(builder: (context) => LoginPage()));
  }

  @override
  void initState() {
    super.initState();

    //IMPLEMENTAR CON VALORES ALMACENADOS EN LA CACHE DEL USUARIO
    //Cuando se cambien los valores, isLoading pasará a ser lastVisitedPlaces == null para el dropdownbutton
    DummyFunctions.fillPlacesLocal().then((places) {
      setState(() {
        lastVisitedPlaces = places;
      });

      GraphQLFunctions.fillIndicatorsList().then((resultIndicators) {
        setState(() {
          indicators = resultIndicators;
          isLoading = false;
        });
      });
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      key: _scaffoldKey,
      appBar: AppBar(
        title: Text(
          "Ayúdanos",
          style: Theme.of(context)
              .textTheme
              .titleLarge!
              .copyWith(fontSize: 16.0, fontWeight: FontWeight.w800),
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
        padding: EdgeInsets.all(20.0),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.end,
          children: <Widget>[
            const Expanded(
              child: Center(
                child: FlutterLogo(
                  // colors: Colors.orange,
                  size: 100.0,
                ),
              ),
            ),
            const SizedBox(height: 16.0),
            Container(
              alignment: Alignment.centerLeft,
              child: Text(
                'En tiempos como estos, la información precisa puede marcar la diferencia para vencer al COVID-19.',
                textAlign: TextAlign.center,
                style: Theme.of(context)
                    .textTheme
                    .titleLarge!
                    .copyWith(fontSize: 16.0, fontWeight: FontWeight.w600),
              ),
            ),
            const Divider(),
            Column(
              children: <Widget>[
                Container(
                  alignment: Alignment.centerLeft,
                  child: Text(
                    'Súmate a la red de colaboradores VACAPP para crear un mejor entorno entre todos.',
                    textAlign: TextAlign.center,
                    style: Theme.of(context)
                        .textTheme
                        .headlineSmall!
                        .copyWith(fontSize: 16.0),
                  ),
                ),
                const SizedBox(height: 5),
                Container(
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: <Widget>[
                      ElevatedButton(
                        onPressed: _openRegistrationInBrowser,
                        child: Text(
                          'Inscribirme',
                          style: Theme.of(context)
                              .textTheme
                              .titleLarge!
                              .copyWith(fontWeight: FontWeight.w800),
                        ),
                      ),
                      const SizedBox(width: 5),
                      ElevatedButton(
                        onPressed: () => _openLoginPage(context),
                        child: Text(
                          'Conectarme',
                          style: Theme.of(context)
                              .textTheme
                              .titleLarge!
                              .copyWith(fontWeight: FontWeight.w800),
                        ),
                      )
                    ],
                  ),
                ),
              ],
            ),
            const SizedBox(height: 5),
            ListTile(
              enabled: !isLoading,
              contentPadding: const EdgeInsets.all(0.0),
              dense: true,
              onTap: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) => SendFeedbackInputPage(
                      placeId: lastVisitedPlaces[selectedIndex].getId(),
                      placeName: lastVisitedPlaces[selectedIndex].getName(),
                      indicators: indicators
                          .where((indicator) => Constants
                              .COVID_SAFETY_INDICATORS
                              .contains(indicator.getName()))
                          .toList(),
                    ),
                  ),
                );
              },
              title: Text(
                "Encuesta de seguridad COVID-19",
                style: Theme.of(context)
                    .textTheme
                    .titleLarge!
                    .copyWith(fontSize: 20.0, fontWeight: FontWeight.w600),
              ),
              trailing: Icon(
                Icons.play_arrow,
                size: 40.0,
                color: isLoading ? Colors.grey : Colors.green,
              ),
            ),
            const Divider(),
            ListTile(
              dense: true,
              contentPadding: const EdgeInsets.all(0.0),
              onTap: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) => SendFeedbackInputPage(
                      placeId: lastVisitedPlaces[selectedIndex].getId(),
                      placeName: lastVisitedPlaces[selectedIndex].getName(),
                      indicators: indicators
                          .where((indicator) => Constants
                              .SERVICE_QUALITY_INDICATORS
                              .contains(indicator.getName()))
                          .toList(),
                    ),
                  ),
                );
              },
              title: Text("Encuesta de calidad de servicio",
                  style: Theme.of(context)
                      .textTheme
                      .titleLarge!
                      .copyWith(fontSize: 20.0, fontWeight: FontWeight.w600)),
              trailing: Icon(Icons.play_arrow,
                  size: 40.0, color: isLoading ? Colors.grey : Colors.green),
            ),
            const SizedBox(height: 10.0),
          ],
        ),
      ),
    );
  }
}




              //   Container(
              //       height: 50.0,
              //       padding: EdgeInsets.symmetric(horizontal: 10.0),
              //       decoration: BoxDecoration(
              //         borderRadius: BorderRadius.circular(20.0),
              //         color: Colors.orange[200],
              //       ),
              //       child: DropdownButton(
              //           value: isLoading ? null : _selectedIndex,
              //           dropdownColor: Colors.orangeAccent,
              //           items: isLoading
              //               ? null
              //               : List.generate(lastVisitedPlaces.length, (index) {
              //                   print(lastVisitedPlaces.length);
              //                   return DropdownMenuItem(
              //                     value: index,
              //                     child: Text(lastVisitedPlaces[index].getName()),
              //                   );
              //                 }),
              //           onChanged: (selectedIndex) {
              //             if (!isLoading)
              //               setState(() {
              //                 _selectedIndex = selectedIndex;
              //               });
              //           }))







              
            // ListTile(
            //   dense: true,
            //   contentPadding: EdgeInsets.all(0.0),
            //   onTap: () {
            //     Navigator.push(
            //         context,
            //         MaterialPageRoute(
            //             builder: (context) => PlaceReportInputPage(
            //                   placeId:
            //                       lastVisitedPlaces[_selectedIndex].getId(),
            //                   placeName:
            //                       lastVisitedPlaces[_selectedIndex].getName(),
            //                 )));
            //   },
            //   title: Text("Reporte de visita a lugar",
            //       style: Theme.of(context)
            //           .textTheme
            //           .headline6
            //           .copyWith(fontSize: 20.0, fontWeight: FontWeight.w600)),
            //   trailing: Icon(Icons.play_arrow,
            //       size: 40.0, color: isLoading ? Colors.grey : Colors.green),
            // ),