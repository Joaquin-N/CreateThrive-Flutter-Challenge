part of 'category_cubit.dart';

@immutable
class CategoryState extends Equatable {
  final ItemCategory category;
  final List<Item> items;
  final String filter;
  final bool showItems;
  final Item? lastFavoriteRemoved;
  final Item? lastFavoriteAdded;
  final bool loading;

  List<Item> get favoriteItems =>
      items.where((element) => element.isFavorite()).toList()
        ..sort(((a, b) => a.favAddDate!.isAfter(b.favAddDate!) ? -1 : 1));

  List<Item> get itemsWithFilter => items
      .where((element) =>
          element.name.toLowerCase().contains(filter.toLowerCase()))
      .toList();

  const CategoryState(this.category)
      : items = const [],
        filter = '',
        showItems = true,
        loading = true,
        lastFavoriteAdded = null,
        lastFavoriteRemoved = null;

  const CategoryState._(this.category, this.items, this.showItems, this.filter,
      this.lastFavoriteRemoved, this.lastFavoriteAdded)
      : loading = false;

  CategoryState copyWith(
          {ItemCategory? category,
          List<Item>? items,
          bool? showItems,
          String? filter,
          Item? lastFavoriteRemoved,
          Item? lastFavoriteAdded}) =>
      CategoryState._(
          category ?? this.category,
          items ?? this.items,
          showItems ?? this.showItems,
          filter ?? this.filter,
          lastFavoriteRemoved ?? this.lastFavoriteRemoved,
          lastFavoriteAdded ?? this.lastFavoriteAdded);

  @override
  List<Object?> get props => [
        category,
        items,
        filter,
        showItems,
        lastFavoriteAdded,
        lastFavoriteRemoved,
        loading
      ];
}
