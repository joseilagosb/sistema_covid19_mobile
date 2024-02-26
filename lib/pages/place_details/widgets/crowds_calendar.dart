import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import 'package:vacapp_mobile/common_widgets/custom_dropdown.dart';

import 'package:vacapp_mobile/pages/place_details/bloc/crowds_calendar/crowds_calendar_bloc.dart';
import 'package:vacapp_mobile/pages/place_details/models/place.dart';

class CrowdsCalendar extends StatefulWidget {
  const CrowdsCalendar({super.key, required this.bloc, required this.place});
  final CrowdsCalendarBloc bloc;
  final Place place;

  static Widget create(Place place) {
    return BlocProvider(
      create: (_) => CrowdsCalendarBloc(),
      child: Builder(
        builder: (context) {
          CrowdsCalendarBloc bloc = BlocProvider.of<CrowdsCalendarBloc>(context);
          return CrowdsCalendar(bloc: bloc, place: place);
        },
      ),
    );
  }

  @override
  State<CrowdsCalendar> createState() => _CrowdsCalendarState();
}

class _CrowdsCalendarState extends State<CrowdsCalendar> {
  @override
  void initState() {
    super.initState();
    widget.bloc.add(InitDropdown(place: widget.place));
  }

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<CrowdsCalendarBloc, CrowdsCalendarState>(builder: (context, state) {
      if (state is CrowdsCalendarInitial) {
        return Container();
      } else if (state is CrowdsCalendarReady) {
        return Column(
          children: [
            Container(
              padding: const EdgeInsets.all(20),
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(20),
                color: Colors.white,
                boxShadow: [
                  BoxShadow(
                    offset: const Offset(0, 4),
                    blurRadius: 30,
                    color: const Color(0xFFB7B7B7).withOpacity(.08),
                  ),
                ],
              ),
              child: Column(
                children: [_renderDropdownButtons(state), _renderCounters(state)],
              ),
            )
          ],
        );
      } else {
        return Container();
      }
    });
  }

  Row _renderDropdownButtons(CrowdsCalendarReady state) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.start,
      children: [
        CustomDropdown(
          items: state.dayItemsMap,
          value: state.selectedDay,
          onChanged: (value) => widget.bloc.add(ChangeDay(day: value!, place: widget.place)),
        ),
        const SizedBox(width: 20),
        CustomDropdown(
          items: state.hourItemsMap,
          value: state.selectedHour,
          onChanged: (value) => widget.bloc.add(ChangeHour(hour: value!, place: widget.place)),
        ),
      ],
    );
  }

  Row _renderCounters(CrowdsCalendarReady state) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Counter(
          color: Colors.green,
          value: state.selectedCrowd,
          title: "Personas adentro del recinto",
          category: "crowd",
        ),
        Counter(
          color: Colors.red,
          value: state.selectedQueue,
          title: "Personas esperando en la fila",
          category: "queue",
        ),
        Counter(
          color: Colors.blue,
          value: Place.getPopulationDensity(
            state.selectedCrowd,
            state.selectedQueue,
            widget.place.attentionSurface,
          ).toStringAsFixed(2),
          title: "Densidad por cada 10 m\u00B2",
          category: "waiting-time",
        ),
      ],
    );
  }
}

class Counter extends StatelessWidget {
  final dynamic value;
  final Color color;
  final String title;
  final String category;
  const Counter({
    super.key,
    required this.value,
    required this.color,
    required this.title,
    required this.category,
  });

  @override
  Widget build(BuildContext context) {
    return Expanded(
      child: Column(
        children: <Widget>[
          Container(
            padding: const EdgeInsets.all(6),
            height: 50,
            width: 50,
            decoration: BoxDecoration(
              image: DecorationImage(
                  image: AssetImage('assets/icons/crowdness/$category.png'), fit: BoxFit.fill),
            ),
          ),
          const SizedBox(height: 10),
          Text(
            "$value",
            style: TextStyle(
              fontSize: 30,
              color: color,
            ),
          ),
          SizedBox(
            width: 100,
            child: Text(
              title,
              style: const TextStyle(fontSize: 16, color: Color(0xFF959595)),
              textAlign: TextAlign.center,
            ),
          ),
        ],
      ),
    );
  }
}
