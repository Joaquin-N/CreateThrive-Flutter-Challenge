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
import 'package:flutter_challenge/repositories/data_repository.dart';
import 'package:intl/intl.dart';

class FavoriteCategoryItemsList extends StatelessWidget {
  const FavoriteCategoryItemsList({
    Key? key,
    required this.cubit,
  }) : super(key: key);
  final CategoryCubit cubit;

  @override
  Widget build(BuildContext context) {
    return BlocListener<CategoryCubit, CategoryState>(
      bloc: cubit,
      listenWhen: (oldState, newState) {
        return (oldState.lastFavoriteRemoved != newState.lastFavoriteRemoved);
      },
      listener: (context, state) {
        ScaffoldMessenger.of(context).showSnackBar(CustomSnackBar(
            text:
                'Item ${state.lastFavoriteRemoved!.name} removed from favorites'));
      },
      child: BlocBuilder<CategoryCubit, CategoryState>(
        bloc: cubit,
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
                    decoration: categoryBoxDecoration,
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
                          index: index,
                          item: state.favoriteItems[index],
                          onToggleFav: () =>
                              cubit.toggleFav(state.favoriteItems[index]),
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
  }
}

class ItemListTile extends StatelessWidget {
  const ItemListTile({
    Key? key,
    required this.index,
    required this.item,
    required this.onToggleFav,
  }) : super(key: key);

  final int index;
  final Item item;
  final Function() onToggleFav;

  @override
  Widget build(BuildContext context) {
    return Dismissible(
      key: Key('x$key'),
      background: Container(color: Colors.yellow[200]),
      direction: DismissDirection.endToStart,
      confirmDismiss: (direction) {
        if (direction == DismissDirection.endToStart) {
          onToggleFav();
        }
        return Future.value(false);
      },
      child: ListTile(
        shape: const UnderlineInputBorder(
            borderSide: BorderSide(color: Colors.grey, width: 1)),
        title: Text(item.name),
        subtitle: Text(
            'Added on ' + DateFormat('dd/MM/yyyy').format(item.favAddDate!)),
        trailing: IconButton(
          onPressed: () => onToggleFav(),
          icon: Icon(item.isFavorite() ? Icons.star : Icons.star_border),
        ),
      ),
    );
  }
}
