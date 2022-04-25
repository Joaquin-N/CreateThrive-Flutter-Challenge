import 'package:bloc/bloc.dart';
import 'package:meta/meta.dart';

part 'filter_state.dart';

class FilterCubit extends Cubit<FilterState> {
  FilterCubit() : super(FilterDisabled());

  void setFilter({required itemName}) {
    if (itemName == '') {
      emit(FilterDisabled());
    } else {
      emit(FilterEnabled(itemName: itemName));
    }
  }

  void cancelFilter() {
    emit(FilterDisabled());
  }
}
