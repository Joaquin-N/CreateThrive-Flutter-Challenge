import 'package:bloc/bloc.dart';
import 'package:flutter_challenge/models/item.dart';
import 'package:flutter_challenge/models/item_category.dart';
import 'package:flutter_challenge/services/firestore.dart';
import 'package:meta/meta.dart';

part 'app_state.dart';

class AppCubit extends Cubit<AppState> {
  final fs = Firestore.instance;
  List<ItemCategory> categories = [];

  AppCubit() : super(AppLoading()) {
    _loadCategories();
  }

  void reorder(ItemCategory category, int oldIndex, int newIndex) {
    category.reorder(oldIndex, newIndex);
    fs.updateCategory(category);
  }

  void _loadCategories() {
    fs.getCategories().listen((event) {
      categories = event;
      _loadItems();
    });
  }

  void _loadItems() {
    for (ItemCategory cat in categories) {
      fs.getCategoryItems(cat).listen((event) {
        cat.items = event;
        print('Items of category ${cat.name} reloaded');
        emit(AppReady(categories));
      });
    }
  }
}
