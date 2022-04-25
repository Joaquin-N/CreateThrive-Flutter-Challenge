import 'package:bloc/bloc.dart';
import 'package:flutter_challenge/models/item.dart';
import 'package:flutter_challenge/services/firestore.dart';
import 'package:meta/meta.dart';

part 'item_state.dart';

class ItemCubit extends Cubit<ItemState> {
  final String itemId;
  final fs = Firestore.instance;

  ItemCubit(this.itemId) : super(ItemLoading()) {
    _loadItem();
  }

  void _loadItem() {
    fs.getItem(itemId).listen((item) => emit(ItemReady(item)));
  }
}
