import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:flutter_challenge/exceptions.dart';
import 'package:flutter_challenge/models/item.dart';
import 'package:flutter_challenge/models/item_category.dart';

class Firestore {
  final _items = FirebaseFirestore.instance.collection('items');
  final _categories = FirebaseFirestore.instance.collection('categories');

  // Categories

  Future<ItemCategory> saveCategory(ItemCategory category) async {
    try {
      if (category.id == '') {
        return await _addCategory(category);
      } else {
        await _updateCategory(category);
        return category;
      }
    } catch (e) {
      rethrow;
    }
  }

  Future<ItemCategory> _addCategory(ItemCategory category) async {
    if (await _checkCategoryDuplicated(category)) {
      throw DuplicatedElementException(
          'Category with name ${category.name} already exists');
    }
    var doc = await _categories.add(category.toDocument());
    category = category.copyWith(id: doc.id);
    return category;
  }

  Future _updateCategory(ItemCategory category) async {
    await _categories.doc(category.id).update(category.toDocument());
  }

  Future<bool> _checkCategoryDuplicated(ItemCategory category) async {
    return await _categories
        .where('name', isEqualTo: category.name)
        .get()
        .then((snap) {
      if (snap.size == 0) return false;
      if (snap.size == 1 && snap.docs.first.id == category.id) return false;
      return true;
    });
  }

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

  Stream<ItemCategory> getCategoryUpdates(ItemCategory category) {
    return _getCategory(category.id);
  }

  Stream<ItemCategory> _getCategory(String docId) {
    return _categories
        .doc(docId)
        .snapshots()
        .map(((snap) => ItemCategory.fromSnapshot(snap)));
  }

  // Items

  Future<Item> saveItem(Item item) async {
    try {
      if (item.id == '') {
        return await _addItem(item);
      } else {
        await _items.doc(item.id).update(item.toDocument());
        return item;
      }
    } catch (e) {
      rethrow;
    }
  }

  Future<Item> _addItem(Item item) async {
    if (await _checkItemDuplicated(item)) {
      throw DuplicatedElementException(
          'Item with name ${item.name} already exists');
    }
    var doc = await _items.add(item.toDocument());
    item = item.copyWith(id: doc.id);

    String categoryId = await _categories
        .where('name', isEqualTo: item.category)
        .get()
        .then((value) => value.docs.first.id);
    _addItemToCategory(item.id, categoryId);

    return item;
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

  Future<bool> _checkItemDuplicated(Item item) async {
    return await _items.where('name', isEqualTo: item.name).get().then((snap) {
      if (snap.size == 0) return false;
      if (snap.size == 1 && snap.docs.first.id == item.id) return false;
      return true;
    });
  }

  // Sample data

  Future<void> fillData() async {
    ItemCategory cat1 =
        ItemCategory(name: 'Alcoholic Drinks', color: Colors.purple.value);

    ItemCategory cat2 = ItemCategory(name: 'Food', color: Colors.orange.value);

    ItemCategory cat3 = ItemCategory(name: 'Sweets', color: Colors.green.value);

    await _addCategory(cat1);
    await _addCategory(cat2);
    await _addCategory(cat3);

    List<Item> items = [
      Item(name: 'vodka', category: cat1.name, favAddDate: null, imgUrl: ''),
      Item(name: 'Beer', category: cat1.name, favAddDate: null, imgUrl: ''),
      Item(name: 'Gin', category: cat1.name, favAddDate: null, imgUrl: ''),
      Item(name: 'Apple', category: cat2.name, favAddDate: null, imgUrl: ''),
      Item(name: 'Meat', category: cat2.name, favAddDate: null, imgUrl: ''),
      Item(name: 'Bread', category: cat2.name, favAddDate: null, imgUrl: ''),
      Item(
          name: 'Chocolate', category: cat3.name, favAddDate: null, imgUrl: ''),
      Item(name: 'Candy', category: cat3.name, favAddDate: null, imgUrl: ''),
      Item(name: 'Lollipop', category: cat3.name, favAddDate: null, imgUrl: ''),
    ];

    for (var item in items) {
      await _addItem(item);
    }
  }
}
