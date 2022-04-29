import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:equatable/equatable.dart';

class Item extends Equatable {
  final String id;
  final String name;
  final DateTime? favAddDate;
  final String imgUrl;

  final String? category;
  final String? localImgPath;

  const Item(
      {this.id = '',
      required this.name,
      required this.favAddDate,
      required this.imgUrl,
      this.category,
      this.localImgPath});

  const Item.empty()
      : id = '',
        name = '',
        imgUrl = '',
        favAddDate = null,
        category = null,
        localImgPath = null;

  bool validate() =>
      name != '' &&
      category != null &&
      category!.isNotEmpty &&
      localImgPath != null;

  bool isFavorite() => favAddDate != null;

  Map<String, dynamic> toDocument() =>
      {'name': name, 'fav_add_date': favAddDate, 'img_url': imgUrl};

  Item.fromSnapshot(DocumentSnapshot snap)
      : id = snap.id,
        name = snap['name'],
        favAddDate = snap['fav_add_date']?.toDate(),
        imgUrl = snap['img_url'],
        category = null,
        localImgPath = null;

  Item clearFavAddDate() {
    return Item(
        id: id,
        name: name,
        favAddDate: null,
        imgUrl: imgUrl,
        category: category,
        localImgPath: localImgPath);
  }

  Item copyWith(
      {String? id,
      String? name,
      DateTime? favAddDate,
      String? imgUrl,
      String? category,
      String? localImgPath}) {
    return Item(
        id: id ?? this.id,
        name: name ?? this.name,
        favAddDate: favAddDate ?? this.favAddDate,
        imgUrl: imgUrl ?? this.imgUrl,
        category: category ?? this.category,
        localImgPath: localImgPath ?? this.localImgPath);
  }

  @override
  List<Object?> get props =>
      [id, name, favAddDate, imgUrl, category, localImgPath];
}
