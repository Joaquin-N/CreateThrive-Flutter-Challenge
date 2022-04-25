import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter_challenge/models/item_category.dart';

class Item {
  String? id;
  String name;
  DateTime? favAddDate;
  String? imgUrl;

  Item({required this.name});

  Map<String, dynamic> toDocument() =>
      {'name': name, 'fav_add_date': favAddDate, 'img_url': imgUrl};

  Item.fromSnapshot(DocumentSnapshot snap)
      : id = snap.id,
        name = snap['name'],
        favAddDate = snap['fav_add_date']?.toDate(),
        imgUrl = snap['img_url'];
}
