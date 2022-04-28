import 'dart:async';

import 'package:bloc/bloc.dart';
import 'package:flutter_challenge/cubits/filter/filter_cubit.dart';
import 'package:flutter_challenge/models/item.dart';
import 'package:flutter_challenge/repositories/data_repository.dart';
import 'package:flutter_challenge/services/firestore.dart';
import 'package:meta/meta.dart';

part 'item_state.dart';

class ItemCubit extends Cubit<ItemState> {
  final DataRepository repository;

  ItemCubit({required item, required this.repository}) : super(ItemLoading()) {
    _emitState(item);
    // filterStateStream.listen((filterState) {
    //   if (filterState.favorites) {
    //     if (state is! ItemFavorite) {
    //       emit(ItemNotShowing(state.item));
    //     }
    //   } else if (!filterState.enabled || filterState.categories) {
    //     _emitState(state.item);
    //   } else {
    //     if (state.item.name.startsWith(filterState.value)) {
    //       _emitState(state.item);
    //     } else {
    //       emit(ItemNotShowing(state.item));
    //     }
    //   }
    // });
  }

  // void _loadItem() {
  //   fs.getItem(item).listen((item) {
  //     _emitState(item);
  //   });
  // }

  void _emitState(Item item) {
    emit(item.favAddDate == null ? ItemNotFavorite(item) : ItemFavorite(item));
  }

  void toggleFav() {
    Item item = state.item;
    if (item.favAddDate == null) {
      item.favAddDate = DateTime.now();
    } else {
      item.favAddDate = null;
    }
    repository.saveItem(item);
    _emitState(item);
  }

  void delete() {
    emit(ItemDeleted(state.item));
    repository.deleteItem(state.item);
  }
}
