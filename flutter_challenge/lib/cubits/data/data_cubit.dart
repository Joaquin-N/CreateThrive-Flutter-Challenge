import 'package:bloc/bloc.dart';
import 'package:flutter_challenge/cubits/category/category_cubit.dart';
import 'package:flutter_challenge/cubits/filter/filter_cubit.dart';
import 'package:flutter_challenge/models/item.dart';
import 'package:flutter_challenge/models/item_category.dart';
import 'package:flutter_challenge/repositories/data_repository.dart';
import 'package:flutter_challenge/services/firestore.dart';
import 'package:meta/meta.dart';

part 'data_state.dart';

class DataCubit extends Cubit<DataState> {
  final DataRepository repository;
  //final FilterCubit filterCubit;

  DataCubit({required this.repository}) : super(DataLoading()) {
    _loadCategories();
  }

  // void toggleShow(ItemCategory category) {
  //   category.toggleShow();
  //   emit(AppReady(categories));
  // }
// TODO cancel subscriptions
  void _loadCategories() {
    repository.getCategories().listen((event) {
      if (state.categoryCubits.length != event.length) {
        emit(DataReady(List.generate(
            event.length,
            (index) => CategoryCubit(
                category: event[index], repository: repository))));
      }
    });
  }

  void applyFilter(String filter) {
    if (filter != state.filter) {
      emit(DataReady(state.categoryCubits, filter: filter));
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
