import 'package:bloc/bloc.dart';
import 'package:flutter_challenge/models/item_category.dart';
import 'package:flutter_challenge/services/firestore.dart';
import 'package:meta/meta.dart';

part 'category_state.dart';

class CategoryCubit extends Cubit<CategoryState> {
  CategoryCubit() : super(CategoryLoading()) {
    _updateCategories();
  }

  void _updateCategories() {
    Firestore.instance.getCategories().listen((event) {
      emit(CategoryReady(categories: event));
    });
  }
}
