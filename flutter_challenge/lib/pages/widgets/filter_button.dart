import 'package:flutter/material.dart';

class FilterButton extends StatelessWidget {
  const FilterButton(
      {Key? key,
      required this.text,
      required this.color,
      this.onPressed,
      this.minWidth = 95.0,
      this.minHeight = 35.0})
      : super(key: key);

  final Function()? onPressed;
  final String text;
  final Color color;
  final double minWidth;
  final double minHeight;

  @override
  Widget build(BuildContext context) {
    return ElevatedButton(
      onPressed: onPressed,
      child: Text(text, style: const TextStyle(fontSize: 12)),
      style: ElevatedButton.styleFrom(
        shape: const StadiumBorder(),
      ).copyWith(
        backgroundColor: MaterialStateProperty.all<Color>(color),
        foregroundColor: MaterialStateProperty.all<Color>(Colors.white),
        minimumSize: MaterialStateProperty.all(Size(minWidth, minHeight)),
      ),
    );
  }
}
