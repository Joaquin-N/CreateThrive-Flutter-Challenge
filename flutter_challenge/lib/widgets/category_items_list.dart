import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_challenge/cubits/category/category_cubit.dart';
import 'package:flutter_challenge/cubits/item/item_cubit.dart';
import 'package:flutter_challenge/models/item.dart';
import 'package:flutter_challenge/models/item_category.dart';

class CategoryItemsList extends StatelessWidget {
  const CategoryItemsList({Key? key, required this.categoryId})
      : super(key: key);
  final String categoryId;

  @override
  Widget build(BuildContext context) {
    var cubit = CategoryCubit(categoryId);
    return BlocBuilder<CategoryCubit, CategoryState>(
      bloc: cubit,
      builder: (context, state) {
        ItemCategory category = state.category;
        return Container(
          color: category.color,
          width: double.infinity,
          child: Column(
            children: [
              GestureDetector(
                onTap: () => cubit.toggleShow(),
                child: Text(category.name),
              ),
              if (state is ShowCategory)
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
                        itemId: category.itemsId[index],
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
    required this.itemId,
  }) : super(key: key);

  final int index;
  final String itemId;

  @override
  Widget build(BuildContext context) {
    var cubit = ItemCubit(itemId);
    return BlocBuilder<ItemCubit, ItemState>(
      bloc: cubit,
      builder: (context, state) {
        return ListTile(
          onLongPress: () => print('edit'),
          title: Text(state.item.name),
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
