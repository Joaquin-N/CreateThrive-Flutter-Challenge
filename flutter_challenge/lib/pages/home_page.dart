import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_challenge/cubits/application/application_cubit.dart';
import 'package:flutter_challenge/cubits/create_category/create_category_cubit.dart';
import 'package:flutter_challenge/cubits/create_item/create_item_cubit.dart';
import 'package:flutter_challenge/cubits/data/data_cubit.dart';
import 'package:flutter_challenge/cubits/filter/filter_cubit.dart';
import 'package:flutter_challenge/pages/create/create_page.dart';
import 'package:flutter_challenge/pages/favorites/favorites_page.dart';
import 'package:flutter_challenge/pages/shopping_list/shopping_list_page.dart';
import 'package:flutter_challenge/repositories/data_repository.dart';

class HomePage extends StatelessWidget {
  const HomePage({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return RepositoryProvider(
      create: (_) => DataRepository(),
      child: MultiBlocProvider(
        providers: [
          BlocProvider(create: (_) => ApplicationCubit(), lazy: false),
          BlocProvider(create: (_) => FilterCubit(), lazy: false),
          BlocProvider(
              create: (context) => DataCubit(
                  repository: RepositoryProvider.of<DataRepository>(context))),
          BlocProvider(
              create: (context) => CreateItemCubit(
                  repository: RepositoryProvider.of<DataRepository>(context))),
          BlocProvider(
              create: (context) => CreateCategoryCubit(
                  repository: RepositoryProvider.of<DataRepository>(context))),
        ],
        child: Home(),
      ),
    );
  }
}

class Home extends StatelessWidget {
  const Home({
    Key? key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<ApplicationCubit, ApplicationState>(
      builder: (context, state) {
        return Scaffold(
          appBar: AppBar(
            title: Text(state.title),
            backgroundColor: Colors.deepPurpleAccent,
          ),
          drawer: Builder(builder: (context) {
            return Drawer(
              child: Column(children: [
                DrawerHeader(child: Container()),
                TextButton(
                  onPressed: () {
                    context.read<ApplicationCubit>().toShoppingList();
                    Scaffold.of(context).openEndDrawer();
                  },
                  child: Text(ApplicationShoppingList.Title),
                ),
                TextButton(
                  onPressed: () {
                    context.read<ApplicationCubit>().toFavorites();
                    Scaffold.of(context).openEndDrawer();
                  },
                  child: Text(ApplicationFavorites.Title),
                ),
                TextButton(
                  onPressed: () {
                    context.read<ApplicationCubit>().toCreate();
                    Scaffold.of(context).openEndDrawer();
                  },
                  child: Text(ApplicationCreate.Title),
                ),
              ]),
            );
          }),
          body: state is ApplicationShoppingList
              ? ShoppingListPage()
              : state is ApplicationFavorites
                  ? FavoritesPage()
                  : CreatePage(),
        );
      },
    );
  }
}
