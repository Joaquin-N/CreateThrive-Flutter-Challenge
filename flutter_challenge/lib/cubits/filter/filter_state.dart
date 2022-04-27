part of 'filter_cubit.dart';

@immutable
class FilterState {
  final String value;
  final bool enabled;
  final bool categories;
  final bool favorites;
  const FilterState(
      {this.value = '',
      this.enabled = false,
      this.categories = false,
      this.favorites = false});

  FilterState copyWith(
      {String? value, bool? enabled, bool? categories, bool? favorites}) {
    return FilterState(
        value: value ?? this.value,
        enabled: enabled ?? this.enabled,
        categories: categories ?? this.categories,
        favorites: favorites ?? this.favorites);
  }
}
