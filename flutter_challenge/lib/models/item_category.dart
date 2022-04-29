import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter_challenge/models/item.dart';

class ItemCategory {
  String id;
  String name;
  int color;
  List<String> itemsId = [];

  //List<Item> _items = [];

  ItemCategory({required this.id, required this.name, required this.color});

  ItemCategory.empty()
      : id = '',
        name = '',
        color = -1;
  bool validate() => name != '' && color != -1;

  void addItemId(String id) {
    itemsId.add(id);
  }

  bool hasSameProperties(ItemCategory other) {
    return id == other.id &&
        name == other.name &&
        color == other.color &&
        itemsId.length == other.itemsId.length;
  }

  bool isEqualToAny(List<ItemCategory> categories) {
    for (var category in categories) {
      if (name == category.name) return true;
    }
    return false;
  }

  List<Item> sortItems(List<Item> items) {
    List<Item> sorted = [];
    for (String itemId in itemsId) {
      for (Item item in items) {
        if (item.id == itemId) {
          sorted.add(item);
        }
      }
    }
    return sorted;
  }

  // set items(List<Item> values) {
  //   _items.clear();
  //   for (String doc in docs) {
  //     _items.add(values.firstWhere((item) => item.id == doc));
  //   }
  // }

  // List<Item> get items => _items;
  // // TODO: Sort favorites
  // List<Item> get favoriteItems =>
  //     _items.where((item) => item.favAddDate != null).toList();

  // void insertItem(Item item) {
  //   int index = -1;
  //   for (int i = 0; i < items.length; i++) {
  //     if (items[i].id == item.id) {
  //       index = i;
  //       break;
  //     }
  //   }
  //   if (index != -1) {
  //     items.removeAt(index);
  //     items.insert(index, item);
  //   } else {
  //     items.add(item);
  //   }
  // }

  // void reorder(int oldIndex, int newIndex) {
  //   if (oldIndex < newIndex) {
  //     newIndex -= 1;
  //   }
  //   Item item = items.removeAt(oldIndex);
  //   items.insert(newIndex, item);
  // }

  void reorder(int oldIndex, int newIndex) {
    if (oldIndex < newIndex) {
      newIndex -= 1;
    }
    String item = itemsId.removeAt(oldIndex);
    itemsId.insert(newIndex, item);
  }

  Map<String, dynamic> toDocument() {
    return {
      'name': name,
      'color': color,
      'items_doc': itemsId,
    };
  }

  ItemCategory.fromSnapshot(DocumentSnapshot snap)
      : id = snap.id,
        name = snap['name'],
        color = snap['color'],
        itemsId = snap['items_doc'].cast<String>();
}
