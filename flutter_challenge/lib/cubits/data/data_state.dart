part of 'data_cubit.dart';

@immutable
abstract class DataState {
  final List<ItemCategory> categories;
  final String filter;

  List<ItemCategory> get categoriesWithFilter =>
      categories.where((element) => element.name.contains(filter)).toList();

  const DataState(this.categories, this.filter);
}

//TODO
class DataLoading extends DataState {
  DataLoading() : super([], '');
}

class DataReady extends DataState {
  const DataReady(List<ItemCategory> categories, {filter = ''})
      : super(categories, filter);
}
