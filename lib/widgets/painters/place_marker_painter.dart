import 'package:flutter/material.dart';
import 'package:flutter/cupertino.dart';
import 'package:vacapp_mobile/utils/constants.dart';

class PlaceMarkerPainter extends CustomPainter {
  final String placeName;
  final dynamic value;
  final int placeInfoMode;
  final bool isClosed;
  final bool isOpen247;

  PlaceMarkerPainter(this.placeName, this.value, this.placeInfoMode,
      this.isClosed, this.isOpen247);

  Color getCirclePainterColor() {
    if (isClosed) {
      return Colors.grey;
    } else {
      switch (placeInfoMode) {
        case Constants.MAPSELECTEDMAPINFO_CROWDS:
          return Colors.red;
        case Constants.MAPSELECTEDMAPINFO_QUEUES:
          return Colors.blue;
        case Constants.MAPSELECTEDMAPINFO_SAFETY:
          return Colors.green;
        default:
          return Colors.orangeAccent;
      }
    }
  }

  Color getBubblePainterColor() {
    if (isOpen247) {
      return Colors.blue.withOpacity(0.5);
    } else {
      if (isClosed) {
        return Colors.grey.withOpacity(0.5);
      } else {
        return Colors.orangeAccent.withOpacity(0.5);
      }
    }
  }

  @override
  void paint(Canvas canvas, Size size) {
    Paint paint = Paint();

    paint.color = getBubblePainterColor();

    final rRect = RRect.fromRectAndRadius(
      Rect.fromLTWH(0, 0, size.width, size.height),
      const Radius.circular(20),
    );
    canvas.drawRRect(rRect, paint);

    paint.color = getCirclePainterColor();

    canvas.drawCircle(Offset(40, size.height / 2), 30, paint);

    final currentCrowdNoTextPainter = TextPainter(
        text: TextSpan(
          text: isClosed ? "🔒" : "$value",
          style: const TextStyle(
            fontSize: 24,
            color: Colors.white,
          ),
        ),
        maxLines: 2,
        textDirection: TextDirection.ltr);

    currentCrowdNoTextPainter.layout(minWidth: 0, maxWidth: size.width - 100);

    currentCrowdNoTextPainter.paint(
        canvas,
        Offset(
            30, size.height / 2 - currentCrowdNoTextPainter.size.height / 2));

    final placeNameTextPainter = TextPainter(
        text: TextSpan(
          text: placeName,
          style: const TextStyle(
            fontSize: 24,
            color: Colors.black,
          ),
        ),
        maxLines: 2,
        textDirection: TextDirection.ltr);

    placeNameTextPainter.layout(minWidth: 0, maxWidth: size.width - 80);
    placeNameTextPainter.paint(canvas,
        Offset(80, size.height / 2 - placeNameTextPainter.size.height / 2));
  }

  @override
  bool shouldRepaint(CustomPainter oldDelegate) {
    return false;
  }
}
