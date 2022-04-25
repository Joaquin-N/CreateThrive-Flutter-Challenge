import 'package:bloc/bloc.dart';
import 'package:flutter/material.dart';
import 'package:flutter_challenge/cubits/filter/filter_cubit.dart';
import 'package:flutter_challenge/cubits/item/item_cubit.dart';
import 'package:flutter_challenge/models/item.dart';
import 'package:flutter_challenge/models/item_category.dart';
import 'package:flutter_challenge/services/firestore.dart';
import 'package:meta/meta.dart';

part 'category_state.dart';

class CategoryCubit extends Cubit<CategoryState> {
  final String categoryId;
  final FilterCubit filterCubit;
  final fs = Firestore.instance;

  CategoryCubit({required this.categoryId, required this.filterCubit})
      : super(LoadingCategory()) {
    _loadCategory();

    filterCubit.stream.listen((filterState) async {
      if (filterState is FilterDisabled) {
        _show();
      } else if (filterState is FilterCategories) {
        if (state.category.name.startsWith(filterState.filter)) {
          _show();
        } else {
          _hide();
        }
      } else {
        await Future.delayed(Duration(milliseconds: 1));
        for (ItemCubit cubit in state.itemCubits) {
          if (cubit.state is! ItemNotShowing) {
            _show();
            return;
          }
        }
        _hide();
      }
    });
  }

  void toggleShow() {
    if (state is CategoryShowItems) {
      _hideItems();
    } else {
      _showItems();
    }
  }

  void _show() {
    if (state is CategoryHide) {
      (state as CategoryHide).showItems ? _showItems() : _hideItems();
    }
  }

  void _hide() {
    if (state is! CategoryHide) {
      emit(CategoryHide(
          state.category, state.itemCubits, state is CategoryShowItems));
    }
  }

  void _showItems() {
    emit(CategoryShowItems(state.category, state.itemCubits));
  }

  void _hideItems() {
    emit(CategoryHideItems(state.category, state.itemCubits));
  }

  void reorder(oldIndex, newIndex) {
    ItemCategory category = state.category;
    category.reorder(oldIndex, newIndex);
    fs.updateCategory(category);
    // state update is handled locally to avoid delay
    _reorderCubits(oldIndex, newIndex);
    emit(CategoryShowItems(category, state.itemCubits));
  }

  void _reorderCubits(oldIndex, newIndex) {
    List<ItemCubit> cubits = state.itemCubits;
    if (oldIndex < newIndex) {
      newIndex -= 1;
    }
    ItemCubit item = cubits.removeAt(oldIndex);
    cubits.insert(newIndex, item);
  }

  void _loadCategory() {
    fs.getCategory(categoryId).listen((category) {
      // This statement prevents rebuilding the ui when items rearanged
      if (category.itemsId.length == state.category.itemsId.length) return;

      List<ItemCubit> cubits = List.generate(
          category.itemsId.length,
          (index) => ItemCubit(
              itemId: category.itemsId[index], filterCubit: filterCubit));
      if (state is CategoryHideItems) {
        emit(CategoryHideItems(category, cubits));
      } else {
        emit(CategoryShowItems(category, cubits));
      }
    });
  }
}
