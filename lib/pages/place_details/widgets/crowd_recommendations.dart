import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:vacapp_mobile/constants/values.dart';

import 'package:vacapp_mobile/common_widgets/custom_dropdown.dart';

import 'package:vacapp_mobile/pages/place_details/bloc/crowd_recommendations/crowd_recommendations_bloc.dart';
import 'package:vacapp_mobile/pages/place_details/models/place.dart';

class CrowdRecommendations extends StatefulWidget {
  const CrowdRecommendations({
    super.key,
    required this.bloc,
    required this.place,
    required this.crowdReport,
  });
  final CrowdRecommendationsBloc bloc;
  final Place place;
  final Map<String, dynamic> crowdReport;

  static Widget create(Place place, Map<String, dynamic> crowdReport) {
    return BlocProvider(
      create: (_) => CrowdRecommendationsBloc(),
      child: Builder(
        builder: (context) {
          CrowdRecommendationsBloc bloc = BlocProvider.of<CrowdRecommendationsBloc>(context);
          return CrowdRecommendations(bloc: bloc, place: place, crowdReport: crowdReport);
        },
      ),
    );
  }

  @override
  State<CrowdRecommendations> createState() => _CrowdRecommendationsState();
}

class _CrowdRecommendationsState extends State<CrowdRecommendations> {
  @override
  void initState() {
    super.initState();
    widget.bloc.add(InitDropdowns(crowdReport: widget.crowdReport));
  }

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<CrowdRecommendationsBloc, CrowdRecommendationsState>(
        builder: (context, state) {
      if (state is CrowdRecommendationsInitial) {
        return Container();
      } else if (state is CrowdRecommendationsReady) {
        return Column(children: [
          _buildTodayAndVariousReport(state),
          const SizedBox(height: 20.0),
          _buildWeeklyReport(state),
        ]);
      } else {
        return Container();
      }
    });
  }

  Widget _buildTodayAndVariousReport(CrowdRecommendationsReady state) {
    if (!widget.place.isCurrentlyOpen() && !widget.place.opensToday()) {
      return Container();
    }

    Map<String, dynamic> todayReport = widget.crowdReport["today_crowd_report"];
    Map<String, dynamic> variousReport = widget.crowdReport["various"];

    return Column(
      children: [
        Row(
          children: <Widget>[
            RichText(
              text: TextSpan(
                children: [
                  TextSpan(
                    text: "Reporte del día\n",
                    style: Theme.of(context)
                        .textTheme
                        .titleLarge!
                        .copyWith(fontSize: 18.0, fontWeight: FontWeight.w700),
                  ),
                  TextSpan(
                    text: "Planifica tu salida con estas indicaciones",
                    style: Theme.of(context)
                        .textTheme
                        .titleLarge!
                        .copyWith(fontSize: 14.0, fontWeight: FontWeight.w600, color: Colors.grey),
                  ),
                ],
              ),
            ),
          ],
        ),
        const SizedBox(height: 20),
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
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              CustomDropdown(
                items: state.todayPeriodItems,
                value: state.currentTodayPeriod,
                onChanged: (value) => widget.bloc.add(ChangeTodayPeriod(period: value!)),
              ),
              const SizedBox(height: 10),
              CrowdIndicator(
                text: "Mayor afluencia",
                hour: todayReport['highest_today_crowd'][state.currentTodayPeriod]['hour'],
                peopleNo: todayReport['highest_today_crowd'][state.currentTodayPeriod]['people_no'],
                color: Colors.red,
                textColor: Colors.white,
              ),
              const SizedBox(height: 10),
              CrowdIndicator(
                text: "Menor afluencia",
                hour: todayReport['lowest_today_crowd'][state.currentTodayPeriod]['hour'],
                peopleNo: todayReport['lowest_today_crowd'][state.currentTodayPeriod]['people_no'],
                color: Colors.green,
                textColor: Colors.white,
              ),
              const SizedBox(height: 10),
              variousReport["tomorrow_people_no_at_same_time"] > -1
                  ? CrowdIndicator(
                      text: "Afluencia mañana a la misma hora",
                      peopleNo: variousReport["tomorrow_people_no_at_same_time"],
                      color: Colors.yellow,
                      textColor: Colors.black,
                    )
                  : Container(),
              const SizedBox(height: 10),
              variousReport["least_crowded_day_same_time"] > -1
                  ? Container(
                      padding: const EdgeInsets.all(10),
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(20),
                        color: Colors.greenAccent,
                      ),
                      child: Text(
                        'El ${Values.daysOfWeek[variousReport['least_crowded_day_same_time'] - 1]} generalmente se encuentra más expedito a esta hora',
                        textAlign: TextAlign.center,
                        style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 18.0),
                      ),
                    )
                  : Container(),
            ],
          ),
        )
      ],
    );
  }

  Widget _buildWeeklyReport(CrowdRecommendationsReady state) {
    List<Map<String, dynamic>> weekReport =
        List<Map<String, dynamic>>.from(widget.crowdReport["week_crowd_report"]);

    return Column(
      children: [
        Row(
          children: <Widget>[
            Expanded(
              child: RichText(
                text: TextSpan(
                  children: [
                    TextSpan(
                      text: "Reporte semanal\n",
                      style: Theme.of(context)
                          .textTheme
                          .titleLarge!
                          .copyWith(fontSize: 18.0, fontWeight: FontWeight.w700),
                    ),
                    TextSpan(
                      text: "Te mostramos el balance de este recinto durante el resto de la semana",
                      style: Theme.of(context).textTheme.titleLarge!.copyWith(
                          fontSize: 14.0, fontWeight: FontWeight.w600, color: Colors.grey),
                    ),
                  ],
                ),
              ),
            )
          ],
        ),
        const SizedBox(height: 20),
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
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                children: [
                  CustomDropdown(
                    items: state.weekDayTypeItems,
                    value: state.currentWeekDayType,
                    onChanged: (value) => widget.bloc.add(ChangeWeekDayType(dayType: value!)),
                  ),
                  const SizedBox(width: 10.0),
                  CustomDropdown(
                    items: state.weekPeriodItems,
                    value: state.currentWeekPeriod,
                    onChanged: (value) => widget.bloc.add(ChangeWeekPeriod(period: value!)),
                  ),
                ],
              ),
              CrowdIndicator(
                text: "Mayor afluencia promedio",
                peopleNo: weekReport[state.currentWeekDayType]["highest_average_crowd"]
                    [state.currentWeekPeriod]["people_no"],
                hour: weekReport[state.currentWeekDayType]["highest_average_crowd"]
                    [state.currentWeekPeriod]["hour"],
                color: Colors.red,
                textColor: Colors.white,
              ),
              const SizedBox(height: 20.0),
              CrowdIndicator(
                text: "Menor afluencia promedio",
                peopleNo: weekReport[state.currentWeekDayType]["lowest_average_crowd"]
                    [state.currentWeekPeriod]["people_no"],
                hour: weekReport[state.currentWeekDayType]["lowest_average_crowd"]
                    [state.currentWeekPeriod]["hour"],
                color: Colors.green,
                textColor: Colors.white,
              ),
              const SizedBox(height: 20.0),
              CrowdIndicator(
                text: "Afluencia promedio en esta jornada",
                peopleNo: weekReport[state.currentWeekDayType]["average_people_no"]
                    [state.currentWeekPeriod]["people_no"],
                hour: weekReport[state.currentWeekDayType]["average_people_no"]
                    [state.currentWeekPeriod]["hour"],
                color: Colors.orange,
                textColor: Colors.black,
              ),
              const SizedBox(height: 20.0),
            ],
          ),
        ),
      ],
    );
  }
}

class CrowdIndicator extends StatelessWidget {
  const CrowdIndicator({
    super.key,
    required this.text,
    this.hour,
    required this.peopleNo,
    required this.color,
    required this.textColor,
  });
  final String text;
  final int? hour;
  final int peopleNo;
  final Color color;
  final Color textColor;

  @override
  Widget build(BuildContext context) {
    return Row(
      children: <Widget>[
        Expanded(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: <Widget>[
              Text(text, style: Theme.of(context).textTheme.titleLarge!),
              hour != null
                  ? Text("${hour!}:00",
                      style: Theme.of(context).textTheme.titleLarge!.copyWith(fontSize: 18.0))
                  : Container()
            ],
          ),
        ),
        const SizedBox(width: 20),
        Container(
          width: 40,
          height: 40,
          decoration: BoxDecoration(color: color, shape: BoxShape.circle),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: <Widget>[
              Text("$peopleNo",
                  style: Theme.of(context).textTheme.titleLarge!.copyWith(color: textColor)),
            ],
          ),
        ),
      ],
    );
  }
}
