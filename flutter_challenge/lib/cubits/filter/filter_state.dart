part of 'filter_cubit.dart';

@immutable
class FilterState {
  final String itemFilter;
  final String categoryFilter;
  final bool categories;

  const FilterState()
      : itemFilter = '',
        categoryFilter = '',
        categories = false;
  const FilterState._(this.itemFilter, this.categoryFilter, this.categories);

  FilterState copyWith(
          {String? itemFilter, String? categoryFilter, bool? categories}) =>
      FilterState._(itemFilter ?? this.itemFilter,
          categoryFilter ?? this.categoryFilter, categories ?? this.categories);
}
