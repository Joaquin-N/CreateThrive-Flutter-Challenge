import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_challenge/cubits/data/data_cubit.dart';
import 'package:flutter_challenge/cubits/category/category_cubit.dart';
import 'package:flutter_challenge/cubits/filter/filter_cubit.dart';
import 'package:flutter_challenge/widgets/category_items_list.dart';
import 'package:flutter_challenge/widgets/filter_button.dart';
import 'package:flutter_challenge/widgets/items_list.dart';

class ShoppingListPage extends StatelessWidget {
  const ShoppingListPage({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        BlocBuilder<FilterCubit, FilterState>(
          builder: (context, state) {
            return FilteringBar(
              text: state.categories ? 'Categories' : 'Items',
              color: state.categories ? Colors.red : Colors.blue,
              onFilterChange: () => context.read<FilterCubit>().toggleFilter(),
              onClear: () => context.read<FilterCubit>().cancelFilter(),
              controller: state.controller,
            );
          },
        ),
        ItemsList(),
      ],
    );
  }
}

class FilteringBar extends StatelessWidget {
  const FilteringBar({
    Key? key,
    required this.text,
    required this.color,
    required this.onFilterChange,
    required this.onClear,
    required this.controller,
  }) : super(key: key);

  final String text;
  final Color color;
  final Function() onFilterChange;
  final Function() onClear;
  final TextEditingController controller;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(left: 10.0, right: 2.0),
      child: Row(
        children: [
          FilterButton(
            text: text,
            color: color,
            onPressed: onFilterChange,
          ),
          const SizedBox(width: 20),
          Expanded(
            child: TextField(
              controller: controller,
              decoration: InputDecoration(
                hintText: 'Search',
              ),
            ),
          ),
          IconButton(
            onPressed: onClear,
            icon: Icon(Icons.cancel_rounded, color: Colors.grey),
          ),
        ],
      ),
    );
  }
}
