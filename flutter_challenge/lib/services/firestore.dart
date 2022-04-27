import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:flutter_challenge/models/item.dart';
import 'package:flutter_challenge/models/item_category.dart';
import 'package:async/async.dart';

class Firestore {
  static Firestore? _instance;

  static Firestore get instance {
    _instance ??= Firestore();
    return _instance!;
  }

  final _items = FirebaseFirestore.instance.collection('items');
  final _categories = FirebaseFirestore.instance.collection('categories');

  // Stream<Item> getCategoryItems(ItemCategory category) {
  //   List<Stream<Item>> streamList = [];
  //   for (String doc in category.docs) {
  //     streamList.add(
  //         _items.doc(doc).snapshots().map((event) => Item.fromSnapshot(event)));
  //   }
  //   return StreamGroup.merge(streamList);
  // }

  Stream<List<Item>> getCategoryItems(ItemCategory category) {
    return _items
        .where(FieldPath.documentId, whereIn: category.itemsId)
        .snapshots()
        .map((snap) =>
            snap.docs.map((docSnap) => Item.fromSnapshot(docSnap)).toList());
  }

  Stream<List<ItemCategory>> getCategories() {
    return _categories.snapshots().map((snapshot) =>
        snapshot.docs.map((doc) => ItemCategory.fromSnapshot(doc)).toList());
  }

  Stream<List<String>> getCategoriesIds() {
    return _categories
        .snapshots()
        .map((snapshot) => snapshot.docs.map((doc) => doc.id).toList());
  }

  Stream<ItemCategory> getCategory(String docId) {
    return _categories
        .doc(docId)
        .snapshots()
        .map(((snap) => ItemCategory.fromSnapshot(snap)));
  }

  // TODO check error on delete item
  Stream<Item> getItem(String docId) {
    return _items
        .doc(docId)
        .snapshots()
        .map(((snap) => Item.fromSnapshot(snap)));
  }

  void updateItem(Item item) {
    _items.doc(item.id).update(item.toDocument());
  }

  void deleteItem(Item item) async {
    String categoryId = await _categories
        .where('items_doc', arrayContains: item.id)
        .get()
        .then((snap) => snap.docs.first.id);
    await _removeItemFromCategory(item.id, categoryId);
    _items.doc(item.id).delete();
  }

  Future _removeItemFromCategory(String itemId, String categoryId) async {
    List itemsId = await _categories
        .doc(categoryId)
        .get()
        .then((docSnap) => docSnap['items_doc'].toList());
    itemsId.remove(itemId);
    _categories.doc(categoryId).update({'items_doc': itemsId});
  }

  // Stream<QuerySnapshot<ItemCategory>> getCategories2() {
  //   return _categories
  //       .withConverter<ItemCategory>(
  //           fromFirestore: fromFirestore, toFirestore: toFirestore)
  //       .snapshots();
  // }

  Future<bool> addCategory(ItemCategory cat) async {
    if (await checkCategoryDuplicated(cat)) return false;
    var doc = await _categories.add(cat.toDocument());
    cat.id = doc.id;
    return true;
  }

  Future<bool> updateCategory(ItemCategory cat) async {
    await _categories.doc(cat.id).update(cat.toDocument());
    return true;
  }

  Future<bool> addItem(Item item) async {
    if (await checkItemDuplicated(item)) return false;
    var doc = await _items.add(item.toDocument());
    item.id = doc.id;
    return true;
  }

  void saveItem(Item item) {
    if (item.id == '') {
      addItem(item);
    } else {
      _items.doc(item.id).update(item.toDocument());
    }
  }

  void saveCategory(ItemCategory category) {
    if (category.id == '') {
      addCategory(category);
    } else {
      updateCategory(category);
    }
  }

  Future<void> fillData() async {
    Item item1 = Item.empty()..name = 'item1';
    Item item2 = Item.empty()..name = 'item2';
    Item item3 = Item.empty()..name = 'item3';

    await addItem(item1);
    await addItem(item2);
    await addItem(item3);

    ItemCategory cat1 = ItemCategory.empty()
      ..name = 'cat1'
      ..color = Colors.red.value;
    cat1.addItemId(item1.id);

    ItemCategory cat2 = ItemCategory.empty()
      ..name = 'cat2'
      ..color = Colors.blue.value;
    cat2.addItemId(item2.id);
    cat2.addItemId(item3.id);

    addCategory(cat1);
    addCategory(cat2);
  }

  Future<bool> checkItemDuplicated(Item item) async {
    return await _items.where('name', isEqualTo: item.name).get().then((snap) {
      if (snap.size == 0) return false;
      if (snap.size == 1 && snap.docs.first.id == item.id) return false;
      return true;
    });
  }

  Future<bool> checkCategoryDuplicated(ItemCategory category) async {
    return await _categories
        .where('name', isEqualTo: category.name)
        .get()
        .then((snap) {
      if (snap.size == 0) return false;
      if (snap.size == 1 && snap.docs.first.id == category.id) return false;
      return true;
    });
  }
}
