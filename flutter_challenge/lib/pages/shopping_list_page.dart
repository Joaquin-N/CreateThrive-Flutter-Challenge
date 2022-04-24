import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_challenge/cubits/app/app_cubit.dart';
import 'package:flutter_challenge/models/item.dart';
import 'package:flutter_challenge/models/item_category.dart';

class ShoppingListPage extends StatelessWidget {
  const ShoppingListPage({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Shopping List'),
      ),
      body: SingleChildScrollView(
        child: BlocBuilder<AppCubit, AppState>(
          builder: (context, state) {
            if (state is AppReady) {
              return Column(
                  children: List.generate(
                      state.categories.length,
                      (index) => CategoryList(
                            category: state.categories[index],
                          )));
            } else {
              return Container();
            }
          },
        ),
      ),
    );
  }
}

class CategoryList extends StatelessWidget {
  const CategoryList({Key? key, required this.category}) : super(key: key);

  final ItemCategory category;

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Text(category.name),
        ReorderableListView(
            physics: const NeverScrollableScrollPhysics(),
            shrinkWrap: true,
            onReorder: (oldIndex, newIndex) =>
                context.read<AppCubit>().reorder(category, oldIndex, newIndex),
            children: List.generate(category.items.length, (index) {
              Item item = category.items[index];
              return ListTile(
                key: Key(item.id.toString()),
                title: Text(item.name),
              );
            })),
      ],
    );
  }
}
