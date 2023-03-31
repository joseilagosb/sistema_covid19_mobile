import 'package:flutter/material.dart';
import 'package:flutter/cupertino.dart';

class TravelRequirements extends StatefulWidget {
  const TravelRequirements({super.key});

  @override
  _TravelRequirementsState createState() => _TravelRequirementsState();
}

class _TravelRequirementsState extends State<TravelRequirements> {
  @override
  Widget build(BuildContext context) {
    return Column(
      children: <Widget>[
        Text("Requisitos del viaje",
            style: Theme.of(context)
                .textTheme
                .headlineSmall!
                .copyWith(fontSize: 20.0, fontWeight: FontWeight.w800)),
        const SizedBox(height: 5),
        Expanded(
          child: SingleChildScrollView(
            child: Column(
              children: <Widget>[
                const SizedBox(height: 5),
                Container(
                  alignment: Alignment.centerLeft,
                  child: RichText(
                    text: TextSpan(
                      children: [
                        TextSpan(
                            text: "Filtro: ",
                            style: Theme.of(context)
                                .textTheme
                                .titleLarge!
                                .copyWith(
                                    fontSize: 16.0,
                                    fontWeight: FontWeight.w800)),
                        TextSpan(
                            text: 'Por tipos de lugar',
                            style: Theme.of(context)
                                .textTheme
                                .titleLarge!
                                .copyWith(fontSize: 16.0)),
                      ],
                    ),
                  ),
                ),
                Container(
                  alignment: Alignment.centerLeft,
                  child: RichText(
                    text: TextSpan(
                      children: [
                        TextSpan(
                            text: "Dia y hora de salida: ",
                            style: Theme.of(context)
                                .textTheme
                                .titleLarge!
                                .copyWith(
                                    fontSize: 16.0,
                                    fontWeight: FontWeight.w800)),
                        TextSpan(
                            text: 'Martes 17:35 horas',
                            style: Theme.of(context)
                                .textTheme
                                .titleLarge!
                                .copyWith(fontSize: 16.0)),
                      ],
                    ),
                  ),
                ),
                Container(
                  alignment: Alignment.centerLeft,
                  child: RichText(
                    text: TextSpan(
                      children: [
                        TextSpan(
                            text: "Categoría de los indicadores: ",
                            style: Theme.of(context)
                                .textTheme
                                .titleLarge!
                                .copyWith(
                                    fontSize: 16.0,
                                    fontWeight: FontWeight.w800)),
                        TextSpan(
                            text: 'Calidad de servicio',
                            style: Theme.of(context)
                                .textTheme
                                .titleLarge!
                                .copyWith(fontSize: 16.0)),
                      ],
                    ),
                  ),
                ),
                Container(
                  alignment: Alignment.centerLeft,
                  child: RichText(
                    text: TextSpan(
                      children: [
                        TextSpan(
                            text: "Prioridad de cálculo: ",
                            style: Theme.of(context)
                                .textTheme
                                .titleLarge!
                                .copyWith(
                                    fontSize: 16.0,
                                    fontWeight: FontWeight.w800)),
                        TextSpan(
                            text: 'Distancia al punto de partida',
                            style: Theme.of(context)
                                .textTheme
                                .titleLarge!
                                .copyWith(fontSize: 16.0)),
                      ],
                    ),
                  ),
                ),
                Container(
                  alignment: Alignment.centerLeft,
                  child: RichText(
                    text: TextSpan(
                      children: [
                        TextSpan(
                            text: "Medio de transporte: ",
                            style: Theme.of(context)
                                .textTheme
                                .titleLarge!
                                .copyWith(
                                    fontSize: 16.0,
                                    fontWeight: FontWeight.w800)),
                        TextSpan(
                            text: 'Vehicular',
                            style: Theme.of(context)
                                .textTheme
                                .titleLarge!
                                .copyWith(fontSize: 16.0)),
                      ],
                    ),
                  ),
                ),
                const SizedBox(height: 10),
                Text('Parámetros',
                    style: Theme.of(context)
                        .textTheme
                        .titleLarge!
                        .copyWith(fontSize: 16.0, fontWeight: FontWeight.w800)),
                ListTile(
                    dense: true,
                    leading: Image.asset("assets/icons/placeservices/8.png"),
                    contentPadding: const EdgeInsets.all(0.0),
                    title: const Text('Atención ambulatoria')),
                ListTile(
                    dense: true,
                    leading: Image.asset("assets/icons/placeservices/9.png"),
                    contentPadding: const EdgeInsets.all(0.0),
                    title: const Text('Caja vecina')),
                ListTile(
                    dense: true,
                    leading: Image.asset("assets/icons/placeservices/11.png"),
                    contentPadding: const EdgeInsets.all(0.0),
                    title: const Text('Depósito de dinero -- Santander'))
              ],
            ),
          ),
        ),
      ],
    );
  }
}
