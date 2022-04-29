import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_challenge/cubits/category/category_cubit.dart';
import 'package:flutter_challenge/cubits/data/data_cubit.dart';
import 'package:flutter_challenge/cubits/filter/filter_cubit.dart';
import 'package:flutter_challenge/models/item.dart';
import 'package:flutter_challenge/pages/widgets/custom_snack_bar.dart';
import 'package:flutter_challenge/pages/widgets/items_list.dart';

class AllItemsList extends StatelessWidget {
  const AllItemsList({
    Key? key,
    required this.cubit,
  }) : super(key: key);
  final CategoryCubit cubit;

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<FilterCubit, FilterState>(
      buildWhen: (previous, current) =>
          previous.itemFilter != current.itemFilter,
      builder: (context, filterState) {
        cubit.applyFilter(filterState.itemFilter);

        return MultiBlocListener(
          listeners: [
            BlocListener<CategoryCubit, CategoryState>(
                bloc: cubit,
                listenWhen: (oldState, newState) =>
                    oldState.lastFavoriteAdded != newState.lastFavoriteAdded,
                listener: (context, state) {
                  ScaffoldMessenger.of(context).showSnackBar(CustomSnackBar(
                      text:
                          'Item ${state.lastFavoriteAdded!.name} added to favorites'));
                }),
            BlocListener<CategoryCubit, CategoryState>(
                bloc: cubit,
                listenWhen: (oldState, newState) =>
                    oldState.lastFavoriteRemoved !=
                    newState.lastFavoriteRemoved,
                listener: (context, state) {
                  ScaffoldMessenger.of(context).showSnackBar(CustomSnackBar(
                      text:
                          'Item ${state.lastFavoriteRemoved!.name} removed from favorites'));
                })
          ],
          child: BlocBuilder<CategoryCubit, CategoryState>(
            bloc: cubit,
            builder: (context, state) {
              if (state.loading) {
                return Container();
              }

              List<Item> filteredItems = state.itemsWithFilter;
              bool reorderEnabled =
                  context.read<FilterCubit>().state.itemFilter == '' &&
                      context.read<FilterCubit>().state.categoryFilter == '';
              final dataCubit = context.watch<DataCubit>();
              return Visibility(
                  visible: filteredItems.isNotEmpty &&
                      state.category
                          .isEqualToAny(dataCubit.state.categoriesWithFilter),
                  child: ItemsList(
                    name: state.category.name,
                    items: state.itemsWithFilter,
                    color: Color(state.category.color),
                    onToggleFav: cubit.toggleFav,
                    onDelete: cubit.delete,
                    onToggleShow: cubit.toggleShow,
                    show: state.showItems,
                    onReorder: reorderEnabled ? cubit.reorder : null,
                  ));
            },
          ),
        );
      },
    );
  }
}
