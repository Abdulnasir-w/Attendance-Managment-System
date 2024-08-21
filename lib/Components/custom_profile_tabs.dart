import 'package:flutter/material.dart';

class CustomProfileTabs extends StatelessWidget {
  final String title;
  final String details;
  const CustomProfileTabs({
    super.key,
    required this.title,
    required this.details,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      width: 450,
      height: 45,
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(15),
        color: Colors.white,
        border: Border.all(
            color: Colors.black, style: BorderStyle.solid, width: 2.0),
        boxShadow: const [
          BoxShadow(
            color: Colors.grey,
            offset: Offset.zero,
            blurRadius: 1.0,
            spreadRadius: 1.9,
            blurStyle: BlurStyle.outer,
          ),
        ],
      ),
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 20),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Text(
              title,
              style: const TextStyle(
                  fontSize: 17,
                  color: Colors.black,
                  fontWeight: FontWeight.w500),
            ),
            Text(
              details,
              style: const TextStyle(
                  fontSize: 17,
                  fontStyle: FontStyle.italic,
                  color: Colors.black),
            )
          ],
        ),
      ),
    );
  }
}
