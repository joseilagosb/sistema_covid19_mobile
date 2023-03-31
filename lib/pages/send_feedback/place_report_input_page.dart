import 'package:flutter/material.dart';

import 'package:flutter/cupertino.dart';
import 'package:flutter/services.dart';
import 'package:vacapp_mobile/utils/constants.dart';

class PlaceReportInputPage extends StatefulWidget {
  final int placeId;
  final String placeName;

  const PlaceReportInputPage(
      {super.key, required this.placeId, required this.placeName});

  @override
  _PlaceReportInputPageState createState() => _PlaceReportInputPageState();
}

class _PlaceReportInputPageState extends State<PlaceReportInputPage> {
  final GlobalKey<ScaffoldState> _scaffoldKey = GlobalKey();

  AutovalidateMode _autoValidateMode = AutovalidateMode.disabled;
  late int queuePeopleNo;
  late int waitingTimeOnQueue;
  late int reportDayOfWeek;
  late TimeOfDay reportTime;

  late int currentQuestionNo;
  late String option;

  PageController pageController = PageController();
  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();

  void initState() {
    reportTime = TimeOfDay.fromDateTime(DateTime.now());

    super.initState();
  }

  Future<bool> _onWillPop() async {
    return await showDialog(
          context: context,
          builder: (context) => AlertDialog(
            title: const Text('¿Deseas salir de esta pantalla?'),
            content: const Text('Tu progreso se perderá.'),
            actions: <Widget>[
              TextButton(
                onPressed: () => Navigator.of(context).pop(false),
                child: const Text('No'),
              ),
              TextButton(
                onPressed: () => Navigator.of(context).pop(true),
                child: const Text('Sí'),
              ),
            ],
          ),
        ) ??
        false;
  }

  Future<void> _selectTime(BuildContext context) async {
    final TimeOfDay? pickedTime =
        await showTimePicker(context: context, initialTime: reportTime);
    if (pickedTime == null) {
      return;
    }
    if (pickedTime != reportTime) {
      setState(() {
        reportTime = pickedTime;
      });
    }
  }

  String? _validateQueuePeopleNo(String? value) {
    if (value == null) {
      return 'Ingrese un valor';
    }
    int numericValue = int.parse(value);
    if (numericValue < 0) {
      return 'Por favor, ingrese un valor no negativo';
    } else if (numericValue > 50) {
      return 'Por favor, ingrese un valor que se ajuste a los límites.';
    } else {
      return null;
    }
  }

  String? _validateWaitingTime(String? value) {
    if (value == null) {
      return 'Ingrese un valor';
    }
    int numericValue = int.parse(value);
    if (numericValue < 0) {
      return 'Por favor, ingrese un valor no negativo';
    } else if (numericValue > 120) {
      return 'Por favor, ingrese un valor que se ajuste a los límites.';
    } else {
      return null;
    }
  }

  void _validateInputs() {
    final form = _formKey.currentState;

    if (form == null) {
      return;
    }

    if (form.validate()) {
      // Text forms has validated.
      // Let's validate radios and checkbox
      // if (radioValue < 0) {
      //   // None of the radio buttons was selected
      //   _showSnackBar('Please select your gender');
      // } else if (!_termsChecked) {
      //   // The checkbox wasn't checked
      //   _showSnackBar("Please accept our terms");
      // } else {
      // Every of the data in the form are valid at this point
      form.save();
      showDialog(
        context: context,
        builder: (BuildContext context) => const AlertDialog(
          content: Text("All inputs are valid"),
        ),
      );
      // }
    } else {
      setState(() => _autoValidateMode = AutovalidateMode.always);
    }
  }

  void _showSnackBar(message) {
    final snackBar = SnackBar(
      content: Text(message),
    );
    ScaffoldMessenger.of(context).showSnackBar(snackBar);
    // _scaffoldKey.currentState.showSnackBar(snackBar);
  }

