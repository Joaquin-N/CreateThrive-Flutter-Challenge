import 'package:bloc/bloc.dart';
import 'package:flutter/cupertino.dart';

part 'filter_state.dart';

class FilterCubit extends Cubit<FilterState> {
  FilterCubit() : super(const FilterState());

  void search(String value) {
    if (value == '') {
      _disable();
    } else {
      _filter(value);
    }
  }

  void toggleFilter() {
    emit(state.copyWith(categories: !state.categories));
  }

  void cancelFilter() {
    _disable();
  }

  void _disable() {
    emit(state.copyWith(itemFilter: '', categoryFilter: ''));
  }

  void _filter(String value) {
    if (state.categories) {
      emit(state.copyWith(categoryFilter: value));
    } else {
      emit(state.copyWith(itemFilter: value));
    }
  }
}
