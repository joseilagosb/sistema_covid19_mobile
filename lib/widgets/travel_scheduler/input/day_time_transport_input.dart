import 'package:flutter/material.dart';
import 'package:flutter/cupertino.dart';
import 'package:vacapp_mobile/utils/constants.dart';

class DayTimeTransportInputPage extends StatefulWidget {
  DayTimeTransportInputPage(
      {super.key, required this.onChangedInputField, this.initialValues});
  final Function onChangedInputField;
  final Map<String, dynamic>? initialValues;

  @override
  _DayTimeTransportInputPageState createState() =>
      _DayTimeTransportInputPageState();
}

class _DayTimeTransportInputPageState extends State<DayTimeTransportInputPage> {
  late int _selectedDay;
  late TimeOfDay _selectedTime;
  late int _selectedTransportType;
  late int _selectedPreference;
  late int _selectedIndicatorCategory;

  final List<String> _transportTypes = [
    "Locomoción colectiva",
    "Vehículo",
    "Bicicleta"
  ];
  final List<IconData> _transportTypeIcons = [
    Icons.directions_bus,
    Icons.directions_car,
    Icons.directions_bike
  ];

  Future<void> _selectTime(BuildContext context) async {
    final TimeOfDay? pickedTime =
        await showTimePicker(context: context, initialTime: _selectedTime);
    if (pickedTime != null && pickedTime != _selectedTime) {
      setState(() {
        _selectedTime = pickedTime;
        widget.onChangedInputField(
            _selectedDay,
            _selectedTime,
            _selectedTransportType,
            _selectedIndicatorCategory,
            _selectedPreference);
      });
    }
  }

