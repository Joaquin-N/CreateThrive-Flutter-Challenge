part of 'create_item_cubit.dart';

@immutable
abstract class CreateItemState {
  final Item item;
  final List<String> categoriesNames;
  const CreateItemState(this.item, this.categoriesNames);
}

class CreateItemInitial extends CreateItemState {
  const CreateItemInitial(
      {required Item item, required List<String> categoriesNames})
      : super(item, categoriesNames);
}

class CreateItemUpdated extends CreateItemState {
  const CreateItemUpdated(
      {required Item item, required List<String> categoriesNames})
      : super(item, categoriesNames);
}

class CreateItemReady extends CreateItemState {
  const CreateItemReady(
      {required Item item, required List<String> categoriesNames})
      : super(item, categoriesNames);
}

class CreateItemSaved extends CreateItemState {
  const CreateItemSaved(
      {required Item item, required List<String> categoriesNames})
      : super(item, categoriesNames);
}

class CreateItemErrorDuplicated extends CreateItemState {
  const CreateItemErrorDuplicated(
      {required Item item, required List<String> categoriesNames})
      : super(item, categoriesNames);
}
