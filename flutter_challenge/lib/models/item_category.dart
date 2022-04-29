import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:equatable/equatable.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter_challenge/models/item.dart';

class ItemCategory extends Equatable {
  final String id;
  final String name;
  final int color;
  final List<String> itemsId;

  //List<Item> _items = [];

  const ItemCategory(
      {this.id = '',
      required this.name,
      required this.color,
      this.itemsId = const []});

  const ItemCategory.empty()
      : id = '',
        name = '',
        color = -1,
        itemsId = const [];

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

  ItemCategory copyWith(
      {String? id,
      String? name,
      int? color,
      List<String>? itemsId = const []}) {
    return ItemCategory(
        id: id ?? this.id,
        name: name ?? this.name,
        color: color ?? this.color,
        itemsId: itemsId ?? this.itemsId);
  }

  @override
  List<Object?> get props => [id, name, color, itemsId];
}
