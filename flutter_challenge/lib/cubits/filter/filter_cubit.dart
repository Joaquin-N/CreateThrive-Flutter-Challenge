import 'package:bloc/bloc.dart';
import 'package:flutter/cupertino.dart';

part 'filter_state.dart';

class FilterCubit extends Cubit<FilterState> {
  FilterCubit() : super(FilterItemsDisabled(TextEditingController())) {
    state.controller!.addListener(() {
      search(state.controller!.text);
    });
  }

  void search(filter) {
    if (filter == '') {
      _disable();
    } else {
      _filter(filter);
    }
  }

  void toggleFilter() {
    if (state is FilterItemsEnabled) {
      emit(FilterCategoriesEnabled(state.filter, state.controller));
    } else if (state is FilterCategoriesEnabled) {
      emit(FilterItemsEnabled(state.filter, state.controller));
    } else if (state is FilterItemsDisabled) {
      emit(FilterCategoriesDisabled(state.controller));
    } else {
      emit(FilterItemsDisabled(state.controller));
    }
  }

  void cancelFilter() {
    _disable();
  }

  void _disable() {
    emit(state is FilterCategories
        ? FilterCategoriesDisabled(state.controller)
        : FilterItemsDisabled(state.controller));
  }

  void _filter(String filter) {
    emit(state is FilterCategories
        ? FilterCategoriesEnabled(filter, state.controller)
        : FilterItemsEnabled(filter, state.controller));
  }
}
