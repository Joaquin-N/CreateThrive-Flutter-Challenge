part of 'category_cubit.dart';

@immutable
abstract class CategoryState {
  final ItemCategory category;
  final List<Item> items;
  final String filter;
  final Item? lastDeleted;

  List<Item> get favoriteItems =>
      items.where((element) => element.isFavorite()).toList();

  List<Item> get itemsWithFilter =>
      items.where((element) => element.name.contains(filter)).toList();

  const CategoryState(this.category, this.items, this.filter, this.lastDeleted);
}

class LoadingCategory extends CategoryState {
  LoadingCategory() : super(ItemCategory.empty(), [], '', null);
}

class CategoryHideItems extends CategoryState {
  CategoryHideItems(CategoryState state,
      {ItemCategory? category,
      List<Item>? items,
      String? filter,
      Item? lastDeleted})
      : super(category ?? state.category, items ?? state.items,
            filter ?? state.filter, lastDeleted ?? state.lastDeleted);
}

class CategoryShowItems extends CategoryState {
  CategoryShowItems(CategoryState state,
      {ItemCategory? category,
      List<Item>? items,
      String? filter,
      Item? lastDeleted})
      : super(category ?? state.category, items ?? state.items,
            filter ?? state.filter, lastDeleted ?? state.lastDeleted);
}
