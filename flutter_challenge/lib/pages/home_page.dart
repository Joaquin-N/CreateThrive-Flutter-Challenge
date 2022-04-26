import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_challenge/cubits/application/application_cubit.dart';
import 'package:flutter_challenge/cubits/create/create_cubit.dart';
import 'package:flutter_challenge/cubits/data/data_cubit.dart';
import 'package:flutter_challenge/cubits/filter/filter_cubit.dart';
import 'package:flutter_challenge/pages/create_page.dart';
import 'package:flutter_challenge/pages/favorites_page.dart';
import 'package:flutter_challenge/pages/shopping_list_page.dart';

class HomePage extends StatelessWidget {
  const HomePage({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return MultiBlocProvider(
      providers: [
        BlocProvider(create: (_) => ApplicationCubit(), lazy: false),
        BlocProvider(
            create: (context) =>
                FilterCubit(context.read<ApplicationCubit>().stream),
            lazy: false),
        BlocProvider(
            create: (context) => DataCubit(context.read<FilterCubit>().stream)),
        BlocProvider(create: (_) => CreateCubit())
      ],
      child: BlocBuilder<ApplicationCubit, ApplicationState>(
        builder: (context, state) {
          return Scaffold(
            appBar: AppBar(title: Text(state.title)),
            drawer: Builder(builder: (context) {
              return Drawer(
                child: Column(children: [
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
      ),
    );
  }
}
