import 'package:bloc/bloc.dart';
import 'package:flutter_challenge/cubits/category/category_cubit.dart';
import 'package:flutter_challenge/cubits/filter/filter_cubit.dart';
import 'package:flutter_challenge/models/item.dart';
import 'package:flutter_challenge/models/item_category.dart';
import 'package:flutter_challenge/services/firestore.dart';
import 'package:meta/meta.dart';

part 'data_state.dart';

class DataCubit extends Cubit<DataState> {
  final fs = Firestore.instance;
  //final FilterCubit filterCubit;

  DataCubit() : super(DataLoading()) {
    _loadCategories();
  }

  // void toggleShow(ItemCategory category) {
  //   category.toggleShow();
  //   emit(AppReady(categories));
  // }
// TODO cancel subscriptions
  void _loadCategories() {
    fs.getCategories().listen((event) {
      if (state.categories.length != event.length) {
        emit(DataReady(event));
      }
    });
  }

  void applyFilter(String filter) {
    if (filter != state.filter) {
      emit(DataReady(state.categories, filter: filter));
    }
  }

  // void _loadItems() {
  //   for (ItemCategory cat in categories) {
  //     fs.getCategoryItems(cat).listen((items) {
  //       cat.items = items;
  //       print('Items of category ${cat.name} reloaded');
  //       emit(AppReady(categories));
  //     });
  //   }
  // }
}
