import 'package:flutter_challenge/models/item.dart';
import 'package:flutter_challenge/models/item_category.dart';
import 'package:flutter_challenge/services/firestore.dart';

class DataRepository {
  final fs = Firestore();

  Stream<List<ItemCategory>> getCategories() => fs.getCategories();

  Stream<ItemCategory> getCategoryUpdates(ItemCategory category) =>
      fs.getCategoryUpdates(category);

  Stream<List<Item>> getCategoryItems(ItemCategory category) =>
      fs.getCategoryItems(category);

  Stream<List<String>> getCategoriesNames() => fs.getCategoriesNames();

  Future saveCategory(ItemCategory category) async =>
      await fs.saveCategory(category);

  Future saveItem(Item item) async => await fs.saveItem(item);

  Future deleteItem(Item item) async => await fs.deleteItem(item);
}
