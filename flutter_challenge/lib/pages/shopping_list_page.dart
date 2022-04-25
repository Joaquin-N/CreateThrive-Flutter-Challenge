import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_challenge/cubits/app/app_cubit.dart';
import 'package:flutter_challenge/cubits/category/category_cubit.dart';
import 'package:flutter_challenge/widgets/category_items_list.dart';

class ShoppingListPage extends StatelessWidget {
  const ShoppingListPage({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      child: BlocBuilder<AppCubit, AppState>(
        builder: (context, state) {
          if (state is AppReady) {
            return Column(
              children: List.generate(
                state.categories.length,
                (index) => BlocProvider(
                  create: (context) => CategoryCubit(state.categories[index]),
                  child: CategoryItemsList(),
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
