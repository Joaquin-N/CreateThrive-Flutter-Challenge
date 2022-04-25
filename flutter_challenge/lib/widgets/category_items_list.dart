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
                    onReorder: (oldIndex, newIndex) => context
                        .read<CategoryCubit>()
                        .reorder(oldIndex, newIndex),
                    children: List.generate(category.items.length, (index) {
                      Item item = category.items[index];
                      return BlocProvider(
                        key: ValueKey(index.toString()),
                        create: (context) => ItemCubit(item),
                        child: ItemListTile(
                          index: index,
                        ),
                      );
                    })),
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
  }) : super(key: key);

  final int index;

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<ItemCubit, ItemState>(
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
