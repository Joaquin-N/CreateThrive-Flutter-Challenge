import 'package:bloc/bloc.dart';
import 'package:flutter_challenge/exceptions.dart';
import 'package:flutter_challenge/models/item.dart';
import 'package:flutter_challenge/repositories/data_repository.dart';
import 'package:flutter_challenge/services/firestore.dart';
import 'package:image_picker/image_picker.dart';
import 'package:meta/meta.dart';

part 'create_item_state.dart';

class CreateItemCubit extends Cubit<CreateItemState> {
  final DataRepository repository;
  CreateItemCubit({required this.repository})
      : super(
          CreateItemInitial(item: Item.empty(), categoriesNames: ['']),
        ) {
    repository.getCategoriesNames().listen((categories) {
      emit(CreateItemInitial(
          item: state.item, categoriesNames: ['', ...categories]));
    });
  }

  void update({String? name, String? category, String? image}) {
    if (name != null) state.item.name = name;
    if (category != null) {
      state.item.category = category;
      if (category.isEmpty) {
        state.item.category = null;
      }
    }
    if (image != null) state.item.localImgPath = image;
    if (state.item.validate()) {
      emit(state.toReady());
    } else {
      emit(state.toUpdated());
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
    state.item.localImgPath = null;
    update();
  }

  void save() async {
    Item item = state.item;
    try {
      repository.createItem(item);
      emit(state.toSaved());
      emit(CreateItemInitial(
          item: Item.empty(), categoriesNames: state.categoriesNames));
    } on DuplicatedElementException {
      emit(state.toErrorDuplicated());
    }
  }
}
