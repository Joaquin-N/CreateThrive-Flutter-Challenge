import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_challenge/constants.dart';
import 'package:flutter_challenge/cubits/application/application_cubit.dart';
import 'package:flutter_challenge/pages/create/create_category.dart';
import 'package:flutter_challenge/pages/create/create_item.dart';
import 'package:flutter_challenge/pages/widgets/filter_button.dart';

class CreatePage extends StatefulWidget {
  const CreatePage({Key? key}) : super(key: key);

  @override
  State<CreatePage> createState() => _CreatePageState();
}

class _CreatePageState extends State<CreatePage> {
  final TextEditingController itemTec = TextEditingController();
  final TextEditingController categoryTec = TextEditingController();

  @override
  void dispose() {
    itemTec.dispose();
    categoryTec.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<ApplicationCubit, ApplicationState>(
      builder: (context, state) {
        bool switchValue = state is ApplicationCreateCategory;
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
                    onChanged: context.read<ApplicationCubit>().switchCreate,
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
                      child: switchValue
                          ? CreateCategoryPage(tec: itemTec)
                          : CreateItemPage(tec: categoryTec),
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
