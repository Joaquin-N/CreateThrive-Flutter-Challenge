import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_challenge/constants.dart';
import 'package:flutter_challenge/cubits/category/category_cubit.dart';
import 'package:flutter_challenge/cubits/data/data_cubit.dart';
import 'package:flutter_challenge/cubits/filter/filter_cubit.dart';
import 'package:flutter_challenge/cubits/item/item_cubit.dart';
import 'package:flutter_challenge/models/item.dart';
import 'package:flutter_challenge/models/item_category.dart';
import 'package:flutter_challenge/pages/widgets/custom_snack_bar.dart';
import 'package:flutter_challenge/pages/widgets/delete_dialog.dart';

class CategoryItemsList extends StatelessWidget {
  const CategoryItemsList({
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
                          'Item ${state.lastFavoriteAdded} added to favorites'));
                }),
            BlocListener<CategoryCubit, CategoryState>(
                bloc: cubit,
                listenWhen: (oldState, newState) =>
                    oldState.lastFavoriteRemoved !=
                    newState.lastFavoriteRemoved,
                listener: (context, state) {
                  ScaffoldMessenger.of(context).showSnackBar(CustomSnackBar(
                      text:
                          'Item ${state.lastFavoriteRemoved} removed from favorites'));
                })
          ],
          child: BlocBuilder<CategoryCubit, CategoryState>(
            bloc: cubit,
            builder: (context, state) {
              if (state is LoadingCategory) {
                return Container();
              }

              List<Item> filteredItems = state.itemsWithFilter;
              return Visibility(
                visible: filteredItems.isNotEmpty,
                child: Container(
                  color: Color(state.category.color).withOpacity(0.6),
                  width: double.infinity,
                  child: Column(
                    children: [
                      GestureDetector(
                        onTap: cubit.toggleShow,
                        child: Container(
                          decoration: categoryBoxDecoration,
                          padding: EdgeInsets.symmetric(horizontal: 18),
                          height: 50,
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              SizedBox(width: 32.0),
                              Text(
                                state.category.name,
                                style: TextStyle(fontSize: 16),
                              ),
                              Icon(state is CategoryShowItems
                                  ? Icons.arrow_drop_down
                                  : Icons.arrow_left),
                            ],
                          ),
                        ),
                      ),
                      if (state is CategoryShowItems)
                        ReorderableListView(
                          physics: const NeverScrollableScrollPhysics(),
                          shrinkWrap: true,
                          onReorder: (oldIndex, newIndex) =>
                              cubit.reorder(oldIndex, newIndex),
                          children: List.generate(
                            filteredItems.length,
                            (index) {
                              return ItemListTile(
                                index: index,
                                item: filteredItems[index],
                                onToggleFav: () =>
                                    cubit.toggleFav(filteredItems[index]),
                                onDelete: () =>
                                    cubit.delete(filteredItems[index]),
                                key: Key('$index'),
                              );
                            },
                          ),
                        ),
                    ],
                  ),
                ),
              );
            },
          ),
        );
      },
    );
  }
}

class ItemListTile extends StatelessWidget {
  const ItemListTile({
    Key? key,
    required this.index,
    required this.item,
    required this.onToggleFav,
    required this.onDelete,
  }) : super(key: key);

  final int index;
  final Item item;
  final Function() onToggleFav;
  final Function() onDelete;

  @override
  Widget build(BuildContext context) {
    bool reorderEnabled = context.read<FilterCubit>().state.itemFilter == '' &&
        context.read<FilterCubit>().state.categoryFilter == '';
    return Dismissible(
      key: Key('x$key'),
      background: Container(color: Colors.yellow[200]),
      secondaryBackground: Container(color: Colors.red[400]),
      // TODO sync dismiss with rebuild
      confirmDismiss: (direction) async {
        if (direction == DismissDirection.startToEnd) {
          onToggleFav();
        } else {
          bool? answer = await showDialog(
              context: context,
              builder: (context) => DeleteDialog(
                    itemName: item.name,
                  ));
          if (answer != null && answer) {
            onDelete();
          }
        }
        return Future.value(false);
      },
      child: ListTile(
        shape: const UnderlineInputBorder(
            borderSide: BorderSide(color: Colors.grey, width: 1)),
        onLongPress: () => print('edit'),
        title: Text(item.name),
        trailing: Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            IconButton(
              onPressed: () => onToggleFav(),
              icon: Icon(item.isFavorite() ? Icons.star : Icons.star_border),
            ),
            Visibility(
              child: ReorderableDragStartListener(
                enabled: reorderEnabled,
                index: index,
                child: Icon(
                  Icons.drag_handle,
                  color: reorderEnabled
                      ? Theme.of(context).iconTheme.color
                      : Colors.grey.withOpacity(0.7),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
