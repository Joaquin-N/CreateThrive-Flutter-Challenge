part of 'app_cubit.dart';

@immutable
abstract class AppState {
  final List<String> categories;
  const AppState(this.categories);
}

class AppLoading extends AppState {
  AppLoading() : super([]);
}

class AppReady extends AppState {
  const AppReady(List<String> categories) : super(categories);
}
