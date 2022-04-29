import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_challenge/constants.dart';
import 'package:flutter_challenge/cubits/application/application_cubit.dart';
import 'package:flutter_challenge/cubits/create_category/create_category_cubit.dart';
import 'package:flutter_challenge/cubits/create_item/create_item_cubit.dart';
import 'package:flutter_challenge/cubits/data/data_cubit.dart';
import 'package:flutter_challenge/cubits/filter/filter_cubit.dart';
import 'package:flutter_challenge/pages/create/create_page.dart';
import 'package:flutter_challenge/pages/favorites/favorites_page.dart';
import 'package:flutter_challenge/pages/shopping_list/shopping_list_page.dart';
import 'package:flutter_challenge/pages/widgets/drawer_button.dart';
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
        child: const Home(),
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
            return const CustomDrawer();
          }),
          body: state is ApplicationShoppingList
              ? const ShoppingListPage()
              : state is ApplicationFavorites
                  ? const FavoritesPage()
                  : const CreatePage(),
        );
      },
    );
  }
}

class CustomDrawer extends StatelessWidget {
  const CustomDrawer({
    Key? key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Drawer(
      backgroundColor: Colors.grey.shade200,
      child: Column(children: [
        DrawerHeader(
            margin: EdgeInsets.zero,
            padding: EdgeInsets.zero,
            decoration: const BoxDecoration(
              image: DecorationImage(
                fit: BoxFit.fill,
                image: AssetImage('assets/shopping_cart.png'),
              ),
            ),
            child: Stack(children: const <Widget>[
              Positioned(
                  bottom: 12.0,
                  left: 16.0,
                  child: Text("Shopping App",
                      style: TextStyle(
                          color: Colors.white,
                          fontSize: 20.0,
                          fontWeight: FontWeight.w500))),
            ])),
        const Divider(),
        DrawerButton(
          onPressed: () {
            context.read<ApplicationCubit>().toShoppingList();
            Scaffold.of(context).openEndDrawer();
          },
          text: ApplicationShoppingList.Title,
          icon: Icons.shopping_cart_outlined,
        ),
        const Divider(),
        DrawerButton(
          onPressed: () {
            context.read<ApplicationCubit>().toFavorites();
            Scaffold.of(context).openEndDrawer();
          },
          text: ApplicationFavorites.Title,
          icon: Icons.star_border,
        ),
        const Divider(),
        DrawerButton(
          onPressed: () {
            context.read<ApplicationCubit>().toCreate();
            Scaffold.of(context).openEndDrawer();
          },
          text: ApplicationCreate.Title,
          icon: Icons.add,
        ),
        const Divider(),
      ]),
    );
  }
}