  @override
  void initState() {
    super.initState();
    if (widget.initialValues == null) {
      _selectedDay = DateTime.now().weekday - 1;
      _selectedTime = TimeOfDay.fromDateTime(DateTime.now());
      _selectedTransportType = Constants.TRANSPORTTYPE_WALKING;
    } else {
      _selectedDay = widget.initialValues!["day"];
      _selectedTime = widget.initialValues!["time"];
      _selectedTransportType = widget.initialValues!["transport_type"];
    }

    _selectedIndicatorCategory = 0;
    _selectedPreference = 0;

    widget.onChangedInputField(
        _selectedDay,
        _selectedTime,
        _selectedTransportType,
        _selectedIndicatorCategory,
        _selectedPreference);
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      children: <Widget>[
        Container(
          alignment: Alignment.centerLeft,
          child: Text(
            '¿Cuándo tienes planeada tu salida?',
            style: Theme.of(context)
                .textTheme
                .headlineSmall!
                .copyWith(fontSize: 20.0, fontWeight: FontWeight.w700),
          ),
        ),
        const SizedBox(height: 10),
        Row(
          children: <Widget>[
            Expanded(
              child: Text(
                'Día: ',
                style: Theme.of(context)
                    .textTheme
                    .headlineSmall!
                    .copyWith(fontSize: 16.0, fontWeight: FontWeight.w700),
              ),
            ),
            Expanded(
              child: DropdownButton(
                isExpanded: true,
                dropdownColor: Colors.orangeAccent,
                value: _selectedDay,
                style: Theme.of(context)
                    .textTheme
                    .headlineSmall!
                    .copyWith(fontSize: 16.0),
                onChanged: (index) {
                  if (index == null) return;
                  setState(() {
                    _selectedDay = index;
                    widget.onChangedInputField(
                        _selectedDay,
                        _selectedTime,
                        _selectedTransportType,
                        _selectedIndicatorCategory,
                        _selectedPreference);
                  });
                },
                items: List.generate(
                  Constants.DAYS_OF_WEEK.length,
                  (index) {
                    return DropdownMenuItem(
                      value: index,
                      child: Text(Constants.DAYS_OF_WEEK[index]),
                    );
                  },
                ),
              ),
            ),
          ],
        ),
        Row(
          children: <Widget>[
            Expanded(
              child: Text(
                'Hora: ',
                style: Theme.of(context)
                    .textTheme
                    .headlineSmall!
                    .copyWith(fontSize: 16.0, fontWeight: FontWeight.w700),
              ),
            ),
            Expanded(
              child: GestureDetector(
                onTap: () {
                  _selectTime(context);
                },
                child: Row(
                  children: <Widget>[
                    Text(
                      _selectedTime.format(context),
                      style: Theme.of(context)
                          .textTheme
                          .headlineSmall!
                          .copyWith(fontSize: 16.0),
                    ),
                    const Spacer(),
                    const Icon(Icons.edit),
                  ],
                ),
              ),
            ),
          ],
        ),
        const SizedBox(height: 15),
        Container(
            alignment: Alignment.centerLeft,
            child: Text(
              '¿Cómo te vas a movilizar?',
              style: Theme.of(context)
                  .textTheme
                  .headlineSmall!
                  .copyWith(fontSize: 20.0, fontWeight: FontWeight.w700),
            )),
        const SizedBox(height: 10),
        Wrap(
          alignment: WrapAlignment.center,
          children: List.generate(
            _transportTypes.length,
            (index) => GestureDetector(
              onTap: () {
                setState(() {
                  _selectedTransportType = index;
                  widget.onChangedInputField(
                      _selectedDay,
                      _selectedTime,
                      _selectedTransportType,
                      _selectedIndicatorCategory,
                      _selectedPreference);
                });
              },
              child: Container(
                padding: const EdgeInsets.all(10),
                width: 100.0,
                height: 100.0,
                margin: const EdgeInsets.symmetric(horizontal: 5),
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(15),
                  color: index == _selectedTransportType
                      ? Colors.orangeAccent
                      : Colors.white,
                ),
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: <Widget>[
                    Icon(
                      _transportTypeIcons[index],
                      size: 40,
                    ),
                    Text(
                      _transportTypes[index],
                      textAlign: TextAlign.center,
                      style: Theme.of(context).textTheme.titleLarge!.copyWith(
                          fontSize: 12.0, fontWeight: FontWeight.w700),
                    ),
                  ],
                ),
              ),
            ),
          ),
        ),
        const SizedBox(height: 15),
        Container(
          alignment: Alignment.centerLeft,
          child: Text(
            '¿Qué puntuaciones quieres considerar?',
            style: Theme.of(context)
                .textTheme
                .headlineSmall!
                .copyWith(fontSize: 20.0, fontWeight: FontWeight.w700),
          ),
        ),
        DropdownButton(
          isExpanded: true,
          dropdownColor: Colors.orangeAccent,
          value: _selectedIndicatorCategory,
          style: Theme.of(context)
              .textTheme
              .headlineSmall!
              .copyWith(fontSize: 16.0),
          onChanged: (index) {
            if (index == null) return;
            setState(() {
              _selectedIndicatorCategory = index;
              widget.onChangedInputField(
                  _selectedDay,
                  _selectedTime,
                  _selectedTransportType,
                  _selectedIndicatorCategory,
                  _selectedPreference);
            });
          },
          items: const [
            DropdownMenuItem(value: 0, child: Text('Todas')),
            DropdownMenuItem(
                value: 1, child: Text('Seguridad sanitaria COVID-19')),
            DropdownMenuItem(value: 2, child: Text('Calidad de servicio')),
          ],
        ),
        const SizedBox(height: 15),
        Container(
            alignment: Alignment.centerLeft,
            child: Text(
              'Priorizar',
              style: Theme.of(context)
                  .textTheme
                  .headlineSmall!
                  .copyWith(fontSize: 20.0, fontWeight: FontWeight.w700),
            )),
        DropdownButton(
          isExpanded: true,
          dropdownColor: Colors.orangeAccent,
          value: _selectedPreference,
          style: Theme.of(context)
              .textTheme
              .headlineSmall!
              .copyWith(fontSize: 16.0),
          onChanged: (index) {
            if (index == null) return;
            setState(() {
              _selectedPreference = index;
              widget.onChangedInputField(
                  _selectedDay,
                  _selectedTime,
                  _selectedTransportType,
                  _selectedIndicatorCategory,
                  _selectedPreference);
            });
          },
          items: const [
            DropdownMenuItem(value: 0, child: Text('Orden recomendado 🐮')),
            DropdownMenuItem(value: 1, child: Text('Todos por igual')),
            DropdownMenuItem(value: 2, child: Text('Distancia')),
            DropdownMenuItem(value: 3, child: Text('Concentración de público')),
            DropdownMenuItem(
                value: 4, child: Text('Número de personas en filas')),
            DropdownMenuItem(value: 5, child: Text('Puntuaciones')),
          ],
        ),
        const SizedBox(height: 10),
      ],
    );
  }
}
