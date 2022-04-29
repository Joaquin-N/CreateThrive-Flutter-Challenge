import 'package:bloc/bloc.dart';
import 'package:meta/meta.dart';

part 'application_state.dart';

class ApplicationCubit extends Cubit<ApplicationState> {
  ApplicationCubit() : super(const ApplicationShoppingList());

  void toShoppingList() {
    emit(const ApplicationShoppingList());
  }

  void toFavorites() {
    emit(const ApplicationFavorites());
  }

  void toCreate() {
    emit(const ApplicationCreateItem());
  }

  void switchCreate(bool category) {
    emit(state is ApplicationCreateItem
        ? const ApplicationCreateItem()
        : const ApplicationCreateItem());
  }
}
