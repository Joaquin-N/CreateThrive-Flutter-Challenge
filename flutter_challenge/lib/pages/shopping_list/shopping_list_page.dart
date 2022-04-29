import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_challenge/constants.dart';
import 'package:flutter_challenge/cubits/data/data_cubit.dart';
import 'package:flutter_challenge/cubits/category/category_cubit.dart';
import 'package:flutter_challenge/cubits/filter/filter_cubit.dart';
import 'package:flutter_challenge/pages/shopping_list/all_items_list.dart';
import 'package:flutter_challenge/pages/widgets/filter_button.dart';
import 'package:flutter_challenge/repositories/data_repository.dart';

class ShoppingListPage extends StatefulWidget {
  const ShoppingListPage({Key? key}) : super(key: key);
  @override
  State<ShoppingListPage> createState() => _ShoppingListPageState();
}

class _ShoppingListPageState extends State<ShoppingListPage> {
  final TextEditingController controller = TextEditingController();

  @override
  void dispose() {
    controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        BlocConsumer<FilterCubit, FilterState>(
            builder: (context, state) {
              var cubit = context.read<FilterCubit>();
              return FilteringBar(
                buttonText: state.categories ? 'Categories' : 'Items',
                controller: controller,
                color: state.categories ? categoryColor : itemColor,
                onFilterChange: cubit.toggleFilter,
                onTextChange: cubit.search,
                onClear: cubit.cancelFilter,
              );
            },
            listenWhen: (previous, current) =>
                previous.categoryFilter != current.categoryFilter,
            listener: (context, filterState) {
              context.read<DataCubit>().applyFilter(filterState.categoryFilter);
            }),
        Expanded(
          child: BlocBuilder<DataCubit, DataState>(
            buildWhen: (previous, current) =>
                //previous.runtimeType != current.runtimeType ||
                previous.categories.length != current.categories.length,
            builder: (context, state) {
              if (!state.loading) {
                return ScrollConfiguration(
                  behavior: const ScrollBehavior().copyWith(overscroll: false),
                  child: ListView(
                    shrinkWrap: true,
                    children: List.generate(state.categories.length, (index) {
                      return AllItemsList(
                          cubit: CategoryCubit(
                              category: state.categories[index],
                              repository: RepositoryProvider.of<DataRepository>(
                                  context)));
                    }),
                  ),
                );
              } else {
                return const Center(child: CircularProgressIndicator());
              }
            },
          ),
        ),
      ],
    );
  }
}

class FilteringBar extends StatelessWidget {
  const FilteringBar({
    Key? key,
    required this.buttonText,
    required this.color,
    required this.onFilterChange,
    required this.onTextChange,
    required this.onClear,
    required this.controller,
  }) : super(key: key);

  final String buttonText;
  final Color color;
  final Function() onFilterChange;
  final Function(String) onTextChange;
  final Function() onClear;
  final TextEditingController controller;

  @override
  Widget build(BuildContext context) {
    return Container(
      color: Colors.grey.withAlpha(80),
      padding: const EdgeInsets.only(left: 10.0, right: 5.0, top: 8, bottom: 5),
      child: Row(
        children: [
          FilterButton(
            text: buttonText,
            color: color,
            onPressed: onFilterChange,
          ),
          const SizedBox(width: 20),
          Expanded(
            child: TextField(
              controller: controller,
              onChanged: onTextChange,
              decoration: InputDecoration(
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(10.0),
                ),
                filled: true,
                fillColor: Colors.white.withOpacity(0.9),
                isDense: true,
                hintText: 'Search',
                suffixIcon: IconButton(
                  onPressed: () {
                    final FocusScopeNode currentScope = FocusScope.of(context);
                    if (!currentScope.hasPrimaryFocus &&
                        currentScope.hasFocus) {
                      FocusManager.instance.primaryFocus!.unfocus();
                    }
                    controller.clear();
                    onClear();
                  },
                  icon: Icon(Icons.clear),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
