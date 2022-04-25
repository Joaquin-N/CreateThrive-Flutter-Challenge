import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_challenge/cubits/category/category_cubit.dart';
import 'package:flutter_challenge/cubits/filter/filter_cubit.dart';
import 'package:flutter_challenge/cubits/item/item_cubit.dart';
import 'package:flutter_challenge/models/item.dart';
import 'package:flutter_challenge/models/item_category.dart';
import 'package:flutter_challenge/widgets/Favorite_snack_bar.dart';

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
          color: category.color.withOpacity(0.6),
          width: double.infinity,
          child: Column(
            children: [
              GestureDetector(
                onTap: () => cubit.toggleShow(),
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
                      Icon(state is ShowCategory
                          ? Icons.arrow_drop_down
                          : Icons.arrow_left),
                    ],
                  ),
                ),
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
    var cubit =
        ItemCubit(itemId: itemId, filterCubit: context.read<FilterCubit>());
    return BlocConsumer<ItemCubit, ItemState>(
      bloc: cubit,
      builder: (context, state) {
        if (state is ItemNotShowing) return Container();
        return ListTile(
          onLongPress: () => print('edit'),
          title: Text(state.item.name),
          trailing: Row(
            mainAxisSize: MainAxisSize.min,
            children: [
              IconButton(
                  onPressed: () => cubit.toggleFav(),
                  icon: Icon(
                      state is ItemFavorite ? Icons.star : Icons.star_border)),
              ReorderableDragStartListener(
                index: index,
                child: const Icon(Icons.drag_handle),
              ),
            ],
          ),
        );
      },
      listenWhen: (oldState, newState) {
        return (oldState is ItemFavorite && newState is ItemNotFavorite) ||
            (oldState is ItemNotFavorite && newState is ItemFavorite);
      },
      listener: (context, state) {
        ScaffoldMessenger.of(context).showSnackBar(FavoriteSnackBar(
            text:
                'Item ${state.item.name} ${state is ItemFavorite ? "added to" : "removed from"} favorites'));
      },
    );
  }
}
