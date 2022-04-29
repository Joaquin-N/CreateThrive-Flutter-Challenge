// ignore_for_file: constant_identifier_names

part of 'application_cubit.dart';

@immutable
abstract class ApplicationState extends Equatable {
  final String title;
  const ApplicationState(this.title);

  @override
  List<Object?> get props => [title];
}

class ApplicationShoppingList extends ApplicationState {
  static const Title = 'Shopping List';
  const ApplicationShoppingList() : super(Title);
}

class ApplicationFavorites extends ApplicationState {
  static const Title = 'Favorites';
  const ApplicationFavorites() : super(Title);
}

abstract class ApplicationCreate extends ApplicationState {
  static const Title = 'Create Item/Category';
  const ApplicationCreate() : super(Title);
}

class ApplicationCreateItem extends ApplicationCreate {
  const ApplicationCreateItem() : super();
}

class ApplicationCreateCategory extends ApplicationCreate {
  const ApplicationCreateCategory() : super();
}
