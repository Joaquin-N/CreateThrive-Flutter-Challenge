part of 'category_cubit.dart';

@immutable
abstract class CategoryState {
  final ItemCategory category;
  final List<Item> items;
  final String filter;
  final Item? lastFavoriteRemoved;
  final Item? lastFavoriteAdded;

  List<Item> get favoriteItems =>
      items.where((element) => element.isFavorite()).toList()
        ..sort(((a, b) => a.favAddDate!.isAfter(b.favAddDate!) ? -1 : 1));

  List<Item> get itemsWithFilter =>
      items.where((element) => element.name.contains(filter)).toList();

  const CategoryState(this.category, this.items, this.filter,
      this.lastFavoriteRemoved, this.lastFavoriteAdded);
}

class LoadingCategory extends CategoryState {
  LoadingCategory() : super(ItemCategory.empty(), [], '', null, null);
}

class CategoryHideItems extends CategoryState {
  CategoryHideItems(CategoryState state,
      {ItemCategory? category,
      List<Item>? items,
      String? filter,
      Item? lastFavoriteRemoved,
      Item? lastFavoriteAdded})
      : super(
            category ?? state.category,
            items ?? state.items,
            filter ?? state.filter,
            lastFavoriteRemoved ?? state.lastFavoriteRemoved,
            lastFavoriteAdded ?? state.lastFavoriteAdded);
}

class CategoryShowItems extends CategoryState {
  CategoryShowItems(CategoryState state,
      {ItemCategory? category,
      List<Item>? items,
      String? filter,
      Item? lastFavoriteRemoved,
      Item? lastFavoriteAdded})
      : super(
            category ?? state.category,
            items ?? state.items,
            filter ?? state.filter,
            lastFavoriteRemoved ?? state.lastFavoriteRemoved,
            lastFavoriteAdded ?? state.lastFavoriteAdded);
}
