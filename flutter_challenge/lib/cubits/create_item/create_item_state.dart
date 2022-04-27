part of 'create_item_cubit.dart';

@immutable
abstract class CreateItemState {
  final Item item;
  final List<String> categoriesNames;
  const CreateItemState(this.item, this.categoriesNames);
  CreateItemState._(CreateItemState state)
      : item = state.item,
        categoriesNames = state.categoriesNames;

  CreateItemUpdated toUpdated() => CreateItemUpdated._(this);
  CreateItemReady toReady() => CreateItemReady._(this);
  CreateItemErrorDuplicated toErrorDuplicated() =>
      CreateItemErrorDuplicated._(this);
}

class CreateItemInitial extends CreateItemState {
  const CreateItemInitial(
      {required Item item, required List<String> categoriesNames})
      : super(item, categoriesNames);
}

class CreateItemUpdated extends CreateItemState {
  CreateItemUpdated._(CreateItemState state) : super._(state);
}

class CreateItemReady extends CreateItemState {
  CreateItemReady._(CreateItemState state) : super._(state);
}

class CreateItemErrorDuplicated extends CreateItemState {
  CreateItemErrorDuplicated._(CreateItemState state) : super._(state);
}
