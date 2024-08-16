import 'package:flutter/material.dart';

class MyCustomButton extends StatelessWidget {
  final String title;
  final VoidCallback onPressed;
  final bool isLoading;
  const MyCustomButton({
    super.key,
    required this.title,
    required this.onPressed,
    this.isLoading = false,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(15),
        color: Colors.black87,
      ),
      child: TextButton(
        onPressed: () => onPressed,
        child: isLoading
            ? const CircularProgressIndicator(
                color: Colors.white,
                strokeWidth: 2.0,
                strokeAlign: BorderSide.strokeAlignCenter,
              )
            : Text(
                title,
                style: const TextStyle(
                  color: Colors.white,
                  fontSize: 18,
                ),
              ),
      ),
    );
  }
}
