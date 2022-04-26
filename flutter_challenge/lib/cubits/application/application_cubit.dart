import 'package:bloc/bloc.dart';
import 'package:flutter_challenge/constants.dart';
import 'package:meta/meta.dart';

part 'application_state.dart';

class ApplicationCubit extends Cubit<ApplicationState> {
  ApplicationCubit() : super(ApplicationShoppingList());

  void toShoppingList() {
    emit(ApplicationShoppingList());
  }

  void toFavorites() {
    emit(ApplicationFavorites());
  }

  void toCreate() {
    emit(ApplicationCreate());
  }
}
