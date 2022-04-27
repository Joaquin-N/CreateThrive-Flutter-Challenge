part of 'application_cubit.dart';

@immutable
class ApplicationState {
  final String title;
  const ApplicationState(this.title);

  ApplicationShoppingList toShoppingList() => const ApplicationShoppingList._();
  ApplicationFavorites toFavorites() => const ApplicationFavorites._();
  ApplicationCreateItem toCreateItem() => const ApplicationCreateItem._();
  ApplicationCreateCategory toCreateCategory() =>
      const ApplicationCreateCategory._();
}

class ApplicationInitial extends ApplicationState {
  const ApplicationInitial() : super('');
}

class ApplicationShoppingList extends ApplicationState {
  static const Title = 'Shopping List';
  const ApplicationShoppingList._() : super(Title);
}

class ApplicationFavorites extends ApplicationState {
  static const Title = 'Favorites';
  const ApplicationFavorites._() : super(Title);
}

class ApplicationCreate extends ApplicationState {
  static const Title = 'Create Item/Category';
  const ApplicationCreate() : super(Title);
}

class ApplicationCreateItem extends ApplicationCreate {
  const ApplicationCreateItem._() : super();
}

class ApplicationCreateCategory extends ApplicationCreate {
  const ApplicationCreateCategory._() : super();
}
