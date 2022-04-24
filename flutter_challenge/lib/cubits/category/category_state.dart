part of 'category_cubit.dart';

@immutable
abstract class CategoryState {}

class CategoryLoading extends CategoryState {}

class CategoryReady extends CategoryState {
  final List<ItemCategory> categories;

  CategoryReady({this.categories = const <ItemCategory>[]});
}
