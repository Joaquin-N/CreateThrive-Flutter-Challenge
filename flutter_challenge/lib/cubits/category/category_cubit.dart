import 'package:bloc/bloc.dart';
import 'package:flutter_challenge/models/item.dart';
import 'package:flutter_challenge/models/item_category.dart';
import 'package:flutter_challenge/services/firestore.dart';
import 'package:meta/meta.dart';

part 'category_state.dart';

class CategoryCubit extends Cubit<CategoryState> {
  final ItemCategory category;
  final fs = Firestore.instance;

  CategoryCubit(this.category) : super(HideCategory(category)) {
    _loadItems();
  }

  void toggleShow() {
    if (state is ShowCategory) {
      emit(HideCategory(category));
    } else {
      emit(ShowCategory(category));
    }
  }

  void reorder(oldIndex, newIndex) {
    category.reorder(oldIndex, newIndex);
    fs.updateCategory(category);
    emit(ShowCategory(category));
  }

  void _loadItems() {
    fs.getCategoryItems(category).listen((items) {
      category.items = items;
      emit(ShowCategory(category));
    });
  }
}
