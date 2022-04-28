import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_challenge/cubits/category/category_cubit.dart';
import 'package:flutter_challenge/cubits/data/data_cubit.dart';
import 'package:flutter_challenge/cubits/filter/filter_cubit.dart';
import 'package:flutter_challenge/cubits/item/item_cubit.dart';
import 'package:flutter_challenge/models/item.dart';
import 'package:flutter_challenge/models/item_category.dart';
import 'package:flutter_challenge/pages/widgets/custom_snack_bar.dart';
import 'package:flutter_challenge/pages/widgets/delete_dialog.dart';

class CategoryItemsList extends StatefulWidget {
  CategoryItemsList({
    Key? key,
    required ItemCategory category,
  })  : cubit = CategoryCubit(category: category),
        super(key: key);
  final CategoryCubit cubit;

  @override
  State<CategoryItemsList> createState() => _CategoryItemsListState();
}

class _CategoryItemsListState extends State<CategoryItemsList> {
  @override
  void dispose() {
    widget.cubit.close();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<FilterCubit, FilterState>(
      builder: (context, filterState) {
        context.read<DataCubit>().applyFilter(filterState.categoryFilter);
        widget.cubit.applyFilter(filterState.itemFilter);

        return BlocBuilder<CategoryCubit, CategoryState>(
          bloc: widget.cubit,
          builder: (context, state) {
            if (state is LoadingCategory) {
              return Container();
            }

            List<Item> filteredItems = state.itemsWithFilter;
            return Visibility(
              visible: filteredItems.isNotEmpty &&
                  context
                      .read<DataCubit>()
                      .state
                      .categoriesWithFilter
                      .contains(state.category),
              child: Container(
                color: Color(state.category.color).withOpacity(0.6),
                width: double.infinity,
                child: Column(
                  children: [
                    GestureDetector(
                      onTap: widget.cubit.toggleShow,
                      child: Container(
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
                            widget.cubit.reorder(oldIndex, newIndex),
                        children: List.generate(
                          filteredItems.length,
                          (index) {
                            return ItemListTile(
                              index: index,
                              item: filteredItems[index],
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
        );
      },
    );
  }
}

class ItemListTile extends StatefulWidget {
  ItemListTile({
    Key? key,
    required this.index,
    required Item item,
  })  : cubit = ItemCubit(item: item),
        super(key: key);

  final int index;
  final ItemCubit cubit;

  @override
  State<ItemListTile> createState() => _ItemListTileState();
}

class _ItemListTileState extends State<ItemListTile> {
  @override
  void dispose() {
    widget.cubit.close();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return BlocConsumer<ItemCubit, ItemState>(
        bloc: widget.cubit,
        builder: (context, state) {
          if (state is ItemNotShowing) return Container();
          return Dismissible(
            key: Key('x$widget.key'),
            background: Container(color: Colors.yellow[200]),
            secondaryBackground: Container(color: Colors.red[400]),
            // TODO sync dismiss with rebuild
            confirmDismiss: (direction) async {
              if (direction == DismissDirection.startToEnd) {
                widget.cubit.toggleFav();
              } else {
                bool? answer = await showDialog(
                    context: context,
                    builder: (context) => DeleteDialog(
                          itemName: state.item.name,
                        ));
                if (answer != null && answer) {
                  widget.cubit.delete();
                }
              }
              return Future.value(false);
            },
            child: ListTile(
              onLongPress: () => print('edit'),
              title: Text(state.item.name),
              trailing: Row(
                mainAxisSize: MainAxisSize.min,
                children: [
                  IconButton(
                    onPressed: () => widget.cubit.toggleFav(),
                    icon: Icon(
                        state is ItemFavorite ? Icons.star : Icons.star_border),
                  ),
                  ReorderableDragStartListener(
                    index: widget.index,
                    child: const Icon(Icons.drag_handle),
                  ),
                ],
              ),
            ),
          );
        },
        listenWhen: (oldState, newState) {
          return (oldState is ItemFavorite && newState is ItemNotFavorite) ||
              (oldState is ItemNotFavorite && newState is ItemFavorite);
        },
        listener: (context, state) {
          ScaffoldMessenger.of(context).showSnackBar(CustomSnackBar(
              text:
                  'Item ${state.item.name} ${state is ItemFavorite ? "added to" : "removed from"} favorites'));
        });
  }
}
