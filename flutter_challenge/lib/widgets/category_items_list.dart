import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_challenge/cubits/category/category_cubit.dart';
import 'package:flutter_challenge/cubits/item/item_cubit.dart';
import 'package:flutter_challenge/models/item.dart';
import 'package:flutter_challenge/models/item_category.dart';

class CategoryItemsList extends StatelessWidget {
  const CategoryItemsList({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<CategoryCubit, CategoryState>(
      builder: (context, state) {
        ItemCategory category = state.category;
        return Container(
          color: category.color,
          width: double.infinity,
          child: Column(
            children: [
              GestureDetector(
                onTap: () => context.read<CategoryCubit>().toggleShow(),
                child: Text(category.name),
              ),
              if (state is ShowCategory)
                ReorderableListView(
                  physics: const NeverScrollableScrollPhysics(),
                  shrinkWrap: true,
                  onReorder: (oldIndex, newIndex) =>
                      context.read<CategoryCubit>().reorder(oldIndex, newIndex),
                  children: List.generate(
                    category.items.length,
                    (index) {
                      Item item = category.items[index];
                      return ItemListTile(
                        index: index,
                        item: item,
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
    required this.item,
  }) : super(key: key);

  final int index;
  final Item item;

  @override
  Widget build(BuildContext context) {
    var cubit = ItemCubit(item);
    return BlocBuilder<ItemCubit, ItemState>(
      bloc: cubit,
      builder: (context, state) {
        return ListTile(
          onLongPress: () => print('edit'),
          title: Text(cubit.item.name),
          trailing: Row(
            mainAxisSize: MainAxisSize.min,
            children: [
              IconButton(
                  onPressed: () => print('fav'), icon: Icon(Icons.star_border)),
              ReorderableDragStartListener(
                index: index,
                child: const Icon(Icons.drag_handle),
              ),
            ],
          ),
        );
      },
    );
  }
}