  void _showUserAgreementDialog() {
    showDialog(
      context: context,
      builder: (BuildContext context) => const AlertDialog(
        content: Text("Juro decir la verdad y nada más que la verdad"),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return WillPopScope(
      onWillPop: _onWillPop,
      child: Scaffold(
        key: _scaffoldKey,
        appBar: AppBar(
          title: Text(
            widget.placeName,
            style: Theme.of(context)
                .textTheme
                .titleLarge!
                .copyWith(fontSize: 16.0, fontWeight: FontWeight.w800),
          ),
          backgroundColor: Colors.orangeAccent,
          centerTitle: true,
          iconTheme: const IconThemeData(color: Colors.black),
          leading: Tooltip(
            message: "Salir de la pantalla",
            child: IconButton(
              splashColor: Colors.grey,
              icon: const Icon(Icons.close),
              onPressed: () => Navigator.of(context).maybePop(),
            ),
          ),
        ),
        body: Container(
          padding: const EdgeInsets.all(10.0),
          height: double.infinity,
          child: Column(
            children: <Widget>[
              const SizedBox(height: 10.0),
              const Expanded(
                child: Center(child: FlutterLogo(size: 100.0)),
              ),
              const SizedBox(height: 20),
              Text(
                'Reporte de visita a lugar',
                textAlign: TextAlign.center,
                style: Theme.of(context).textTheme.headlineSmall!.copyWith(
                      color: Colors.orangeAccent,
                      fontWeight: FontWeight.w800,
                    ),
              ),
              const SizedBox(height: 10),
              Text(
                "Tus opiniones deben ajustarse a la experiencia vivida previa a recibir el servicio.",
                textAlign: TextAlign.center,
                style: Theme.of(context)
                    .textTheme
                    .headlineSmall!
                    .copyWith(color: Colors.grey[700], fontSize: 18.0),
              ),
              const SizedBox(height: 20.0),
              Container(
                margin: const EdgeInsets.symmetric(horizontal: 20.0),
                child: Form(
                  key: _formKey,
                  autovalidateMode: _autoValidateMode,
                  child: Column(
                    children: <Widget>[
                      TextFormField(
                        keyboardType: TextInputType.number,
                        inputFormatters: <TextInputFormatter>[
                          FilteringTextInputFormatter.digitsOnly
                        ],
                        decoration: const InputDecoration(
                            labelText: 'Número de personas esperando'),
                        style: Theme.of(context)
                            .textTheme
                            .titleLarge!
                            .copyWith(fontSize: 16.0),
                        onSaved: (String? value) {
                          queuePeopleNo = value != null ? int.parse(value) : 0;
                        },
                        validator: _validateQueuePeopleNo,
                      ),
                      const SizedBox(height: 20.0),
                      TextFormField(
                        keyboardType: TextInputType.number,
                        inputFormatters: <TextInputFormatter>[
                          FilteringTextInputFormatter.digitsOnly
                        ],
                        decoration: const InputDecoration(
                            labelText: 'Tiempo de espera en la fila'),
                        style: Theme.of(context)
                            .textTheme
                            .titleLarge!
                            .copyWith(fontSize: 16.0),
                        onSaved: (String? value) {
                          waitingTimeOnQueue =
                              value != null ? int.parse(value) : 0;
                        },
                        validator: _validateWaitingTime,
                      ),
                      const SizedBox(height: 20.0),
                      Container(
                          alignment: Alignment.centerLeft,
                          child: Text('Día y hora del reporte',
                              style: Theme.of(context)
                                  .textTheme
                                  .headlineSmall!
                                  .copyWith(fontSize: 16.0))),
                      const SizedBox(height: 10.0),
                      Row(
                        children: <Widget>[
                          Expanded(
                            child: Container(
                                height: 50.0,
                                padding: const EdgeInsets.symmetric(
                                  horizontal: 10.0,
                                ),
                                decoration: BoxDecoration(
                                  borderRadius: BorderRadius.circular(20.0),
                                  color: Colors.orange[200],
                                ),
                                child: DropdownButton(
                                  isExpanded: true,
                                  dropdownColor: Colors.orangeAccent,
                                  value: reportDayOfWeek,
                                  style: Theme.of(context)
                                      .textTheme
                                      .headlineSmall!
                                      .copyWith(fontSize: 20.0),
                                  onChanged: (index) {
                                    setState(() {
                                      reportDayOfWeek = index ?? 1;
                                    });
                                  },
                                  items: List.generate(
                                      Constants.DAYS_OF_WEEK.length, (index) {
                                    return DropdownMenuItem(
                                      value: index,
                                      child:
                                          Text(Constants.DAYS_OF_WEEK[index]),
                                    );
                                  }),
                                )),
                          ),
                          const SizedBox(width: 5),
                          Expanded(
                            child: Container(
                              height: 50.0,
                              padding:
                                  const EdgeInsets.symmetric(horizontal: 10.0),
                              decoration: BoxDecoration(
                                borderRadius: BorderRadius.circular(20.0),
                                color: Colors.orange[200],
                              ),
                              child: GestureDetector(
                                onTap: () {
                                  _selectTime(context);
                                },
                                child: Row(
                                  children: <Widget>[
                                    Text(reportTime.format(context),
                                        style: Theme.of(context)
                                            .textTheme
                                            .headlineSmall!
                                            .copyWith(fontSize: 20.0)),
                                    const Spacer(),
                                    const Icon(Icons.edit),
                                  ],
                                ),
                              ),
                            ),
                          )
                        ],
                      )
                    ],
                  ),
                ),
              ),
              const SizedBox(height: 20.0),
              Container(
                width: MediaQuery.of(context).size.width * .75,
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(20.0),
                  color: Colors.orange[200],
                ),
                child: ListTile(
                  dense: true,
                  contentPadding: const EdgeInsets.symmetric(horizontal: 10.0),
                  onTap: () {
                    _showUserAgreementDialog();
                  },
                  leading: Checkbox(value: false, onChanged: (value) {}),
                  title: Text("Acuerdo de usuario",
                      style: Theme.of(context).textTheme.titleLarge!.copyWith(
                          fontSize: 14.0, fontWeight: FontWeight.w600)),
                  trailing: const Icon(Icons.supervised_user_circle),
                ),
              ),
              const SizedBox(height: 10.0),
              const Divider(),
              Row(
                children: <Widget>[
                  const Spacer(),
                  SizedBox(
                    height: 50.0,
                    child: GestureDetector(
                      onTap: () {
                        _validateInputs();
                      },
                      child: const Center(
                        child: Text(
                          'Enviar',
                          style: TextStyle(
                            fontSize: 20.0,
                            color: Colors.orangeAccent,
                          ),
                        ),
                      ),
                    ),
                  )
                ],
              )
            ],
          ),
        ),
      ),
    );
  }
}
