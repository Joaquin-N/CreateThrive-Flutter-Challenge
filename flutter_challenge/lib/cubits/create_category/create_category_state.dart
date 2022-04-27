part of 'create_category_cubit.dart';

@immutable
abstract class CreateCategoryState {
  final ItemCategory category;
  const CreateCategoryState(this.category);
  CreateCategoryState._(CreateCategoryState state) : category = state.category;

  CreateCategoryUpdated toUpdated() => CreateCategoryUpdated._(this);
  CreateCategoryReady toReady() => CreateCategoryReady._(this);
  CreateCategoryErrorDuplicated toErrorDuplicated() =>
      CreateCategoryErrorDuplicated._(this);
}

class CreateCategoryInitial extends CreateCategoryState {
  const CreateCategoryInitial({required ItemCategory category})
      : super(category);
}

class CreateCategoryUpdated extends CreateCategoryState {
  CreateCategoryUpdated._(CreateCategoryState state) : super._(state);
}

class CreateCategoryReady extends CreateCategoryState {
  CreateCategoryReady._(CreateCategoryState state) : super._(state);
}

class CreateCategoryErrorDuplicated extends CreateCategoryState {
  CreateCategoryErrorDuplicated._(CreateCategoryState state) : super._(state);
}
