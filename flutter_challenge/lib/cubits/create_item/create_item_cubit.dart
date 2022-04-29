import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:flutter_challenge/exceptions.dart';
import 'package:flutter_challenge/models/item.dart';
import 'package:flutter_challenge/repositories/data_repository.dart';
import 'package:image_picker/image_picker.dart';
import 'package:meta/meta.dart';

part 'create_item_state.dart';

class CreateItemCubit extends Cubit<CreateItemState> {
  final DataRepository repository;
  CreateItemCubit({required this.repository})
      : super(
          const CreateItemInitial(item: Item.empty(), categoriesNames: ['']),
        ) {
    repository.getCategoriesNames().listen((categories) {
      emit(CreateItemInitial(
          item: state.item, categoriesNames: ['', ...categories]));
    });
  }

  void update({String? name, String? category, String? image}) {
    Item item = state.item
        .copyWith(name: name, category: category, localImgPath: image);

    if (item.validate()) {
      emit(CreateItemReady(item: item, categoriesNames: state.categoriesNames));
    } else {
      emit(CreateItemUpdated(
          item: item, categoriesNames: state.categoriesNames));
    }
  }

  void selectImage() async {
    XFile? pickedFile = await ImagePicker().pickImage(
      source: ImageSource.gallery,
      maxWidth: 600,
      maxHeight: 600,
      imageQuality: 80,
    );
    if (pickedFile != null) {
      update(image: pickedFile.path);
    }
  }

  void clearImage() {
    update(image: null);
  }

  void save() async {
    Item item = state.item;
    try {
      repository.createItem(item);
      emit(CreateItemSaved(item: item, categoriesNames: state.categoriesNames));
      emit(CreateItemInitial(
          item: Item.empty(), categoriesNames: state.categoriesNames));
    } on DuplicatedElementException {
      emit(CreateItemReady(item: item, categoriesNames: state.categoriesNames));
    }
  }
}
