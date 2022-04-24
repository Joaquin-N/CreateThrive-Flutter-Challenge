import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:flutter_challenge/models/item.dart';
import 'package:flutter_challenge/models/item_category.dart';

class Firestore {
  static Firestore? _instance;

  static Firestore get instance {
    _instance ??= Firestore();
    return _instance!;
  }

  final _items = FirebaseFirestore.instance.collection('items');
  final _categories = FirebaseFirestore.instance.collection('categories');

  Stream<List<Item>> getCategoryItems(ItemCategory category) {
    return _items.where('id', whereIn: category.itemsId).snapshots().map(
        (snapshot) =>
            snapshot.docs.map((doc) => Item.fromSnapshot(doc)).toList());
  }

  Stream<List<ItemCategory>> getCategories() {
    return _categories.snapshots().map((snapshot) =>
        snapshot.docs.map((doc) => ItemCategory.fromSnapshot(doc)).toList());
  }

  // Stream<QuerySnapshot<ItemCategory>> getCategories2() {
  //   return _categories
  //       .withConverter<ItemCategory>(
  //           fromFirestore: fromFirestore, toFirestore: toFirestore)
  //       .snapshots();
  // }

  Future<bool> addCategory(ItemCategory cat) async {
    if (await _checkCategoryExistence(cat.name)) return false;
    await _categories.add(cat.toDocument());
    return true;
  }

  Future<bool> updateCategory(ItemCategory cat) async {
    var doc = await _categories
        .where('name', isEqualTo: cat.name)
        .get()
        .then((value) => value.docs.first.reference);
    await doc.update(cat.toDocument());
    return true;
  }

  Future<bool> addItem(Item item) async {
    if (await _checkItemExistence(item.name)) return false;
    item.id = await _getNextId();
    await _items.add(item.toDocument());
    return true;
  }

  Future<void> fillData() async {
    Item item1 = Item(name: 'item1');
    Item item2 = Item(name: 'item2');
    Item item3 = Item(name: 'item3');

    await addItem(item1);
    await addItem(item2);
    await addItem(item3);

    ItemCategory cat1 = ItemCategory(name: 'cat1', color: Colors.red);
    cat1.addItem(item1);

    ItemCategory cat2 = ItemCategory(name: 'cat2', color: Colors.blue);
    cat2.addItem(item2);
    cat2.addItem(item3);

    addCategory(cat1);
    addCategory(cat2);
  }

  Future<bool> _checkItemExistence(String name) async {
    return await _items
        .where('name', isEqualTo: name)
        .get()
        .then((value) => value.size != 0);
  }

  Future<bool> _checkCategoryExistence(String name) async {
    return await _categories
        .where('name', isEqualTo: name)
        .get()
        .then((value) => value.size != 0);
  }

  Future<int> _getNextId() async {
    DocumentReference doc =
        FirebaseFirestore.instance.collection('data').doc('ids');
    int last = await doc.get().then((value) => value.get('last_item_id'));
    int id = last + 1;
    await doc.update({'last_item_id': id});
    return id;
  }
}
