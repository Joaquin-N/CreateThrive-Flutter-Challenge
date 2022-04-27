import 'package:bloc/bloc.dart';
import 'package:meta/meta.dart';

part 'application_state.dart';

class ApplicationCubit extends Cubit<ApplicationState> {
  ApplicationCubit() : super(const ApplicationInitial().toShoppingList());

  void toShoppingList() {
    emit(state.toShoppingList());
  }

  void toFavorites() {
    emit(state.toFavorites());
  }

  void toCreate() {
    emit(state.toCreateItem());
  }

  void switchCreate(bool category) {
    emit(category ? state.toCreateCategory() : state.toCreateItem());
  }
}
