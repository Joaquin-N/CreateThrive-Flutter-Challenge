part of 'data_cubit.dart';

@immutable
abstract class DataState {
  final List<CategoryCubit> categoryCubits;
  final String filter;

  List<CategoryCubit> get categoriesWithFilter => categoryCubits
      .where((element) => element.state.category.name.contains(filter))
      .toList();

  const DataState(this.categoryCubits, this.filter);
}

//TODO
class DataLoading extends DataState {
  DataLoading() : super([], '');
}

class DataReady extends DataState {
  const DataReady(List<CategoryCubit> categories, {filter = ''})
      : super(categories, filter);
}
