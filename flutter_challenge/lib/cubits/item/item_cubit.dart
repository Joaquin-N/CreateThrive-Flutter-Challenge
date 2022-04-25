import 'package:bloc/bloc.dart';
import 'package:flutter_challenge/models/item.dart';
import 'package:meta/meta.dart';

part 'item_state.dart';

class ItemCubit extends Cubit<ItemState> {
  final Item item;

  ItemCubit(this.item) : super(ItemReady(item));
}
