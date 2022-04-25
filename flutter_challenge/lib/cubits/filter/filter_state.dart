part of 'filter_cubit.dart';

@immutable
abstract class FilterState {
  final String itemName;
  const FilterState(this.itemName);
}

class FilterDisabled extends FilterState {
  const FilterDisabled() : super('');
}

class FilterEnabled extends FilterState {
  const FilterEnabled({required itemName}) : super(itemName);
}
