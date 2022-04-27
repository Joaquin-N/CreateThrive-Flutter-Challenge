import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_challenge/constants.dart';
import 'package:flutter_challenge/cubits/create_item/create_item_cubit.dart';
import 'package:flutter_challenge/pages/widgets/custom_snack_bar.dart';
import 'package:flutter_challenge/pages/widgets/custom_text_field.dart';

class CreateItemPage extends StatelessWidget {
  final TextEditingController tec;
  const CreateItemPage({Key? key, required this.tec}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return BlocConsumer<CreateItemCubit, CreateItemState>(
      builder: (context, state) {
        final cubit = context.read<CreateItemCubit>();

        return Column(
          mainAxisSize: MainAxisSize.max,
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Column(
              children: [
                Text('Name', style: defaultTextStyle),
                CustomTextField(
                  controller: tec,
                  onChanged: (value) => cubit.update(name: value),
                ),
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
                  onChanged: (category) => cubit.update(category: category),
                ),
              ],
            ),
            const SizedBox(height: 20),
            Column(
              children: [
                Text('Image', style: defaultTextStyle),
                SizedBox(height: 20),
                if (state.item.localImgPath != null)
                  Container(
                    height: 200,
                    color: Colors.grey.shade400,
                    child: Image.file(
                      File(state.item.localImgPath!),
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
              onPressed: state is CreateItemReady ? cubit.save : null,
              child: Text('Create Item'),
            ),
          ],
        );
      },
      listenWhen: (oldState, newState) => newState is CreateItemSaved,
      listener: (context, state) {
        tec.clear();
        ScaffoldMessenger.of(context).showSnackBar(
            CustomSnackBar(text: 'Item ${state.item.name} created'));
      },
    );
  }
}
