part of 'create_category_cubit.dart';

@immutable
abstract class CreateCategoryState extends Equatable {
  final ItemCategory category;
  const CreateCategoryState(this.category);

  @override
  List<Object?> get props => [category];
}

class CreateCategoryInitial extends CreateCategoryState {
  const CreateCategoryInitial({required ItemCategory category})
      : super(category);
}

class CreateCategoryUpdated extends CreateCategoryState {
  const CreateCategoryUpdated({required ItemCategory category})
      : super(category);
}

class CreateCategorySaved extends CreateCategoryState {
  const CreateCategorySaved({required ItemCategory category}) : super(category);
}

class CreateCategoryReady extends CreateCategoryState {
  const CreateCategoryReady({required ItemCategory category}) : super(category);
}

class CreateCategoryErrorDuplicated extends CreateCategoryState {
  const CreateCategoryErrorDuplicated({required ItemCategory category})
      : super(category);
}
