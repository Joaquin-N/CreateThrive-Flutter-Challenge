import 'package:bloc/bloc.dart';
import 'package:flutter/material.dart';
import 'package:flutter_challenge/models/item.dart';
import 'package:flutter_challenge/models/item_category.dart';
import 'package:flutter_challenge/services/firestore.dart';
import 'package:meta/meta.dart';

part 'category_state.dart';

class CategoryCubit extends Cubit<CategoryState> {
  final String categoryId;
  final fs = Firestore.instance;

  CategoryCubit(this.categoryId) : super(LoadingCategory()) {
    _loadCategory();
  }

  void toggleShow() {
    if (state is ShowCategory) {
      emit(HideCategory(state.category));
    } else {
      emit(ShowCategory(state.category));
    }
  }

  void reorder(oldIndex, newIndex) {
    ItemCategory category = state.category;
    category.reorder(oldIndex, newIndex);
    fs.updateCategory(category);
  }

  void _loadCategory() {
    fs.getCategory(categoryId).listen((category) {
      if (state is HideCategory) {
        emit(HideCategory(category));
      } else {
        emit(ShowCategory(category));
      }
    });
  }
}
