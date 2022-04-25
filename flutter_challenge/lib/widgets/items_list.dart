import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_challenge/cubits/data/data_cubit.dart';
import 'package:flutter_challenge/widgets/category_items_list.dart';
import 'package:flutter_challenge/widgets/favorite_category_items_list.dart';

class ItemsList extends StatelessWidget {
  const ItemsList({
    Key? key,
    this.favorites = false,
  }) : super(key: key);

  final bool favorites;

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      child: BlocBuilder<DataCubit, DataState>(
        builder: (context, state) {
          if (state is DataReady) {
            return Column(
              children: List.generate(
                state.categoryCubits.length,
                (index) => favorites
                    ? FavoriteCategoryItemsList(
                        cubit: state.categoryCubits[index],
                      )
                    : CategoryItemsList(
                        cubit: state.categoryCubits[index],
                      ),
              ),
            );
          } else {
            return Container();
          }
        },
      ),
    );
  }
}
