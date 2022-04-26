part of 'filter_cubit.dart';

@immutable
class FilterState {
  final TextEditingController controller;
  final bool enabled;
  final bool categories;
  final bool favorites;
  const FilterState(
      {required this.controller,
      this.enabled = false,
      this.categories = false,
      this.favorites = false});

  String get value => controller.text;

  FilterState copyWith(
      {TextEditingController? controller,
      bool? enabled,
      bool? categories,
      bool? favorites}) {
    return FilterState(
        controller: controller ?? this.controller,
        enabled: enabled ?? this.enabled,
        categories: categories ?? this.categories,
        favorites: favorites ?? this.favorites);
  }
}
