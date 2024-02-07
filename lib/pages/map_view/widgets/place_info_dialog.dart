import "package:flutter/material.dart";

import "package:vacapp_mobile/pages/place_details/screens/place_details_screen.dart";

import "package:vacapp_mobile/pages/map_view/models/locality.dart";
import "package:vacapp_mobile/pages/map_view/models/place_snapshot.dart";

import 'package:logger/logger.dart';

class PlaceInfoDialog extends StatefulWidget {
  const PlaceInfoDialog({
    super.key,
    required this.place,
    this.snapshot,
  });
  final Place place;
  final PlaceSnapshot? snapshot;

  @override
  State<PlaceInfoDialog> createState() => _PlaceInfoDialogState();
}

class _PlaceInfoDialogState extends State<PlaceInfoDialog> {
  final ScrollController _scrollController = ScrollController();

  @override
  Widget build(BuildContext context) {
    return Dialog(
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(16.0),
      ),
      elevation: 0.0,
      backgroundColor: Colors.transparent,
      child: _buildDialogContent(),
    );
  }

  Widget _buildDialogContent() {
    NetworkImage placeImage =
        NetworkImage('http://10.0.2.2:3000/images/places/${widget.place.id}.png');

    bool placeOpensToday = widget.place.opensToday();
    bool placeIsCurrentlyOpen = widget.place.isCurrentlyOpen();

    return Stack(
      alignment: Alignment.topCenter,
      children: <Widget>[
        Padding(
          padding: const EdgeInsets.only(top: 100 / 2.0, bottom: 100 / 2.0),
          child: Container(
            decoration: BoxDecoration(
              color: Colors.white,
              shape: BoxShape.rectangle,
              borderRadius: BorderRadius.circular(16.0),
              boxShadow: const [
                BoxShadow(
                  color: Colors.black26,
                  blurRadius: 10.0,
                  offset: Offset(0.0, 10.0),
                ),
              ],
            ),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                Container(
                  height: 110.0,
                  padding: const EdgeInsets.only(
                    top: 100.0,
                    bottom: 50.0,
                    left: 16.0,
                    right: 16.0,
                  ),
                  decoration: BoxDecoration(
                    image: DecorationImage(
                      image: placeImage,
                      fit: BoxFit.fill,
                      alignment: Alignment.topCenter,
                      colorFilter: ColorFilter.mode(
                        (placeOpensToday && placeIsCurrentlyOpen)
                            ? Colors.transparent
                            : Colors.grey,
                        BlendMode.saturation,
                      ),
                    ),
                    color: Colors.white,
                    shape: BoxShape.rectangle,
                    borderRadius: const BorderRadius.only(
                      topLeft: Radius.circular(16.0),
                      topRight: Radius.circular(16.0),
                    ),
                  ),
                ),
                Container(
                  padding: const EdgeInsets.symmetric(horizontal: 20),
                  child: Column(
                    children: [
                      const SizedBox(height: 10),
                      Text(
                        widget.place.name,
                        style: Theme.of(context)
                            .textTheme
                            .headlineSmall!
                            .copyWith(fontSize: 20.0, fontWeight: FontWeight.w800),
                        textAlign: TextAlign.center,
                      ),
                      const Divider(),
                      _buildServicesList(),
                      const Divider(),
                      Builder(builder: (BuildContext context) {
                        var logger = Logger();
                        logger.d("${widget.place.name} snapshot ${widget.snapshot}");
                        if (!placeOpensToday) {
                          return _buildDoesNotOpenPlaceMessage();
                        }

                        if (!placeIsCurrentlyOpen) {
                          return _buildCurrentlyClosedPlaceMessage();
                        }

                        return _buildMetrics();
                      }),
                      const Divider(),
                      ElevatedButton(
                        style: ElevatedButton.styleFrom(
                          foregroundColor: Colors.orangeAccent,
                          padding: const EdgeInsets.all(10),
                          shape: const RoundedRectangleBorder(
                            borderRadius: BorderRadius.all(Radius.circular(25)),
                          ),
                        ),
                        child: Text(
                          'Más acerca de este lugar',
                          style: Theme.of(context)
                              .textTheme
                              .headlineSmall!
                              .copyWith(fontSize: 14.0, fontWeight: FontWeight.w800),
                          textAlign: TextAlign.center,
                        ),
                        onPressed: () => _onPressedViewMore(context),
                      ),
                      const SizedBox(height: 15),
                    ],
                  ),
                ),
              ],
            ),
          ),
        ),
        Container(
          width: 100,
          height: 100,
          decoration: const ShapeDecoration(shape: CircleBorder()),
          child: Padding(
            padding: const EdgeInsets.all(8),
            child: DecoratedBox(
              decoration: ShapeDecoration(
                shape: const CircleBorder(),
                image: DecorationImage(
                  fit: BoxFit.cover,
                  image: AssetImage("assets/icons/place_types/${widget.place.type.id}.png"),
                ),
              ),
            ),
          ),
        ),
        placeOpensToday && placeIsCurrentlyOpen
            ? _buildSafetyMetricBubble()
            : const SizedBox(height: 0.0),
      ],
    );
  }

  Widget _buildServicesList() {
    if (widget.place.services.isEmpty) {
      return const SizedBox(height: 0);
    }

    return ConstrainedBox(
      constraints: BoxConstraints(
          minHeight: MediaQuery.of(context).size.height * .1,
          maxHeight: MediaQuery.of(context).size.height * .15),
      child: Scrollbar(
        controller: _scrollController,
        thumbVisibility: true,
        child: ListView.builder(
          controller: _scrollController,
          shrinkWrap: true,
          itemCount: widget.place.services.length,
          itemBuilder: (BuildContext context, int index) {
            String imageUrl = "assets/icons/place_services/${widget.place.services[index].id}.png";
            return ListTile(
              dense: true,
              contentPadding: const EdgeInsets.all(0.0),
              leading: ConstrainedBox(
                constraints: BoxConstraints(
                  minHeight: MediaQuery.of(context).size.height * .1,
                  // maxHeight: 50,
                ),
                child: Image.asset(imageUrl, fit: BoxFit.cover),
              ),
              title: Text(
                widget.place.services[index].name,
                style: Theme.of(context).textTheme.headlineSmall!.copyWith(fontSize: 14.0),
              ),
            );
          },
        ),
      ),
    );
  }

  Widget _buildMetrics() {
    return Column(
      children: [
        Text(
          "Ahora en las calles",
          style: Theme.of(context)
              .textTheme
              .headlineSmall!
              .copyWith(fontSize: 18.0, fontWeight: FontWeight.w800),
          textAlign: TextAlign.center,
        ),
        const SizedBox(height: 5.0),
        _buildPeopleMetric("Aglomeración", "${widget.snapshot!.crowdPeopleNo}", Colors.red),
        const SizedBox(height: 5.0),
        _buildPeopleMetric("Filas", "${widget.snapshot!.queuePeopleNo}", Colors.blue),
        const SizedBox(height: 5.0),
        _buildPopulationDensityMetric(),
      ],
    );
  }

  Widget _buildPeopleMetric(String leadingText, String value, Color backgroundColor) {
    return Row(
      crossAxisAlignment: CrossAxisAlignment.center,
      children: <Widget>[
        Text(
          leadingText,
          style: Theme.of(context)
              .textTheme
              .titleLarge!
              .copyWith(fontWeight: FontWeight.w700, fontSize: 18.0),
        ),
        const Spacer(),
        Container(
          width: 40,
          height: 40,
          decoration: BoxDecoration(
            color: backgroundColor,
            shape: BoxShape.circle,
          ),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: <Widget>[
              Text(
                value,
                style: Theme.of(context).textTheme.titleLarge!.copyWith(color: Colors.white),
              ),
            ],
          ),
        ),
      ],
    );
  }

  Widget _buildPopulationDensityMetric() {
    String populationDensity = widget.place
        .calculatePopulationDensity(widget.snapshot!.crowdPeopleNo, widget.snapshot!.queuePeopleNo)
        .toStringAsFixed(0);

    return Container(
      decoration: BoxDecoration(
          shape: BoxShape.rectangle,
          borderRadius: BorderRadius.circular(10.0),
          color: Colors.red[100]),
      child: ListTile(
        dense: true,
        leading: const Icon(
          Icons.zoom_out_map,
          size: 30.0,
          color: Colors.black,
        ),
        title: Text(
          "$populationDensity personas aprox. por 10 m\u00B2",
          style: Theme.of(context)
              .textTheme
              .headlineSmall!
              .copyWith(fontWeight: FontWeight.w600, fontSize: 14.0),
        ),
        contentPadding: const EdgeInsets.only(left: 20.0, right: 20.0),
      ),
    );
  }

  Widget _buildSafetyMetricBubble() {
    return Positioned(
      top: 110,
      right: 10,
      child: Container(
        width: 60,
        height: 40,
        decoration: const BoxDecoration(
          color: Colors.green,
          shape: BoxShape.rectangle,
          borderRadius: BorderRadius.all(Radius.circular(8.0)),
        ),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: <Widget>[
            Text(
              "${widget.snapshot!.safetyScore}",
              style: Theme.of(context)
                  .textTheme
                  .titleLarge!
                  .copyWith(color: Colors.white, fontSize: 24.0),
            ),
          ],
        ),
      ),
    );
  }

  void _onPressedViewMore(BuildContext context) {
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => const PlaceDetailsScreen(),
      ),
    );
  }

  Widget _buildCurrentlyClosedPlaceMessage() {
    return const ClosedPlaceMessage(
        message: "Este lugar se encuentra encontrado. ¡Regresa mañana!");
  }

  Widget _buildDoesNotOpenPlaceMessage() {
    return const ClosedPlaceMessage(message: "Este lugar no abre el día de hoy.");
  }
}

class ClosedPlaceMessage extends StatelessWidget {
  const ClosedPlaceMessage({Key? key, required this.message}) : super(key: key);
  final String message;

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        shape: BoxShape.rectangle,
        borderRadius: BorderRadius.circular(10.0),
        color: Colors.grey[700],
      ),
      child: ListTile(
        dense: true,
        leading: const Icon(
          Icons.lock,
          size: 30.0,
          color: Colors.white,
        ),
        title: Text(
          message,
          style: Theme.of(context)
              .textTheme
              .headlineSmall!
              .copyWith(fontWeight: FontWeight.w600, fontSize: 14.0, color: Colors.white),
        ),
        contentPadding: const EdgeInsets.only(left: 20.0, right: 20.0),
      ),
    );
  }
}
