import 'dart:async';

import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:flutter/material.dart';
import 'package:flutter_challenge/models/item.dart';
import 'package:flutter_challenge/models/item_category.dart';
import 'package:flutter_challenge/repositories/data_repository.dart';
import 'package:meta/meta.dart';

part 'category_state.dart';

class CategoryCubit extends Cubit<CategoryState> {
  final DataRepository repository;
  StreamSubscription? categorySubscription;
  StreamSubscription? itemsSubscription;

  CategoryCubit({required category, required this.repository})
      : super(const CategoryState(ItemCategory.empty())) {
    _loadCategory(category);
  }

  void toggleShow() {
    emit(state.copyWith(showItems: !state.showItems));
  }

  void applyFilter(String filter) {
    if (filter != state.filter) {
      emit(state.copyWith(filter: filter));
    }
  }

  void toggleFav(Item item) {
    if (item.favAddDate == null) {
      item = item.copyWith(favAddDate: DateTime.now());
      emit(state.copyWith(lastFavoriteAdded: item));
    } else {
      item = item.clearFavAddDate();
      emit(state.copyWith(lastFavoriteRemoved: item));
    }

    repository.saveItem(item);
  }

  void delete(Item item) {
    repository.deleteItem(item);
  }

  void reorder(oldIndex, newIndex) {
    ItemCategory category = state.category;
    category.reorder(oldIndex, newIndex);
    repository.saveCategory(category);
    // state update is handled locally to avoid delay
    _reorderItems(oldIndex, newIndex);
    emit(state.copyWith(category: category));
  }

  void _reorderItems(oldIndex, newIndex) {
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
      emit(state.copyWith(category: update));
      _loadItems();
    });
  }

  void _loadItems() {
    if (itemsSubscription != null) itemsSubscription!.cancel();

    if (state.category.itemsId.isEmpty) {
      emit(state.copyWith(items: []));
      return;
    }
    itemsSubscription =
        repository.getCategoryItems(state.category).listen((items) {
      items = state.category.sortItems(items);
      emit(state.copyWith(items: items));
    });
  }

  @override
  Future<void> close() {
    itemsSubscription?.cancel();
    categorySubscription?.cancel();
    return super.close();
  }
}
