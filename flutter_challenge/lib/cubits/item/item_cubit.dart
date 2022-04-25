import 'package:bloc/bloc.dart';
import 'package:flutter_challenge/cubits/filter/filter_cubit.dart';
import 'package:flutter_challenge/models/item.dart';
import 'package:flutter_challenge/services/firestore.dart';
import 'package:meta/meta.dart';

part 'item_state.dart';

class ItemCubit extends Cubit<ItemState> {
  final String itemId;
  final FilterCubit filterCubit;
  final fs = Firestore.instance;

  ItemCubit({required this.itemId, required this.filterCubit})
      : super(ItemLoading()) {
    _loadItem();
    filterCubit.stream.listen((filterState) {
      if (filterState is FilterDisabled) {
        _emitState(state.item);
      } else {
        if (state.item.name.startsWith(filterState.itemName)) {
          _emitState(state.item);
        } else {
          emit(ItemNotShowing(state.item));
        }
      }
    });
  }

  void _loadItem() {
    fs.getItem(itemId).listen((item) => _emitState(item));
  }

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
    fs.updateItem(item);
    _emitState(item);
  }
}
