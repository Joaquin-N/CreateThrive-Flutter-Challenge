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

class CategoryItemsList extends StatelessWidget {
  const CategoryItemsList({
    Key? key,
    required this.cubit,
  }) : super(key: key);
  final CategoryCubit cubit;

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<FilterCubit, FilterState>(
      builder: (context, filterState) {
        context.read<DataCubit>().applyFilter(filterState.categoryFilter);
        cubit.applyFilter(filterState.itemFilter);

        return BlocBuilder<CategoryCubit, CategoryState>(
          bloc: cubit,
          builder: (context, state) {
            if (state is LoadingCategory) {
              return Container();
            }

            List<Item> filteredItems = state.itemsWithFilter;
            var dataCubit = context.read<DataCubit>();
            return Visibility(
              visible: filteredItems.isNotEmpty &&
                  state.category
                      .isEqualToAny(dataCubit.state.categoriesWithFilter),
              child: Container(
                color: Color(state.category.color).withOpacity(0.6),
                width: double.infinity,
                child: Column(
                  children: [
                    GestureDetector(
                      onTap: cubit.toggleShow,
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
            return Future.value(true);
          }
        }
        return Future.value(false);
      },
      child: ListTile(
        onLongPress: () => print('edit'),
        title: Text(item.name),
        trailing: Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            IconButton(
              onPressed: () => onToggleFav(),
              icon: Icon(item.isFavorite() ? Icons.star : Icons.star_border),
            ),
            ReorderableDragStartListener(
              index: index,
              child: const Icon(Icons.drag_handle),
            ),
          ],
        ),
      ),
    );
  }
}
