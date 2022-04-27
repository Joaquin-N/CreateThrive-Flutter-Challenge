import 'package:flutter/material.dart';
import 'package:flutter_challenge/pages/widgets/items_list.dart';

class FavoritesPage extends StatelessWidget {
  const FavoritesPage({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return ItemsList(
      favorites: true,
    );
  }
}
