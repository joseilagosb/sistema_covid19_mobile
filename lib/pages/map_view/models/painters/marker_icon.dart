import 'dart:ui' as ui;
import 'dart:typed_data';

import 'package:flutter/material.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';

import 'package:vacapp_mobile/pages/map_view/bloc/map_view_bloc.dart';

import 'package:vacapp_mobile/pages/map_view/models/locality.dart';
import 'package:vacapp_mobile/pages/map_view/models/painters/place_marker_icon.dart';
import 'package:vacapp_mobile/pages/map_view/models/places_info_item.dart';

abstract class IconPainter extends CustomPainter {
  IconPainter({
    required this.locality,
    required this.width,
    required this.height,
  });
  Locality locality;
  double width;
  double height;

  static IconPainter factory({
    required Locality locality,
    required PlacePaintersType placePaintersType,
    PlacesInfoItem? placeInfoMode,
  }) {
    if (locality is Place) {
      return PlaceIconPainter.factory(
        placePaintersType: placePaintersType,
        placeInfoMode: placeInfoMode,
        locality: locality,
      );
    } else if (locality is Area) {
      throw UnimplementedError();
    } else {
      throw UnimplementedError();
    }
  }

  Future<BitmapDescriptor> toBitmap() async {
    ui.PictureRecorder recorder = ui.PictureRecorder();
    final ui.Canvas canvas = ui.Canvas(recorder);

    paint(canvas, Size(width, height));

    final ui.Image image = await recorder.endRecording().toImage(width.toInt(), height.toInt());
    final ByteData? byteData = await image.toByteData(format: ui.ImageByteFormat.png);

    return BitmapDescriptor.fromBytes(byteData!.buffer.asUint8List());
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) => false;
}
