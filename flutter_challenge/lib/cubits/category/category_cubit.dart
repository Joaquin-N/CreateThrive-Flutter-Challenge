import 'dart:async';

import 'package:bloc/bloc.dart';
import 'package:flutter/material.dart';
import 'package:flutter_challenge/cubits/filter/filter_cubit.dart';
import 'package:flutter_challenge/cubits/item/item_cubit.dart';
import 'package:flutter_challenge/models/item.dart';
import 'package:flutter_challenge/models/item_category.dart';
import 'package:flutter_challenge/repositories/data_repository.dart';
import 'package:flutter_challenge/services/firestore.dart';
import 'package:meta/meta.dart';

part 'category_state.dart';

class CategoryCubit extends Cubit<CategoryState> {
  final DataRepository repository;
  StreamSubscription? categorySubscription;
  StreamSubscription? itemsSubscription;

  CategoryCubit({required category, required this.repository})
      : super(LoadingCategory()) {
    _loadCategory(category);
    //_loadItems();

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
      emit(CategoryHideItems(state));
    } else {
      (CategoryShowItems(state));
    }
  }

  void applyFilter(String filter) {
    if (filter != state.filter) {
      emit(state is CategoryShowItems
          ? CategoryShowItems(state, filter: filter)
          : CategoryHideItems(state, filter: filter));
    }
  }

  void _updateState(
      {ItemCategory? category,
      List<Item>? items,
      String? filter,
      Item? lastDeleted}) {
    if (state is CategoryHideItems) {
      emit(CategoryHideItems(state,
          category: category,
          items: items,
          filter: filter,
          lastDeleted: lastDeleted));
    } else {
      emit(CategoryShowItems(state,
          category: category,
          items: items,
          filter: filter,
          lastDeleted: lastDeleted));
    }
  }

  void toggleFav(Item item) {
    if (item.favAddDate == null) {
      item.favAddDate = DateTime.now();
    } else {
      item.favAddDate = null;
    }
    repository.saveItem(item);
  }

  void delete(Item item) {
    _updateState(lastDeleted: item);
    repository.deleteItem(item);
  }

  void reorder(oldIndex, newIndex) {
    ItemCategory category = state.category;
    category.reorder(oldIndex, newIndex);
    repository.saveCategory(category);
    // state update is handled locally to avoid delay
    _reorderCubits(oldIndex, newIndex);
    emit(CategoryShowItems(state, category: category));
  }

  void _reorderCubits(oldIndex, newIndex) {
    if (oldIndex < newIndex) {
      newIndex -= 1;
    }
    Item item = state.items.removeAt(oldIndex);
    state.items.insert(newIndex, item);
  }

  void _loadCategory(ItemCategory category) {
    categorySubscription =
        repository.getCategoryUpdates(category).listen((update) {
      // This statement prevents rebuilding the ui when items rearanged
      if (state.category.hasSameProperties(update)) return;
      _updateState(category: update);
      _loadItems();
    });
  }

  void _loadItems() {
    if (itemsSubscription != null) itemsSubscription!.cancel();

    if (state.category.itemsId.isEmpty) return;
    itemsSubscription =
        repository.getCategoryItems(state.category).listen((items) {
      _updateState(items: items);
    });
  }

  @override
  Future<void> close() {
    itemsSubscription?.cancel();
    categorySubscription?.cancel();
    return super.close();
  }
}
