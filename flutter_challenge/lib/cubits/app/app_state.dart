part of 'app_cubit.dart';

@immutable
abstract class AppState {}

class AppLoading extends AppState {}

class AppReady extends AppState {
  final List<ItemCategory> categories;
  AppReady(this.categories);
}
