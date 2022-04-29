import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_challenge/constants.dart';
import 'package:flutter_challenge/cubits/create_category/create_category_cubit.dart';
import 'package:flutter_challenge/pages/widgets/custom_snack_bar.dart';
import 'package:flutter_challenge/pages/widgets/custom_text_field.dart';
import 'package:flutter_colorpicker/flutter_colorpicker.dart';

class CreateCategoryPage extends StatelessWidget {
  final TextEditingController tec;
  const CreateCategoryPage({Key? key, required this.tec}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return BlocConsumer<CreateCategoryCubit, CreateCategoryState>(
      builder: (context, state) {
        final cubit = context.read<CreateCategoryCubit>();

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
                CustomTextField(
                  controller: tec,
                  onChanged: (value) => cubit.update(name: value),
                ),
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
                    onColorChanged: (color) => cubit.update(color: color.value),
                  ),
                ),
              ],
            ),
            const SizedBox(height: 20),
            ElevatedButton(
                style: ElevatedButton.styleFrom(primary: categoryColor),
                onPressed: state is CreateCategoryReady ? cubit.save : null,
                child: const Text('Create Category'))
          ],
        );
      },
      listenWhen: (oldState, newState) => newState is CreateCategorySaved,
      listener: (context, state) {
        tec.clear();
        ScaffoldMessenger.of(context).showSnackBar(
            CustomSnackBar(text: 'Category ${state.category.name} created'));
      },
    );
  }
}
