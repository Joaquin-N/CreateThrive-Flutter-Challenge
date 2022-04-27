import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_challenge/cubits/category/category_cubit.dart';
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
    return BlocBuilder<CategoryCubit, CategoryState>(
      bloc: cubit,
      builder: (context, state) {
        ItemCategory category = state.category;
        if (state is CategoryHide || state is LoadingCategory) {
          return Container();
        }
        return Container(
          color: Color(category.color).withOpacity(0.6),
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
                        category.name,
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
                    category.itemsId.length,
                    (index) {
                      return ItemListTile(
                        index: index,
                        cubit: state.itemCubits[index],
                        key: Key('$index'),
                      );
                    },
                  ),
                ),
            ],
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
    required this.cubit,
  }) : super(key: key);

  final int index;
  final ItemCubit cubit;

  @override
  Widget build(BuildContext context) {
    return BlocConsumer<ItemCubit, ItemState>(
        bloc: cubit,
        builder: (context, state) {
          if (state is ItemNotShowing) return Container();
          return Dismissible(
            key: Key('x$key'),
            background: Container(color: Colors.yellow[200]),
            secondaryBackground: Container(color: Colors.red[400]),
            // TODO sync dismiss with rebuild
            confirmDismiss: (direction) async {
              if (direction == DismissDirection.startToEnd) {
                cubit.toggleFav();
              } else {
                bool? answer = await showDialog(
                    context: context,
                    builder: (context) => DeleteDialog(
                          itemName: state.item.name,
                        ));
                if (answer != null && answer) {
                  cubit.delete();
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
                    onPressed: () => cubit.toggleFav(),
                    icon: Icon(
                        state is ItemFavorite ? Icons.star : Icons.star_border),
                  ),
                  ReorderableDragStartListener(
                    index: index,
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
