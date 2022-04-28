import 'package:bloc/bloc.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter_challenge/cubits/application/application_cubit.dart';

part 'filter_state.dart';

class FilterCubit extends Cubit<FilterState> {
  FilterCubit() : super(FilterState());

  void search(String value) {
    if (value == '') {
      _disable();
    } else {
      _filter(value);
    }
  }

  void toggleFilter() {
    if (state.categories) {
      emit(FilterState(
          categories: false,
          itemFilter: state.categoryFilter,
          categoryFilter: state.itemFilter));
    } else {
      emit(FilterState(
          categories: true,
          itemFilter: state.categoryFilter,
          categoryFilter: state.itemFilter));
    }
  }

  void cancelFilter() {
    _disable();
  }

  void _disable() {
    emit(FilterState(categories: state.categories));
  }

  void _filter(String value) {
    if (state.categories) {
      emit(FilterState(categories: state.categories, categoryFilter: value));
    } else {
      emit(FilterState(categories: state.categories, itemFilter: value));
    }
  }
}
