import 'package:flutter/material.dart';

class CustomBigIconButton extends StatelessWidget {
  const CustomBigIconButton({
    Key? key,
    required this.icon,
    required this.label,
    required this.onClickButton,
  }) : super(key: key);

  final IconData icon;
  final String label;
  final Function() onClickButton;

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onClickButton,
      child: Container(
        padding: const EdgeInsets.all(10),
        height: 100.0,
        margin: const EdgeInsets.symmetric(horizontal: 5),
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(15),
          color: Colors.orangeAccent,
        ),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            Icon(
              icon,
              size: 40,
            ),
            Text(
              label,
              style: const TextStyle(fontSize: 18.0),
              textAlign: TextAlign.center,
            ),
          ],
        ),
      ),
    );
  }
}
