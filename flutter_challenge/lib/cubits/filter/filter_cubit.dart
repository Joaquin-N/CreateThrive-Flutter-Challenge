import 'package:bloc/bloc.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter_challenge/cubits/application/application_cubit.dart';

part 'filter_state.dart';

class FilterCubit extends Cubit<FilterState> {
  final Stream<ApplicationState> applicationStateStream;
  FilterCubit(this.applicationStateStream)
      : super(FilterItemsDisabled(TextEditingController())) {
    state.controller!.addListener(() {
      _search();
    });
    applicationStateStream.listen((appState) {
      if (appState is ApplicationShoppingList)
        _search();
      else if (appState is ApplicationFavorites) _favorites();
    });
  }

  void _search() {
    String value = state.controller!.text;
    if (value == '') {
      _disable();
    } else {
      _filter(value);
    }
  }

  void _favorites() {
    emit(FilterFavorites(state.controller));
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

  void _filter(String value) {
    emit(state is FilterCategories
        ? FilterCategoriesEnabled(value, state.controller)
        : FilterItemsEnabled(value, state.controller));
  }
}
