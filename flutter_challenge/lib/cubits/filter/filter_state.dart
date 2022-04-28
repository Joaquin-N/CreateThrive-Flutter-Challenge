part of 'filter_cubit.dart';

@immutable
class FilterState {
  final String itemFilter;
  final String categoryFilter;
  final bool categories;

  const FilterState(
      {this.itemFilter = '',
      this.categoryFilter = '',
      this.categories = false});
}
