import 'package:bloc/bloc.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_challenge/models/item.dart';
import 'package:flutter_challenge/models/item_category.dart';
import 'package:image_picker/image_picker.dart';
import 'package:meta/meta.dart';

part 'create_state.dart';

class CreateCubit extends Cubit<CreateState> {
  CreateCubit()
      : super(CreateItem(
            item: Item(),
            category: ItemCategory(),
            categoriesNames: categories));
  static List<String> categories = ['', 'cat1', 'cat2', 'cat3'];

  void switchCreate(bool category) {
    category ? updateCategory() : updateItem();
  }

  void updateItem({String? category, String? image}) {
    if (category != null) state.item.category = category;
    if (image != null) state.item.imgUrl = image;
    emit(CreateItem(
        item: state.item,
        category: state.category,
        categoriesNames: categories));
  }

  void updateCategory({String? name, int? color}) {
    if (name != null) state.category.name = name;
    if (color != null) state.category.color = color;
    emit(CreateCategory(
        item: state.item,
        category: state.category,
        categoriesNames: categories));
  }

  void selectImage() async {
    XFile? pickedFile = await ImagePicker().pickImage(
      source: ImageSource.gallery,
      maxWidth: 600,
      maxHeight: 600,
      imageQuality: 80,
    );
    if (pickedFile != null) {
      updateItem(image: pickedFile.path);
    }
  }

  void clearImage() {
    state.item.imgUrl = null;
    updateItem();
  }

  void createItem() {}

  void createCategory() {}
}
