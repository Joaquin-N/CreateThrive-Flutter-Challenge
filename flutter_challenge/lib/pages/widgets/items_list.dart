import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_challenge/cubits/category/category_cubit.dart';
import 'package:flutter_challenge/cubits/data/data_cubit.dart';
import 'package:flutter_challenge/cubits/filter/filter_cubit.dart';
import 'package:flutter_challenge/pages/shopping_list/category_items_list.dart';
import 'package:flutter_challenge/pages/favorites/favorite_category_items_list.dart';
import 'package:flutter_challenge/repositories/data_repository.dart';

class ItemsList extends StatelessWidget {
  const ItemsList({
    Key? key,
    this.favorites = false,
  }) : super(key: key);

  final bool favorites;

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<FilterCubit, FilterState>(
        buildWhen: (previous, current) =>
            previous.categoryFilter != current.categoryFilter,
        builder: (context, filterState) {
          context.read<DataCubit>().applyFilter(filterState.categoryFilter);
          return BlocBuilder<DataCubit, DataState>(
            buildWhen: (previous, current) =>
                previous.runtimeType != current.runtimeType ||
                previous.categoriesWithFilter.length !=
                    current.categoriesWithFilter.length,
            builder: (context, state) {
              if (state is DataReady) {
                return ScrollConfiguration(
                  behavior: const ScrollBehavior().copyWith(overscroll: false),
                  child: ListView(
                    shrinkWrap: true,
                    children: List.generate(state.categoriesWithFilter.length,
                        (index) {
                      //TODO put favorites
                      return CategoryItemsList(
                          cubit: state.categoriesWithFilter[index]);
                    }),
                  ),
                );
              } else {
                return Container();
              }
            },
          );
        });
  }
}
