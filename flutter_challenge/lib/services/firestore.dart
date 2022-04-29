import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:flutter_challenge/exceptions.dart';
import 'package:flutter_challenge/models/item.dart';
import 'package:flutter_challenge/models/item_category.dart';
import 'package:async/async.dart';

class Firestore {
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

  Stream<List<String>> getCategoriesNames() {
    return _categories
        .snapshots()
        .map((snap) => snap.docs.map((doc) => doc['name'] as String).toList());
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

  Stream<ItemCategory> getCategoryUpdates(ItemCategory category) {
    return getCategory(category.id);
  }

  // TODO check error on delete item
  Stream<Item> getItem(String docId) {
    return _items
        .doc(docId)
        .snapshots()
        .map(((snap) => Item.fromSnapshot(snap)));
  }

  Future deleteItem(Item item) async {
    String categoryId = await _categories
        .where('items_doc', arrayContains: item.id)
        .get()
        .then((snap) => snap.docs.first.id);
    await _removeItemFromCategory(item.id, categoryId);
    await _items.doc(item.id).delete();
  }

  Future _addItemToCategory(String itemId, String categoryId) async {
    List itemsId = await _categories
        .doc(categoryId)
        .get()
        .then((docSnap) => docSnap['items_doc'].toList());
    itemsId.add(itemId);
    _categories.doc(categoryId).update({'items_doc': itemsId});
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

  Future<bool> addCategory(ItemCategory category) async {
    if (await checkCategoryDuplicated(category)) {
      throw DuplicatedElementException(
          'Category with name ${category.name} already exists');
    }
    var doc = await _categories.add(category.toDocument());
    category.id = doc.id;
    return true;
  }

  Future updateCategory(ItemCategory category) async {
    await _categories.doc(category.id).update(category.toDocument());
  }

  Future<bool> addItem(Item item) async {
    if (await checkItemDuplicated(item)) {
      throw DuplicatedElementException(
          'Item with name ${item.name} already exists');
    }
    var doc = await _items.add(item.toDocument());
    item.id = doc.id;

    String categoryId = await _categories
        .where('name', isEqualTo: item.category)
        .get()
        .then((value) => value.docs.first.id);
    _addItemToCategory(item.id, categoryId);

    return true;
  }

  Future updateItem(Item item) async {
    await _items.doc(item.id).update(item.toDocument());
  }

  Future saveItem(Item item) async {
    if (item.id == '') {
      await addItem(item);
    } else {
      await _items.doc(item.id).update(item.toDocument());
    }
  }

  Future saveCategory(ItemCategory category) async {
    if (category.id == '') {
      await addCategory(category);
    } else {
      await updateCategory(category);
    }
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

  Future<void> fillData() async {
    ItemCategory cat1 = ItemCategory.empty()
      ..name = 'Alcoholic Drinks'
      ..color = Colors.purple.value;

    ItemCategory cat2 = ItemCategory.empty()
      ..name = 'Food'
      ..color = Colors.orange.value;

    ItemCategory cat3 = ItemCategory.empty()
      ..name = 'Sweets'
      ..color = Colors.green.value;

    await addCategory(cat1);
    await addCategory(cat2);
    await addCategory(cat3);

    List<Item> items = [
      Item.empty()
        ..name = 'Wine'
        ..category = cat1.name,
      Item.empty()
        ..name = 'beer'
        ..category = cat1.name,
      Item.empty()
        ..name = 'Gin'
        ..category = cat1.name,
      Item.empty()
        ..name = 'Apple'
        ..category = cat2.name,
      Item.empty()
        ..name = 'Meat'
        ..category = cat2.name,
      Item.empty()
        ..name = 'Bread'
        ..category = cat2.name,
      Item.empty()
        ..name = 'Chocolate'
        ..category = cat3.name,
      Item.empty()
        ..name = 'Candy'
        ..category = cat3.name,
      Item.empty()
        ..name = 'Lollipop'
        ..category = cat3.name,
    ];

    for (var item in items) {
      await addItem(item);
    }
  }
}
