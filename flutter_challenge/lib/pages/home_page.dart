import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_challenge/cubits/app/app_cubit.dart';
import 'package:flutter_challenge/cubits/filter/filter_cubit.dart';
import 'package:flutter_challenge/pages/shopping_list_page.dart';

class HomePage extends StatelessWidget {
  const HomePage({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return MultiBlocProvider(
      providers: [
        BlocProvider(create: (_) => AppCubit()),
        BlocProvider(create: (_) => FilterCubit()),
      ],
      child: Scaffold(
        appBar: AppBar(title: Text('title')),
        drawer: Drawer(
          child: Column(children: [
            TextButton(onPressed: () {}, child: Text('Shopping List')),
          ]),
        ),
        body: ShoppingListPage(),
      ),
    );
  }
}
