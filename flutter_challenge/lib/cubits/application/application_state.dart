part of 'application_cubit.dart';

@immutable
class ApplicationState {
  final String title;
  const ApplicationState(this.title);
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
