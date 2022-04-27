import 'package:bloc/bloc.dart';
import 'package:flutter_challenge/models/item_category.dart';
import 'package:flutter_challenge/services/firestore.dart';
import 'package:meta/meta.dart';

part 'create_category_state.dart';

class CreateCategoryCubit extends Cubit<CreateCategoryState> {
  Firestore fs = Firestore.instance;
  CreateCategoryCubit()
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
    if (await fs.checkCategoryDuplicated(category)) {
      emit(state.toErrorDuplicated());
      return;
    }
    fs.saveCategory(category);
    emit(CreateCategoryInitial(category: ItemCategory.empty()));
  }
}
