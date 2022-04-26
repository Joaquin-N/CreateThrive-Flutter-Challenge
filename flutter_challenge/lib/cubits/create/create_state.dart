part of 'create_cubit.dart';

@immutable
abstract class CreateState {
  final Item item;
  final ItemCategory category;
  final List<String> categoriesNames;
  const CreateState(this.item, this.category, this.categoriesNames);
}

class CreateItem extends CreateState {
  const CreateItem(
      {required Item item,
      required ItemCategory category,
      required List<String> categoriesNames})
      : super(item, category, categoriesNames);
}

class CreateCategory extends CreateState {
  const CreateCategory(
      {required Item item,
      required ItemCategory category,
      required List<String> categoriesNames})
      : super(item, category, categoriesNames);
}
