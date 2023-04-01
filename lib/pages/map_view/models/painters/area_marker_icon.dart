import 'package:flutter/material.dart';
import 'package:vacapp_mobile/pages/map_view/models/locality.dart';
import 'package:vacapp_mobile/pages/map_view/models/painters/marker_icon.dart';

abstract class AreaIconPainter extends IconPainter {
  AreaIconPainter({
    required Locality locality,
    required double width,
    required double height,
  }) : super(locality: locality, height: height, width: width);
}

class NormalAreaIconPainter extends AreaIconPainter {
  NormalAreaIconPainter({
    required Locality locality,
    required double width,
    required double height,
  }) : super(locality: locality, height: height, width: width);

  @override
  void paint(Canvas canvas, Size size) {
    // TODO: implement paint
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) {
    // TODO: implement shouldRepaint
    throw UnimplementedError();
  }
}
