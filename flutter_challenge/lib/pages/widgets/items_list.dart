import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_challenge/cubits/category/category_cubit.dart';
import 'package:flutter_challenge/cubits/data/data_cubit.dart';
import 'package:flutter_challenge/cubits/filter/filter_cubit.dart';
import 'package:flutter_challenge/pages/shopping_list/category_items_list.dart';
import 'package:flutter_challenge/pages/favorites/favorite_category_items_list.dart';

class ItemsList extends StatelessWidget {
  const ItemsList({
    Key? key,
    this.favorites = false,
  }) : super(key: key);

  final bool favorites;

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<DataCubit, DataState>(
      buildWhen: (previous, current) =>
          previous.runtimeType != current.runtimeType ||
          previous.categories.length != current.categories.length,
      builder: (context, state) {
        if (state is DataReady) {
          return ScrollConfiguration(
            behavior: const ScrollBehavior().copyWith(overscroll: false),
            child: ListView(
              shrinkWrap: true,
              children: List.generate(state.categories.length, (index) {
                return favorites
                    ? FavoriteCategoryItemsList(
                        category: state.categories[index])
                    : CategoryItemsList(category: state.categories[index]);
              }),
            ),
          );
        } else {
          return Container();
        }
      },
    );
  }
}
