import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter_challenge/models/item.dart';
import 'package:flutter_challenge/services/firestore.dart';

class ItemCategory {
  String name;
  Color color;
  List<int> itemsId = [];
  List<Item> items = [];

  ItemCategory({required this.name, required this.color});

  void addItem(Item item) {
    items.add(item);
  }

  void reorder(int oldIndex, int newIndex) {
    if (oldIndex < newIndex) {
      newIndex -= 1;
    }
    Item item = items.removeAt(oldIndex);
    items.insert(newIndex, item);
  }

  void _updateItemsIds() {
    itemsId.clear();
    for (Item i in items) {
      itemsId.add(i.id!);
    }
  }

  Map<String, dynamic> toDocument() {
    _updateItemsIds();
    return {
      'name': name,
      'color': color.value,
      'items_id': itemsId,
    };
  }

  ItemCategory.fromSnapshot(DocumentSnapshot snap)
      : name = snap['name'],
        color = Color(snap['color']),
        itemsId = snap['items_id'].cast<int>();
}
