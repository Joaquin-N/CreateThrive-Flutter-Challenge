import 'package:flutter/material.dart';

class DeleteDialog extends StatelessWidget {
  const DeleteDialog({Key? key, required this.itemName}) : super(key: key);
  final String itemName;

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      title: const Text('Delete item'),
      content: Text('Are you sure of deleting $itemName?'),
      actions: [
        TextButton(
          onPressed: () => Navigator.of(context).pop(false),
          child: const Text('Cancel'),
        ),
        TextButton(
          onPressed: () => Navigator.of(context).pop(true),
          child: const Text('Delete'),
          style: TextButton.styleFrom(primary: Colors.red),
        )
      ],
    );
  }
}
