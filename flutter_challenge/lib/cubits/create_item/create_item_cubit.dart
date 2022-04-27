import 'package:bloc/bloc.dart';
import 'package:flutter_challenge/models/item.dart';
import 'package:flutter_challenge/services/firestore.dart';
import 'package:image_picker/image_picker.dart';
import 'package:meta/meta.dart';

part 'create_item_state.dart';

class CreateItemCubit extends Cubit<CreateItemState> {
  Firestore fs = Firestore.instance;
  CreateItemCubit()
      : super(
            CreateItemInitial(item: Item.empty(), categoriesNames: categories));

  static List<String> categories = ['', 'cat1', 'cat2', 'cat3'];

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
    if (await fs.checkItemDuplicated(item)) {
      emit(state.toErrorDuplicated());
      return;
    }
    fs.saveItem(item);
    emit(CreateItemInitial(item: Item.empty(), categoriesNames: categories));
  }
}
