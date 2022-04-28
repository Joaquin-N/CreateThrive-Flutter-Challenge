import 'dart:async';

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
  final fs = Firestore.instance;
  StreamSubscription? categorySubscription;
  StreamSubscription? itemsSubscription;

  CategoryCubit({required category}) : super(LoadingCategory(category)) {
    _loadCategory();
    _loadItems();

    // filterStateStream.listen((filterState) async {
    //   if (state.category.itemsId.isEmpty) return;

    //   if (filterState.favorites) {
    //     await Future.delayed(Duration(milliseconds: 1));
    //     for (ItemCubit cubit in state.items) {
    //       if (cubit.state is! ItemNotShowing) {
    //         _show();
    //         return;
    //       }
    //     }
    //     _hide();
    //   } else if (!filterState.enabled) {
    //     _show();
    //   } else if (filterState.categories) {
    //     if (state.category.name.startsWith(filterState.value)) {
    //       _show();
    //     } else {
    //       _hide();
    //     }
    //   } else {
    //     await Future.delayed(Duration(milliseconds: 1));
    //     for (ItemCubit cubit in state.items) {
    //       if (cubit.state is! ItemNotShowing) {
    //         _show();
    //         return;
    //       }
    //     }
    //     _hide();
    //   }
    // });
  }

  void toggleShow() {
    if (state is CategoryShowItems) {
      _hideItems();
    } else {
      _showItems();
    }
  }

  void applyFilter(String filter) {
    if (filter != state.filter) {
      emit(state is CategoryShowItems
          ? CategoryShowItems(state.category, state.items, filter: filter)
          : CategoryHideItems(state.category, state.items, filter: filter));
    }
  }

  void _showItems() {
    emit(CategoryShowItems(state.category, state.items));
  }

  void _hideItems() {
    emit(CategoryHideItems(state.category, state.items));
  }

  void reorder(oldIndex, newIndex) {
    ItemCategory category = state.category;
    category.reorder(oldIndex, newIndex);
    fs.updateCategory(category);
    // state update is handled locally to avoid delay
    _reorderCubits(oldIndex, newIndex);
    emit(CategoryShowItems(category, state.items));
  }

  void _reorderCubits(oldIndex, newIndex) {
    if (oldIndex < newIndex) {
      newIndex -= 1;
    }
    Item item = state.items.removeAt(oldIndex);
    state.items.insert(newIndex, item);
  }

  void _loadCategory() {
    categorySubscription =
        fs.getCategoryUpdates(state.category).listen((update) {
      // This statement prevents rebuilding the ui when items rearanged
      if (state.category.hasSameProperties(update)) return;
      emit(LoadingCategory(update));
      _loadItems();
    });
  }

  void _loadItems() {
    if (itemsSubscription != null) itemsSubscription!.cancel();

    itemsSubscription = fs.getCategoryItems(state.category).listen((items) {
      if (state is CategoryHideItems) {
        emit(CategoryHideItems(state.category, items));
      } else {
        emit(CategoryShowItems(state.category, items));
      }
    });
  }

  @override
  Future<void> close() {
    itemsSubscription?.cancel();
    categorySubscription?.cancel();
    return super.close();
  }
}
