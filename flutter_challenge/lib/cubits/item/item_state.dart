part of 'item_cubit.dart';

@immutable
abstract class ItemState {
  final Item item;
  const ItemState(this.item);
}

class ItemLoading extends ItemState {
  ItemLoading() : super(Item(name: ''));
}

class ItemNotShowing extends ItemState {
  const ItemNotShowing(Item item) : super(item);
}

class ItemNotFavorite extends ItemState {
  const ItemNotFavorite(Item item) : super(item);
}

class ItemFavorite extends ItemState {
  const ItemFavorite(Item item) : super(item);
}
