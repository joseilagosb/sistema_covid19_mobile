import 'package:flutter/material.dart';
import 'package:flutter/cupertino.dart';
import 'dart:ui' as ui;

class AreaMarkerPainter extends CustomPainter {
  final String areaName;
  final ui.Image areaIcon;

  AreaMarkerPainter(this.areaName, this.areaIcon);

  @override
  void paint(Canvas canvas, Size size) {
    Paint paint = Paint();
    paint.color = Colors.green.withOpacity(0.5);
    final rRect = RRect.fromRectAndRadius(
        Rect.fromLTWH(0, 0, size.width, size.height), Radius.circular(20));
    canvas.drawRRect(rRect, paint);

    canvas.drawImage(
        areaIcon, Offset(32, size.height / 2 - areaIcon.height / 2), paint);

    final areaNameTextPainter = TextPainter(
        text: TextSpan(
            text: areaName.toUpperCase(),
            style: TextStyle(
                fontSize: 30,
                color: Colors.black.withOpacity(0.5),
                letterSpacing: 5)),
        maxLines: 2,
        textAlign: TextAlign.center,
        textDirection: TextDirection.ltr);

    areaNameTextPainter.layout(minWidth: 0, maxWidth: size.width - 100);
    areaNameTextPainter.paint(canvas,
        Offset(100, size.height / 2 - areaNameTextPainter.size.height / 2));
  }

  @override
  bool shouldRepaint(CustomPainter oldDelegate) => false;
}
