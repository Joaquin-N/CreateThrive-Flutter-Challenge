import 'package:flutter/material.dart';

class DrawerButton extends StatelessWidget {
  const DrawerButton(
      {Key? key,
      required this.onPressed,
      required this.text,
      required this.icon})
      : super(key: key);

  final String text;
  final IconData icon;
  final Function() onPressed;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 5),
      child: ListTile(
        title: Row(
          children: <Widget>[
            Icon(icon),
            Padding(
              padding: EdgeInsets.only(left: 10.0),
              child: Text(
                text,
                style: TextStyle(fontSize: 16),
              ),
            )
          ],
        ),
        onTap: onPressed,
      ),
    );
  }
}
