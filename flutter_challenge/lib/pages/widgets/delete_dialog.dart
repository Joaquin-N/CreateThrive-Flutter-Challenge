import 'package:flutter/material.dart';

class DeleteDialog extends StatelessWidget {
  const DeleteDialog({Key? key, required this.itemName}) : super(key: key);
  final String itemName;

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      title: Text('Delete item'),
      content: Text('Are you sure of deleting the item ${itemName}?'),
      actions: [
        TextButton(
          onPressed: () => Navigator.of(context).pop(false),
          child: Text('Cancel'),
        ),
        TextButton(
          onPressed: () => Navigator.of(context).pop(true),
          child: Text('Delete'),
          style: TextButton.styleFrom(primary: Colors.red),
        )
      ],
    );
  }
}
