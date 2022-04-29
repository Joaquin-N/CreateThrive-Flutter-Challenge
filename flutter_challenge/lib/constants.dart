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

const String drawerImgUrl =
    'https://firebasestorage.googleapis.com/v0/b/flutter-challenge-c6dce.appspot.com/o/assets%2Fshopping_cart2.png?alt=media&token=e6bcd377-3673-4be1-a2a6-6030b2f860a1';
