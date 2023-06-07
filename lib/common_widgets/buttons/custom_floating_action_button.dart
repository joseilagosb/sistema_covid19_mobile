import 'package:flutter/material.dart';

class CustomFloatingActionButton extends StatelessWidget {
  const CustomFloatingActionButton({
    super.key,
    required this.label,
    required this.imageUrl,
    required this.onPressed,
    this.backgroundColor = Colors.orange,
    this.foregroundColor = Colors.black,
  });
  final String label;
  final String imageUrl;
  final Color backgroundColor;
  final Color foregroundColor;
  final Function() onPressed;

  @override
  Widget build(BuildContext context) {
    return FloatingActionButton.extended(
      onPressed: onPressed,
      label: Text(
        label,
        style: Theme.of(context)
            .textTheme
            .titleLarge!
            .copyWith(fontSize: 16.0, fontWeight: FontWeight.w800, color: foregroundColor),
      ),
      icon: Image.asset(imageUrl, width: 24, height: 24, color: foregroundColor),
      backgroundColor: backgroundColor,
    );
  }
}
