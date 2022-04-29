import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:flutter_challenge/exceptions.dart';
import 'package:flutter_challenge/models/item_category.dart';
import 'package:flutter_challenge/repositories/data_repository.dart';
import 'package:meta/meta.dart';

part 'create_category_state.dart';

class CreateCategoryCubit extends Cubit<CreateCategoryState> {
  final DataRepository repository;
  CreateCategoryCubit({required this.repository})
      : super(const CreateCategoryInitial(category: ItemCategory.empty()));

  void update({String? name, int? color}) {
    ItemCategory category = state.category.copyWith(name: name, color: color);
    if (category.validate()) {
      emit(CreateCategoryReady(category: category));
    } else {
      emit(CreateCategoryUpdated(category: category));
    }
  }

  void save() async {
    ItemCategory category = state.category;
    try {
      await repository.saveCategory(category);
      emit(CreateCategorySaved(category: category));
      emit(const CreateCategoryInitial(category: ItemCategory.empty()));
    } on DuplicatedElementException {
      emit(CreateCategoryErrorDuplicated(category: category));
    }
  }
}
