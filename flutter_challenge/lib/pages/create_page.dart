import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_challenge/constants.dart';
import 'package:flutter_challenge/cubits/create/create_cubit.dart';
import 'package:flutter_challenge/widgets/filter_button.dart';
import 'package:flutter_colorpicker/flutter_colorpicker.dart';

class CreatePage extends StatelessWidget {
  const CreatePage({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<CreateCubit, CreateState>(
      builder: (context, state) {
        bool switchValue = state is CreateCategory;
        return Column(
          mainAxisSize: MainAxisSize.max,
          children: [
            Padding(
              padding: const EdgeInsets.all(10.0),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceAround,
                children: [
                  FilterButton(
                    text: 'Item',
                    color: switchValue ? itemColorDisabled : itemColor,
                  ),
                  Switch(
                    value: switchValue,
                    onChanged: context.read<CreateCubit>().switchCreate,
                  ),
                  FilterButton(
                    text: 'Category',
                    color: switchValue ? categoryColor : categoryColorDisabled,
                  ),
                ],
              ),
            ),
            Expanded(
              child: CustomScrollView(
                slivers: [
                  SliverFillRemaining(
                    hasScrollBody: false,
                    child: Padding(
                      padding: EdgeInsets.only(bottom: 10.0, top: 20.0),
                      child:
                          switchValue ? CreateCategoryPage() : CreateItemPage(),
                    ),
                  )
                ],
              ),
            ),
          ],
        );
      },
    );
  }
}

class CreateCategoryPage extends StatelessWidget {
  const CreateCategoryPage({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<CreateCubit, CreateState>(
      builder: (context, state) {
        return Column(
          mainAxisSize: MainAxisSize.max,
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Column(
              children: [
                Text(
                  'Name',
                  style: defaultTextStyle,
                ),
                CustomTextField(),
              ],
            ),
            const SizedBox(height: 20),
            Column(
              children: [
                Text('Color', style: defaultTextStyle),
                const SizedBox(height: 20),
                SizedBox(
                  width: 250,
                  height: 320,
                  //TODO fix scrolling
                  child: BlockPicker(
                    pickerColor: Color(state.category.color),
                    onColorChanged: (color) => context
                        .read<CreateCubit>()
                        .updateCategory(color: color.value),
                  ),
                ),
              ],
            ),
            const SizedBox(height: 20),
            ElevatedButton(
                style: ElevatedButton.styleFrom(primary: categoryColor),
                onPressed: context.read<CreateCubit>().createCategory,
                child: Text('Create Category'))
          ],
        );
      },
    );
  }
}

class CreateItemPage extends StatelessWidget {
  const CreateItemPage({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<CreateCubit, CreateState>(
      builder: (context, state) {
        var cubit = context.read<CreateCubit>();
        return Column(
          mainAxisSize: MainAxisSize.max,
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Column(
              children: [
                Text('Name', style: defaultTextStyle),
                CustomTextField(),
              ],
            ),
            const SizedBox(height: 20),
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Text('Category', style: defaultTextStyle),
                SizedBox(width: 30),
                DropdownButton<String>(
                  items: List.generate(
                    state.categoriesNames.length,
                    (index) => DropdownMenuItem(
                      child: Text(state.categoriesNames[index] == ''
                          ? '<Select>'
                          : state.categoriesNames[index]),
                      value: state.categoriesNames[index],
                    ),
                  ),
                  value: state.item.category ?? '',
                  onChanged: (category) => cubit.updateItem(category: category),
                ),
              ],
            ),
            const SizedBox(height: 20),
            Column(
              children: [
                Text('Image', style: defaultTextStyle),
                SizedBox(height: 20),
                if (state.item.imgUrl != null)
                  Container(
                    height: 200,
                    color: Colors.grey.shade400,
                    child: Image.file(
                      File(state.item.imgUrl!),
                      fit: BoxFit.contain,
                    ),
                  )
                else
                  Container(
                    alignment: Alignment.center,
                    height: 200,
                    width: 250,
                    color: Colors.grey.shade400,
                    child: Text('Select image'),
                  ),
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 20.0),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                    children: [
                      TextButton(
                        onPressed: cubit.clearImage,
                        child: Text('Clear'),
                        style: TextButton.styleFrom(primary: Colors.red),
                      ),
                      TextButton(
                        onPressed: cubit.selectImage,
                        child: Text('Select'),
                      ),
                    ],
                  ),
                ),
              ],
            ),
            const SizedBox(height: 20),
            ElevatedButton(
              style: ElevatedButton.styleFrom(primary: itemColor),
              onPressed: cubit.createCategory,
              child: Text('Create Item'),
            ),
          ],
        );
      },
    );
  }
}

class CustomTextField extends StatelessWidget {
  const CustomTextField({
    Key? key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      width: 200,
      padding: const EdgeInsets.symmetric(vertical: 10),
      child: const TextField(
        textAlign: TextAlign.center,
        decoration: InputDecoration(
          isDense: true,
        ),
      ),
    );
  }
}
