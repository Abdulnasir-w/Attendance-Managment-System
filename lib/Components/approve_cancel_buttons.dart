import 'package:flutter/material.dart';

class ApproveButtons extends StatelessWidget {
  final String title;
  final Color textColor;
  final IconData icon;
  const ApproveButtons({
    super.key,
    required this.title,
    required this.textColor,
    required this.icon,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      height: 40,
      width: 120,
      decoration: BoxDecoration(
          color: Colors.red, borderRadius: BorderRadius.circular(15)),
      child: TextButton.icon(
        onPressed: () {},
        label: Text(
          title,
          style: TextStyle(color: textColor),
        ),
        icon: Icon(
          icon,
          size: 25,
          weight: 50,
          color: textColor,
        ),
      ),
    );
  }
}
