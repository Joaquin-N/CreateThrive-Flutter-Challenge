import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter_challenge/models/item.dart';

class ItemCategory {
  String? id;
  String name;
  Color color;
  List<String> docs = [];

  List<Item> _items = [];

  ItemCategory({required this.name, required this.color});

  set items(List<Item> values) {
    _items.clear();
    for (String doc in docs) {
      _items.add(values.firstWhere((item) => item.id == doc));
    }
  }

  List<Item> get items => _items;
  // TODO: Sort favorites
  List<Item> get favoriteItems =>
      _items.where((item) => item.favAddDate != null).toList();

  void insertItem(Item item) {
    int index = -1;
    for (int i = 0; i < items.length; i++) {
      if (items[i].id == item.id) {
        index = i;
        break;
      }
    }
    if (index != -1) {
      items.removeAt(index);
      items.insert(index, item);
    } else {
      items.add(item);
    }
  }

  void reorder(int oldIndex, int newIndex) {
    if (oldIndex < newIndex) {
      newIndex -= 1;
    }
    Item item = items.removeAt(oldIndex);
    items.insert(newIndex, item);
  }

  Map<String, dynamic> toDocument() {
    return {
      'name': name,
      'color': color.value,
      'items_doc': List.generate(items.length, (index) => items[index].id),
    };
  }

  ItemCategory.fromSnapshot(DocumentSnapshot snap)
      : id = snap.id,
        name = snap['name'],
        color = Color(snap['color']),
        docs = snap['items_doc'].cast<String>();
}
