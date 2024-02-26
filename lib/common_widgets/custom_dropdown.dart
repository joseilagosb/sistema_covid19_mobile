import 'package:flutter/material.dart';

class CustomDropdown extends StatelessWidget {
  const CustomDropdown({
    super.key,
    required this.items,
    required this.value,
    required this.onChanged,
  });
  final Map<int, String> items;
  final int value;
  final Function(int? value) onChanged;

  @override
  Widget build(BuildContext context) {
    return DropdownButton(
      value: value,
      items: items
          .map((index, string) {
            return MapEntry(
              index,
              DropdownMenuItem(
                value: index,
                child: Text(string),
              ),
            );
          })
          .values
          .toList(),
      onChanged: onChanged,
    );
  }
}
