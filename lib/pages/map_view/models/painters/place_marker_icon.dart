import 'dart:ui' as ui;

import 'package:flutter/material.dart';

import 'package:vacapp_mobile/pages/map_view/bloc/map_view_bloc.dart';
import 'package:vacapp_mobile/pages/map_view/models/locality.dart';
import 'package:vacapp_mobile/pages/map_view/models/painters/marker_icon.dart';
import 'package:vacapp_mobile/pages/map_view/models/places_info_item.dart';

abstract class PlaceIconPainter extends IconPainter {
  PlaceIconPainter({
    required Locality locality,
    required double width,
    required double height,
  }) : super(locality: locality, width: width, height: height);

  static PlaceIconPainter factory({
    required PlacePaintersType placePaintersType,
    required Locality locality,
    PlacesInfoItem? placeInfoMode,
  }) {
    if (placePaintersType == PlacePaintersType.normal) {
      return NormalPlaceIconPainter(
        locality: locality,
        width: 350.0,
        height: 175.0,
        placeInfoMode: placeInfoMode ?? PlacesInfoItem.crowds,
      );
    } else if (placePaintersType == PlacePaintersType.small) {
      return SmallPlaceIconPainter(
        locality: locality,
        width: 150.0,
        height: 150.0,
      );
    } else {
      return NullPlaceIconPainter(locality: locality);
    }
  }

  Path _drawBubblePath();
  Color _getBubbleColor();

  @override
  void paint(Canvas canvas, Size size) {
    // canvas.drawPaint(Paint()..color = Colors.orange);

    Paint lineColor = Paint()
      ..color = Colors.black
      ..strokeCap = StrokeCap.round
      ..style = PaintingStyle.stroke
      ..strokeWidth = 3;

    Paint fillColor = Paint()
      ..color = _getBubbleColor()
      ..style = PaintingStyle.fill;

    Path bubblePath = _drawBubblePath();

    canvas.drawPath(bubblePath, fillColor);
    canvas.drawPath(bubblePath, lineColor);

    final placeNameTextPainter = TextPainter(
      text: TextSpan(
        text: locality.name,
        style: const TextStyle(fontSize: 30, color: Colors.black),
      ),
      maxLines: 2,
      textDirection: TextDirection.ltr,
      textAlign: TextAlign.center,
    );

    placeNameTextPainter.layout(minWidth: size.width - 40);
    placeNameTextPainter.paint(
        canvas, Offset(20, size.height / 2 - placeNameTextPainter.size.height / 2));
  }
}

class NormalPlaceIconPainter extends PlaceIconPainter {
  NormalPlaceIconPainter({
    required Locality locality,
    required double width,
    required double height,
    required this.placeInfoMode,
  }) : super(locality: locality, width: width, height: height);
  PlacesInfoItem placeInfoMode;

  @override
  ui.Color _getBubbleColor() {
    switch (placeInfoMode) {
      case PlacesInfoItem.crowds:
        return Colors.blue.withOpacity(0.7);
      case PlacesInfoItem.safety:
        return Colors.red.withOpacity(0.7);
      case PlacesInfoItem.service:
        return Colors.green.withOpacity(0.7);
      default:
        return Colors.grey.withOpacity(0.7);
    }
  }

  @override
  Path _drawBubblePath() {
    Path path = Path();

    path.moveTo(width * 0.5, height);
    path.lineTo(width * 0.5 + 20, height - 20);
    path.lineTo(width - 20, height - 20);
    path.lineTo(width - 20, 50);
    path.lineTo(20, 50);
    path.lineTo(20, height - 20);
    path.lineTo(width * 0.5 - 20, height - 20);

    return path;
  }
}

class SmallPlaceIconPainter extends PlaceIconPainter {
  SmallPlaceIconPainter({
    required Locality locality,
    required double width,
    required double height,
  }) : super(locality: locality, width: width, height: height);

  @override
  Color _getBubbleColor() {
    return Colors.orange.withOpacity(0.7);
  }

  @override
  Path _drawBubblePath() {
    Path path = Path();

    path.moveTo(width * 0.5, height);
    path.lineTo(width * 0.5 + 20, height - 20);
    path.lineTo(width - 20, height - 20);
    path.lineTo(width - 20, 20);
    path.lineTo(20, 20);
    path.lineTo(20, height - 20);
    path.lineTo(width * 0.5 - 20, height - 20);

    path.close();

    return path;
  }
}

class NullPlaceIconPainter extends PlaceIconPainter {
  NullPlaceIconPainter({
    required Locality locality,
  }) : super(locality: locality, width: 0, height: 0);

  @override
  void paint(Canvas canvas, Size size) {}

  @override
  Path _drawBubblePath() {
    // TODO: implement _drawBubblePath
    throw UnimplementedError();
  }

  @override
  Color _getBubbleColor() {
    // TODO: implement _getBubbleColor
    throw UnimplementedError();
  }
}
