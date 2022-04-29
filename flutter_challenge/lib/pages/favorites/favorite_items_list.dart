import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_challenge/constants.dart';
import 'package:flutter_challenge/cubits/category/category_cubit.dart';
import 'package:flutter_challenge/cubits/data/data_cubit.dart';
import 'package:flutter_challenge/cubits/filter/filter_cubit.dart';
import 'package:flutter_challenge/cubits/item/item_cubit.dart';
import 'package:flutter_challenge/models/item.dart';
import 'package:flutter_challenge/models/item_category.dart';
import 'package:flutter_challenge/pages/widgets/items_list.dart';
import 'package:flutter_challenge/pages/widgets/custom_snack_bar.dart';
import 'package:flutter_challenge/repositories/data_repository.dart';
import 'package:intl/intl.dart';

class FavoriteItemsList extends StatelessWidget {
  const FavoriteItemsList({
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
          if (state is LoadingCategory) return Container();
          return Visibility(
              visible: state.favoriteItems.isNotEmpty,
              child: ItemsList(
                name: state.category.name,
                items: state.favoriteItems,
                color: Color(state.category.color),
                onToggleFav: cubit.toggleFav,
                favorite: true,
              ));
        },
      ),
    );
  }
}
