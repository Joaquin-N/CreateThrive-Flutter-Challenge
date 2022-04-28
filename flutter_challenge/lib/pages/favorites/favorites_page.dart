import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_challenge/cubits/data/data_cubit.dart';
import 'package:flutter_challenge/pages/favorites/favorite_category_items_list.dart';
import 'package:flutter_challenge/pages/widgets/items_list.dart';

class FavoritesPage extends StatelessWidget {
  const FavoritesPage({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<DataCubit, DataState>(
      buildWhen: (previous, current) =>
          previous.runtimeType != current.runtimeType ||
          previous.categoryCubits.length != current.categoryCubits.length,
      builder: (context, state) {
        if (state is DataReady) {
          return ScrollConfiguration(
            behavior: const ScrollBehavior().copyWith(overscroll: false),
            child: ListView(
              shrinkWrap: true,
              children: List.generate(state.categoryCubits.length, (index) {
                //TODO put favorites
                return FavoriteCategoryItemsList(
                    cubit: state.categoryCubits[index]);
              }),
            ),
          );
        } else {
          return Container();
        }
      },
    );
  }
}
