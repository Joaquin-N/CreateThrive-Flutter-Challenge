part of 'filter_cubit.dart';

@immutable
abstract class FilterState {
  final String filter;
  final TextEditingController? controller;
  const FilterState({this.filter = '', this.controller});
}

abstract class FilterDisabled extends FilterState {}

abstract class FilterEnabled extends FilterState {}

abstract class FilterItems extends FilterState {}

abstract class FilterCategories extends FilterState {}

class FilterItemsDisabled extends FilterState
    implements FilterItems, FilterDisabled {
  const FilterItemsDisabled(tec) : super(controller: tec);
}

class FilterCategoriesDisabled extends FilterState
    implements FilterCategories, FilterDisabled {
  const FilterCategoriesDisabled(tec) : super(controller: tec);
}

class FilterItemsEnabled extends FilterState
    implements FilterItems, FilterEnabled {
  const FilterItemsEnabled(value, tec) : super(filter: value, controller: tec);
}

class FilterCategoriesEnabled extends FilterState
    implements FilterCategories, FilterEnabled {
  const FilterCategoriesEnabled(value, tec)
      : super(filter: value, controller: tec);
}

class FilterFavorites extends FilterState {
  const FilterFavorites(tec) : super(controller: tec);
}
