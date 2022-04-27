import 'package:bloc/bloc.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter_challenge/cubits/application/application_cubit.dart';

part 'filter_state.dart';

class FilterCubit extends Cubit<FilterState> {
  final Stream<ApplicationState> applicationStateStream;
  FilterCubit(this.applicationStateStream) : super(FilterState()) {
    applicationStateStream.listen((appState) {
      if (appState is ApplicationShoppingList)
        search(state.value);
      else if (appState is ApplicationFavorites) _favorites();
    });
  }

  void search(String value) {
    if (value == '') {
      _disable();
    } else {
      _filter(value);
    }
  }

  void _favorites() {
    emit(state.copyWith(favorites: true));
  }

  void toggleFilter() {
    if (state.categories) {
      emit(state.copyWith(categories: false));
    } else {
      emit(state.copyWith(categories: true));
    }
  }

  void cancelFilter() {
    _disable();
  }

  void _disable() {
    emit(state.copyWith(value: '', enabled: false, favorites: false));
  }

  void _filter(String value) {
    emit(state.copyWith(value: value, enabled: true, favorites: false));
  }
}
