part of 'item_cubit.dart';

@immutable
abstract class ItemState {
  final Item item;
  const ItemState(this.item);
}

class ItemReady extends ItemState {
  const ItemReady(Item item) : super(item);
}
