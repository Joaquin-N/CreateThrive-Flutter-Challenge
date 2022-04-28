import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_challenge/cubits/category/category_cubit.dart';
import 'package:flutter_challenge/cubits/filter/filter_cubit.dart';
import 'package:flutter_challenge/cubits/item/item_cubit.dart';
import 'package:flutter_challenge/models/item.dart';
import 'package:flutter_challenge/models/item_category.dart';
import 'package:flutter_challenge/pages/widgets/custom_snack_bar.dart';
import 'package:intl/intl.dart';

class FavoriteCategoryItemsList extends StatefulWidget {
  FavoriteCategoryItemsList({
    Key? key,
    required ItemCategory category,
  })  : cubit = CategoryCubit(category: category),
        super(key: key);
  final CategoryCubit cubit;

  @override
  State<FavoriteCategoryItemsList> createState() =>
      _FavoriteCategoryItemsListState();
}

class _FavoriteCategoryItemsListState extends State<FavoriteCategoryItemsList> {
  @override
  void dispose() {
    widget.cubit.close();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<CategoryCubit, CategoryState>(
      bloc: widget.cubit,
      builder: (context, state) {
        ItemCategory category = state.category;
        if (state is LoadingCategory) return Container();
        return Visibility(
          visible: state.favoriteItems.isNotEmpty,
          child: Container(
            color: Color(category.color).withOpacity(0.6),
            width: double.infinity,
            child: Column(
              children: [
                Container(
                  alignment: Alignment.center,
                  height: 50,
                  child: Text(
                    category.name,
                    style: TextStyle(fontSize: 16),
                  ),
                ),
                ListView(
                  physics: const NeverScrollableScrollPhysics(),
                  shrinkWrap: true,
                  children: List.generate(
                    state.favoriteItems.length,
                    (index) {
                      return ItemListTile(
                        item: state.items[index],
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
  }
}

class ItemListTile extends StatefulWidget {
  ItemListTile({
    Key? key,
    required Item item,
  })  : cubit = ItemCubit(item: item),
        super(key: key);

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
        if (state is ItemNotShowing || state is ItemNotFavorite)
          return Container();
        //TODO do not rebuild on dismiss
        return Dismissible(
          key: Key('x$widget.key'),
          background: Container(color: Colors.yellow[200]),
          direction: DismissDirection.endToStart,
          confirmDismiss: (direction) {
            if (direction == DismissDirection.endToStart) {
              widget.cubit.toggleFav();
            }
            return Future.value(true);
          },
          child: ListTile(
            title: Text(state.item.name),
            subtitle: Text('Added on ' +
                DateFormat('dd/MM/yyyy').format(state.item.favAddDate!)),
            trailing: IconButton(
              onPressed: () => widget.cubit.toggleFav(),
              icon:
                  Icon(state is ItemFavorite ? Icons.star : Icons.star_border),
            ),
          ),
        );
      },
      listenWhen: (oldState, newState) {
        return (oldState is ItemFavorite && newState is ItemNotFavorite);
      },
      listener: (context, state) {
        ScaffoldMessenger.of(context).showSnackBar(CustomSnackBar(
            text:
                'Item ${state.item.name} ${state is ItemFavorite ? "added to" : "removed from"} favorites'));
      },
    );
  }
}
