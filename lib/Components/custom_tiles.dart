import 'package:flutter/material.dart';

class Tiles extends StatelessWidget {
  final String title;
  final VoidCallback onPressed;
  const Tiles({
    super.key,
    required this.title,
    required this.onPressed,
  });

  @override
  Widget build(BuildContext context) {
    return ListTile(
      title: Text(
        title,
        style: const TextStyle(color: Colors.white, fontSize: 17),
      ),
      tileColor: Colors.lightBlue,
      style: ListTileStyle.list,
      visualDensity: const VisualDensity(horizontal: 1.0, vertical: 1.0),
      trailing: const Icon(
        Icons.arrow_forward_rounded,
        color: Colors.white,
        size: 30,
      ),
      shape: RoundedRectangleBorder(
        side: const BorderSide(
          color: Colors.lightBlue,
          width: 1.5,
          style: BorderStyle.solid,
          strokeAlign: BorderSide.strokeAlignOutside,
        ),
        borderRadius: BorderRadius.circular(15),
      ),
      onTap: onPressed,
    );
  }
}
