import 'package:flutter/material.dart';
import 'package:vacapp_mobile/constants/values.dart';

class PlaceImageContainer extends StatelessWidget {
  const PlaceImageContainer({super.key, required this.placeId});
  final int placeId;

  @override
  Widget build(BuildContext context) {
    return Stack(
      children: <Widget>[
        ClipPath(
          clipper: PlaceImageClipper(),
          child: Container(
            height: 220,
            width: double.infinity,
            decoration: BoxDecoration(
              gradient: const LinearGradient(
                begin: Alignment.topRight,
                end: Alignment.bottomLeft,
                colors: [
                  Color(0xFF3383CD),
                  Color(0xFF11249F),
                ],
              ),
              image: DecorationImage(
                // image: widget.placeImage,
                image: NetworkImage(
                  "${Values.backendUri}/images/places/$placeId.png",
                ),
                fit: BoxFit.fill,
              ),
            ),
          ),
        ),
        Container(
          alignment: Alignment.bottomRight,
          padding: const EdgeInsets.only(right: 10.0, top: 120),
          child: FloatingActionButton(
            backgroundColor: const Color.fromRGBO(255, 150, 35, 1),
            onPressed: () {},
            child: const Icon(Icons.location_on),
          ),
        ),
      ],
    );
  }
}

class PlaceImageClipper extends CustomClipper<Path> {
  @override
  Path getClip(Size size) {
    var path = Path();
    path.lineTo(0, size.height - 80);
    path.quadraticBezierTo(size.width / 2, size.height, size.width, size.height - 80);
    path.lineTo(size.width, 0);
    path.close();
    return path;
  }

  @override
  bool shouldReclip(CustomClipper<Path> oldClipper) {
    return false;
  }
}
