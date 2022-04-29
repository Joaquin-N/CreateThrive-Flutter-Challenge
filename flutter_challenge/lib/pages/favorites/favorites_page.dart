import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_challenge/cubits/category/category_cubit.dart';
import 'package:flutter_challenge/cubits/data/data_cubit.dart';
import 'package:flutter_challenge/pages/favorites/favorite_items_list.dart';
import 'package:flutter_challenge/repositories/data_repository.dart';

class FavoritesPage extends StatelessWidget {
  const FavoritesPage({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<DataCubit, DataState>(
      buildWhen: (previous, current) =>
          previous.categories.length != current.categories.length,
      builder: (context, state) {
        if (state is DataReady) {
          return ScrollConfiguration(
            behavior: const ScrollBehavior().copyWith(overscroll: false),
            child: ListView(
              shrinkWrap: true,
              children: List.generate(state.categories.length, (index) {
                return FavoriteItemsList(
                    cubit: CategoryCubit(
                        category: state.categories[index],
                        repository:
                            RepositoryProvider.of<DataRepository>(context)));
              }),
            ),
          );
        } else {
          return const Center(child: CircularProgressIndicator());
        }
      },
    );
  }
}
