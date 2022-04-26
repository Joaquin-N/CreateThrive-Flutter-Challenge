import 'package:flutter/material.dart';

abstract class AppPage {
  static const shoppingList = 'Shoping List';
  static const favorites = 'Favorites';
  static const create = 'Create Item/Category';
}

Color itemColor = Colors.red;
Color itemColorDisabled = Colors.red.shade200;

Color categoryColor = Colors.blue;
Color categoryColorDisabled = Colors.blue.shade200;

TextStyle defaultTextStyle =
    const TextStyle(fontSize: 16, fontWeight: FontWeight.w500);
