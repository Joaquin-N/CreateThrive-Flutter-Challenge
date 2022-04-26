import 'package:bloc/bloc.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter_challenge/cubits/application/application_cubit.dart';

part 'filter_state.dart';

class FilterCubit extends Cubit<FilterState> {
  final Stream<ApplicationState> applicationStateStream;
  FilterCubit(this.applicationStateStream)
      : super(FilterState(controller: TextEditingController())) {
    state.controller.addListener(() {
      _search();
    });
    applicationStateStream.listen((appState) {
      if (appState is ApplicationShoppingList)
        _search();
      else if (appState is ApplicationFavorites) _favorites();
    });
  }

  void _search() {
    String value = state.controller.text;
    if (value == '') {
      _disable();
    } else {
      _filter();
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
    emit(state.copyWith(enabled: false, favorites: false));
  }

  void _filter() {
    emit(state.copyWith(enabled: true, favorites: false));
  }
}
