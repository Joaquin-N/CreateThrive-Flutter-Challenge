part of 'category_cubit.dart';

@immutable
abstract class CategoryState {
  final ItemCategory category;
  final List<ItemCubit> itemCubits;

  const CategoryState(this.category, this.itemCubits);
}

class LoadingCategory extends CategoryState {
  LoadingCategory() : super(ItemCategory.empty(), []);
}

class CategoryHide extends CategoryState {
  final bool showItems;
  const CategoryHide(
      ItemCategory category, List<ItemCubit> itemCubits, this.showItems)
      : super(category, itemCubits);
}

class CategoryHideItems extends CategoryState {
  const CategoryHideItems(ItemCategory category, List<ItemCubit> itemCubits)
      : super(category, itemCubits);
}

class CategoryShowItems extends CategoryState {
  const CategoryShowItems(ItemCategory category, List<ItemCubit> itemCubits)
      : super(category, itemCubits);
}
