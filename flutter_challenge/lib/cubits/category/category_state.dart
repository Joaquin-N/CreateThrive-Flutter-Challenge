part of 'category_cubit.dart';

@immutable
abstract class CategoryState {
  final ItemCategory category;
  final List<Item> items;
  final String filter;

  List<Item> get favoriteItems =>
      items.where((element) => element.isFavorite()).toList();

  List<Item> get itemsWithFilter =>
      items.where((element) => element.name.contains(filter)).toList();

  const CategoryState(this.category, this.items, this.filter);
}

class LoadingCategory extends CategoryState {
  LoadingCategory(ItemCategory category) : super(category, [], '');
}

class CategoryHideItems extends CategoryState {
  const CategoryHideItems(ItemCategory category, List<Item> items,
      {filter = ''})
      : super(category, items, filter);
}

class CategoryShowItems extends CategoryState {
  const CategoryShowItems(ItemCategory category, List<Item> items,
      {filter = ''})
      : super(category, items, filter);
}
