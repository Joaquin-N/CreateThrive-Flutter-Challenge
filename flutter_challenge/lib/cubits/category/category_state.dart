part of 'category_cubit.dart';

@immutable
abstract class CategoryState {
  final ItemCategory category;

  const CategoryState(this.category);
}

class HideCategory extends CategoryState {
  const HideCategory(ItemCategory category) : super(category);
}

class ShowCategory extends CategoryState {
  const ShowCategory(ItemCategory category) : super(category);
}
