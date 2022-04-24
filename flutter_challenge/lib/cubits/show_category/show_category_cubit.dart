import 'package:bloc/bloc.dart';
import 'package:meta/meta.dart';

part 'show_category_state.dart';

class ShowCategoryCubit extends Cubit<ShowCategoryState> {
  ShowCategoryCubit() : super(ShowCategory());

  void toggleShow() {
    if (state is ShowCategory) {
      emit(HideCategory());
    } else {
      emit(ShowCategory());
    }
  }
}
