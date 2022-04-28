import 'package:bloc/bloc.dart';
import 'package:flutter_challenge/exceptions.dart';
import 'package:flutter_challenge/models/item_category.dart';
import 'package:flutter_challenge/repositories/data_repository.dart';
import 'package:flutter_challenge/services/firestore.dart';
import 'package:meta/meta.dart';

part 'create_category_state.dart';

class CreateCategoryCubit extends Cubit<CreateCategoryState> {
  final DataRepository repository;
  CreateCategoryCubit({required this.repository})
      : super(CreateCategoryInitial(category: ItemCategory.empty()));

  void update({String? name, int? color}) {
    if (name != null) state.category.name = name;
    if (color != null) state.category.color = color;
    if (state.category.validate()) {
      emit(state.toReady());
    } else {
      emit(state.toUpdated());
    }
  }

  void save() async {
    ItemCategory category = state.category;
    try {
      repository.saveCategory(category);
      emit(state.toSaved());
      emit(CreateCategoryInitial(category: ItemCategory.empty()));
    } on DuplicatedElementException {
      emit(state.toErrorDuplicated());
    }
  }
}
