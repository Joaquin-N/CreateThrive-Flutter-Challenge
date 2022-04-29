import 'dart:async';

import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
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
  StreamSubscription? suscription;

  DataCubit({required this.repository}) : super(const DataState()) {
    _loadCategories();
  }

  void _loadCategories() {
    suscription = repository.getCategories().listen((event) {
      if (state.categories.length != event.length) {
        emit(state.copyWith(categories: event));
      }
    });
  }

  void applyFilter(String filter) {
    if (filter != state.filter) {
      emit(state.copyWith(filter: filter));
    }
  }

  @override
  Future<void> close() {
    suscription?.cancel();
    return super.close();
  }
}
