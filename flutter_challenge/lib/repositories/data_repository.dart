import 'package:flutter_challenge/models/item.dart';
import 'package:flutter_challenge/models/item_category.dart';
import 'package:flutter_challenge/services/cloud_storage.dart';
import 'package:flutter_challenge/services/firestore.dart';

class DataRepository {
  final _fs = Firestore();
  final _cs = CloudStorage();

  Stream<List<ItemCategory>> getCategories() => _fs.getCategories();

  Stream<ItemCategory> getCategoryUpdates(ItemCategory category) =>
      _fs.getCategoryUpdates(category);

  Stream<List<Item>> getCategoryItems(ItemCategory category) =>
      _fs.getCategoryItems(category);

  Stream<List<String>> getCategoriesNames() => _fs.getCategoriesNames();

  Future saveCategory(ItemCategory category) async =>
      await _fs.saveCategory(category);

  Future saveItem(Item item) async => _fs.saveItem(item);

  Future createItem(Item item) async {
    item = await _fs.saveItem(item);
    item = item.copyWith(
        imgUrl: await _cs.uploadImage(item.localImgPath!, item.id));
    await _fs.saveItem(item);
  }

  Future deleteItem(Item item) async {
    await _fs.deleteItem(item);
    if (item.imgUrl != '') await _cs.deleteImage(item.imgUrl);
  }
}
