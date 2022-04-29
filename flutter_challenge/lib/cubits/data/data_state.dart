part of 'data_cubit.dart';

@immutable
class DataState {
  final List<ItemCategory> categories;
  final String filter;
  final bool loading;

  List<ItemCategory> get categoriesWithFilter => categories
      .where((element) =>
          element.name.toLowerCase().contains(filter.toLowerCase()))
      .toList();

  const DataState()
      : categories = const [],
        filter = '',
        loading = true;
  const DataState._(this.categories, this.filter) : loading = false;

  DataState copyWith({List<ItemCategory>? categories, String? filter}) =>
      DataState._(categories ?? this.categories, filter ?? this.filter);
}
