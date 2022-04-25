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
  final Stream<FilterState> filterStateStream;
  //final FilterCubit filterCubit;

  DataCubit(this.filterStateStream) : super(DataLoading()) {
    _loadCategories();
  }

  // void toggleShow(ItemCategory category) {
  //   category.toggleShow();
  //   emit(AppReady(categories));
  // }

  void _loadCategories() {
    fs.getCategoriesIds().listen((event) {
      if (state.categoryCubits.length != event.length) {
        emit(DataReady(List.generate(
            event.length,
            (index) => CategoryCubit(
                categoryId: event[index],
                filterStateStream: filterStateStream))));
      }
    });
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
