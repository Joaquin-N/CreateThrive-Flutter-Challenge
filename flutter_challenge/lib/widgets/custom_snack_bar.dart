import 'package:flutter/material.dart';

class CustomSnackBar extends SnackBar {
  CustomSnackBar({Key? key, required text})
      : super(key: key, content: Text(text));
}
