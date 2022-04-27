import 'package:flutter/material.dart';

class CustomTextField extends StatelessWidget {
  const CustomTextField({
    Key? key,
    this.initialText = '',
    required this.onChanged,
  }) : super(key: key);
  final Function(String) onChanged;
  final String initialText;

  @override
  Widget build(BuildContext context) {
    return Container(
      width: 200,
      padding: const EdgeInsets.symmetric(vertical: 10),
      child: TextFormField(
        initialValue: initialText,
        onChanged: onChanged,
        textAlign: TextAlign.center,
        decoration: InputDecoration(
          isDense: true,
        ),
      ),
    );
  }
}
