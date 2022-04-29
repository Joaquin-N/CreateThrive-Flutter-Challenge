import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter_challenge/models/item.dart';
import 'package:flutter_challenge/pages/widgets/delete_dialog.dart';
import 'package:intl/intl.dart';

class ItemsList extends StatelessWidget {
  const ItemsList(
      {Key? key,
      required this.name,
      required this.items,
      required this.color,
      this.favorite = false,
      this.show,
      this.onToggleShow,
      this.onReorder,
      required this.onToggleFav,
      this.onDelete})
      : super(key: key);

  final String name;
  final List<Item> items;
  final Color color;
  final bool favorite;
  final bool? show;
  final void Function()? onToggleShow;
  final void Function(int, int)? onReorder;
  final void Function(Item) onToggleFav;
  final void Function(Item)? onDelete;

  @override
  Widget build(BuildContext context) {
    return Container(
      color: color.withOpacity(0.4),
      width: double.infinity,
      child: Column(
        children: [
          GestureDetector(
            onTap: onToggleShow,
            child: Container(
              decoration: BoxDecoration(
                color: color.withOpacity(0.6),
                border: const Border.symmetric(
                    horizontal: BorderSide(width: 1, color: Colors.black45)),
              ),
              padding: const EdgeInsets.symmetric(horizontal: 18),
              height: 50,
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  const SizedBox(width: 32.0),
                  Text(
                    name,
                    style: const TextStyle(fontSize: 16),
                  ),
                  if (show != null)
                    Icon(show! ? Icons.arrow_drop_down : Icons.arrow_left)
                  else
                    const SizedBox(width: 32.0),
                ],
              ),
            ),
          ),
          Visibility(
            visible: show == null || show!,
            child: ReorderableListView(
              physics: const NeverScrollableScrollPhysics(),
              shrinkWrap: true,
              onReorder: onReorder ?? (_, __) {},
              children: List.generate(
                items.length,
                (index) {
                  return ItemListTile(
                    index: index,
                    item: items[index],
                    favorite: favorite,
                    reorderEnabled: onReorder != null,
                    onToggleFav: onToggleFav,
                    onDelete: onDelete,
                    key: Key('$index'),
                  );
                },
              ),
            ),
          ),
        ],
      ),
    );
  }
}

class ItemListTile extends StatelessWidget {
  const ItemListTile({
    Key? key,
    required this.index,
    required this.item,
    required this.reorderEnabled,
    required this.favorite,
    required this.onToggleFav,
    required this.onDelete,
  }) : super(key: key);

  final int index;
  final Item item;
  final bool reorderEnabled;
  final bool favorite;
  final void Function(Item) onToggleFav;
  final void Function(Item)? onDelete;

  @override
  Widget build(BuildContext context) {
    return Dismissible(
      key: Key('x$key'),
      background: Container(color: Colors.yellow[200]),
      secondaryBackground: favorite ? null : Container(color: Colors.red[400]),
      confirmDismiss: favorite
          ? (direction) {
              if (direction == DismissDirection.endToStart) {
                onToggleFav(item);
              }
              return Future.value(false);
            }
          : (direction) async {
              if (direction == DismissDirection.startToEnd) {
                onToggleFav(item);
              } else {
                bool? answer = await showDialog(
                    context: context,
                    builder: (context) => DeleteDialog(
                          itemName: item.name,
                        ));
                if (answer != null && answer) {
                  onDelete!(item);
                }
              }
              return Future.value(false);
            },
      child: ListTile(
        shape: const UnderlineInputBorder(
            borderSide: BorderSide(color: Colors.grey, width: 1)),
        onLongPress: () => print('edit'),
        title: Text(item.name),
        subtitle: favorite
            ? Text(
                'Added on ' + DateFormat('dd/MM/yyyy').format(item.favAddDate!))
            : null,
        leading: CircleAvatar(
            backgroundColor: Colors.grey,
            backgroundImage: item.imgUrl == ''
                ? null
                : CachedNetworkImageProvider(item.imgUrl)),
        trailing: Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            IconButton(
              onPressed: () => onToggleFav(item),
              icon: Icon(item.isFavorite() ? Icons.star : Icons.star_border),
            ),
            Visibility(
              visible: reorderEnabled,
              child: ReorderableDragStartListener(
                index: index,
                child: const Icon(
                  Icons.drag_handle,
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
