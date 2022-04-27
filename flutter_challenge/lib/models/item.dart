import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter_challenge/models/item_category.dart';

class Item {
  String id;
  String name;
  DateTime? favAddDate;
  String imgUrl;

  String? category;
  String? localImgPath;

  Item(
      {required this.id,
      required this.name,
      required this.favAddDate,
      required this.imgUrl});

  Item.empty()
      : id = '',
        name = '',
        imgUrl = '';
  bool validate() => name != '' && category != null && localImgPath != null;

  // Item copyWith({String? name, String? imgUrl}) {
  //   return Item(
  //       id: id,
  //       name: name ?? this.name,
  //       favAddDate: favAddDate,
  //       imgUrl: imgUrl ?? this.imgUrl);
  // }

  Map<String, dynamic> toDocument() =>
      {'name': name, 'fav_add_date': favAddDate, 'img_url': imgUrl};

  Item.fromSnapshot(DocumentSnapshot snap)
      : id = snap.id,
        name = snap['name'],
        favAddDate = snap['fav_add_date']?.toDate(),
        imgUrl = snap['img_url'];
}
