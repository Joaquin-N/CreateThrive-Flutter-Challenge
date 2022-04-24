import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_challenge/cubits/app/app_cubit.dart';
import 'package:flutter_challenge/cubits/show_category/show_category_cubit.dart';
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
    return Container(
      color: category.color,
      width: double.infinity,
      child: BlocProvider<ShowCategoryCubit>(
        create: (context) => ShowCategoryCubit(),
        child: BlocBuilder<ShowCategoryCubit, ShowCategoryState>(
          builder: (context, state) {
            return Column(
              children: [
                GestureDetector(
                  onTap: () => context.read<ShowCategoryCubit>().toggleShow(),
                  child: Text(category.name),
                ),
                if (state is ShowCategory)
                  ReorderableListView(
                      physics: const NeverScrollableScrollPhysics(),
                      shrinkWrap: true,
                      onReorder: (oldIndex, newIndex) => context
                          .read<AppCubit>()
                          .reorder(category, oldIndex, newIndex),
                      children: List.generate(category.items.length, (index) {
                        Item item = category.items[index];
                        return ListTile(
                          onLongPress: () => print('edit'),
                          key: Key(index.toString()),
                          title: Text(item.name),
                          trailing: Row(
                            mainAxisSize: MainAxisSize.min,
                            children: [
                              IconButton(
                                  onPressed: () => print('fav'),
                                  icon: Icon(Icons.star_border)),
                              ReorderableDragStartListener(
                                index: index,
                                child: const Icon(Icons.drag_handle),
                              ),
                            ],
                          ),
                        );
                      })),
              ],
            );
          },
        ),
      ),
    );
  }
}
