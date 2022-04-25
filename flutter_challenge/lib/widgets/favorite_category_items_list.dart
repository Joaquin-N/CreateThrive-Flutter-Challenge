import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_challenge/cubits/category/category_cubit.dart';
import 'package:flutter_challenge/cubits/filter/filter_cubit.dart';
import 'package:flutter_challenge/cubits/item/item_cubit.dart';
import 'package:flutter_challenge/models/item.dart';
import 'package:flutter_challenge/models/item_category.dart';
import 'package:flutter_challenge/widgets/Favorite_snack_bar.dart';
import 'package:intl/intl.dart';

class FavoriteCategoryItemsList extends StatelessWidget {
  const FavoriteCategoryItemsList({
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
        if (state is CategoryHide) return Container();
        return Container(
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
                  category.itemsId.length,
                  (index) {
                    return ItemListTile(
                      cubit: state.itemCubits[index],
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
    required this.cubit,
  }) : super(key: key);

  final ItemCubit cubit;

  @override
  Widget build(BuildContext context) {
    return BlocConsumer<ItemCubit, ItemState>(
      bloc: cubit,
      builder: (context, state) {
        if (state is ItemNotShowing) return Container();
        return ListTile(
          title: Text(state.item.name),
          subtitle: Text('Added on ' +
              DateFormat('dd/MM/yyyy').format(state.item.favAddDate!)),
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
