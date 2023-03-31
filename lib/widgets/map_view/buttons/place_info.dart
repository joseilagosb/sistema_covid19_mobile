import 'package:flutter/material.dart';
import 'package:flutter/cupertino.dart';
import 'package:vacapp_mobile/utils/constants.dart';
import 'package:vacapp_mobile/classes/place.dart';
import 'package:vacapp_mobile/pages/place_details/place_details_page.dart';

// TODO:
// Separar indicadores de crowds y queues
// Todos las imagenes de lugares
// Recuperar las imagenes desde el server

class PlaceInfo extends StatelessWidget {
  final Place place;
  final Map<String, dynamic> crowdReport;
  final int currentCrowdNo;
  final int currentQueueNo;
  final double currentSafetyRating;
  final NetworkImage placeImage;

  PlaceInfo(
      {super.key,
      required this.place,
      required this.crowdReport,
      required this.currentCrowdNo,
      required this.currentQueueNo,
      required this.currentSafetyRating,
      required this.placeImage});

  final ScrollController _scrollController = ScrollController();

  @override
  Widget build(BuildContext context) {
    return Dialog(
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(DIALOG_PADDING),
      ),
      elevation: 0.0,
      backgroundColor: Colors.transparent,
      child: dialogContent(context),
    );
  }

  Widget dialogContent(BuildContext context) {
    return Stack(
      alignment: Alignment.topCenter,
      children: <Widget>[
        Padding(
          padding: const EdgeInsets.only(top: 100 / 2.0, bottom: 100 / 2.0),
          child: Container(
            decoration: BoxDecoration(
              color: Colors.white,
              shape: BoxShape.rectangle,
              borderRadius: BorderRadius.circular(DIALOG_PADDING),
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
                    ),
                    color: Colors.white,
                    shape: BoxShape.rectangle,
                    borderRadius: const BorderRadius.only(
                      topLeft: Radius.circular(DIALOG_PADDING),
                      topRight: Radius.circular(DIALOG_PADDING),
                    ),
                  ),
                ),
                Container(
                  padding: const EdgeInsets.symmetric(horizontal: 20),
                  child: Column(
                    children: [
                      const SizedBox(height: 10),
                      Text(
                        place.getShortName(),
                        style: Theme.of(context)
                            .textTheme
                            .headlineSmall!
                            .copyWith(fontSize: 20.0, fontWeight: FontWeight.w800),
                        textAlign: TextAlign.center,
                      ),
                      const Divider(),
                      place.getServices().length != 0
                          ? ConstrainedBox(
                              constraints: BoxConstraints(
                                  minHeight: MediaQuery.of(context).size.height * .1,
                                  maxHeight: MediaQuery.of(context).size.height * .15),
                              child: Container(
                                child: Scrollbar(
                                  controller: _scrollController,
                                  thumbVisibility: true,
                                  child: ListView.builder(
                                    controller: _scrollController,
                                    shrinkWrap: true,
                                    itemCount: place.getServices().length,
                                    itemBuilder: (BuildContext context, int index) {
                                      return ListTile(
                                        dense: true,
                                        contentPadding: const EdgeInsets.all(0.0),
                                        leading: ConstrainedBox(
                                          constraints: BoxConstraints(
                                            minHeight: MediaQuery.of(context).size.height * .1,
                                            // maxHeight: 50,
                                          ),
                                          child: Image.asset(
                                              "assets/icons/placeservices/${place.getService(index).getId()}.png",
                                              fit: BoxFit.cover),
                                        ),
                                        title: Text(
                                          place.getService(index).getName(),
                                          style: Theme.of(context)
                                              .textTheme
                                              .headlineSmall!
                                              .copyWith(fontSize: 14.0),
                                        ),
                                      );
                                    },
                                  ),
                                ),
                              ),
                            )
                          : const SizedBox(height: 0.0),
                      const Divider(),
                      Text(
                        "Ahora en las calles",
                        style: Theme.of(context)
                            .textTheme
                            .headlineSmall!
                            .copyWith(fontSize: 18.0, fontWeight: FontWeight.w800),
                        textAlign: TextAlign.center,
                      ),
                      const SizedBox(height: 5.0),
                      Row(
                        crossAxisAlignment: CrossAxisAlignment.center,
                        children: <Widget>[
                          Container(
                            child: Text(
                              "Aglomeración",
                              style: Theme.of(context)
                                  .textTheme
                                  .titleLarge!
                                  .copyWith(fontWeight: FontWeight.w700, fontSize: 18.0),
                            ),
                          ),
                          const Spacer(),
                          Container(
                            width: 40,
                            height: 40,
                            decoration: const BoxDecoration(
                              color: Colors.red,
                              shape: BoxShape.circle,
                            ),
                            child: Column(
                              mainAxisAlignment: MainAxisAlignment.center,
                              crossAxisAlignment: CrossAxisAlignment.center,
                              children: <Widget>[
                                Text(
                                  "$currentCrowdNo",
                                  style: Theme.of(context)
                                      .textTheme
                                      .titleLarge!
                                      .copyWith(color: Colors.white),
                                ),
                              ],
                            ),
                          ),
                        ],
                      ),
                      const SizedBox(height: 5.0),
                      Row(
                        crossAxisAlignment: CrossAxisAlignment.center,
                        children: <Widget>[
                          Container(
                              child: Text("Filas",
                                  style: Theme.of(context)
                                      .textTheme
                                      .titleLarge!
                                      .copyWith(fontWeight: FontWeight.w700, fontSize: 18.0))),
                          const Spacer(),
                          Container(
                            width: 40,
                            height: 40,
                            decoration: const BoxDecoration(
                              color: Colors.blue,
                              shape: BoxShape.circle,
                            ),
                            child: Column(
                              mainAxisAlignment: MainAxisAlignment.center,
                              crossAxisAlignment: CrossAxisAlignment.center,
                              children: <Widget>[
                                Text(
                                  "$currentQueueNo",
                                  style: Theme.of(context)
                                      .textTheme
                                      .titleLarge!
                                      .copyWith(color: Colors.white),
                                ),
                              ],
                            ),
                          ),
                        ],
                      ),
                      const SizedBox(height: 5.0),
                      !(place.isClosed() || place.doesNotOpenToday())
                          ? Container(
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
                                  "${Place.getPopulationDensity(currentCrowdNo, currentQueueNo, place.getAttentionSurface()).toStringAsFixed(2)} personas aprox. por 10 m\u00B2",
                                  style: Theme.of(context)
                                      .textTheme
                                      .headlineSmall!
                                      .copyWith(fontWeight: FontWeight.w600, fontSize: 14.0),
                                ),
                                contentPadding: const EdgeInsets.only(left: 20.0, right: 20.0),
                              ),
                            )
                          : Container(),
                      const Divider(),
                      ElevatedButton(
                          style: ElevatedButton.styleFrom(
                            foregroundColor: MaterialColor(
                              0xFF9687,
                              Constants.COLOR_CODES,
                            )[300],
                            padding: const EdgeInsets.all(10),
                            shape: const RoundedRectangleBorder(
                              borderRadius: BorderRadius.all(
                                Radius.circular(25),
                              ),
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
                          onPressed: () {
                            Navigator.push(
                              context,
                              MaterialPageRoute(
                                  builder: (context) => PlaceDetailsPage(
                                      place: place,
                                      placeImage: placeImage,
                                      crowdReport: crowdReport)),
                            );
                          }),
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
                  image: AssetImage("assets/icons/placetypes/${place.getType().getId()}.png"),
                ),
              ),
            ),
          ),
        ),
        Positioned(
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
                  '$currentSafetyRating',
                  style: Theme.of(context)
                      .textTheme
                      .titleLarge!
                      .copyWith(color: Colors.white, fontSize: 24.0),
                ),
              ],
            ),
          ),
        )
      ],
    );
  }
}
