import 'package:flutter/material.dart';

class ApproveButtons extends StatelessWidget {
  final String title;
  final Color textColor;
  final Color btnColor;
  final IconData icon;
  final VoidCallback onPressed;
  final bool isLoading;
  const ApproveButtons({
    super.key,
    required this.title,
    required this.textColor,
    required this.icon,
    required this.onPressed,
    required this.btnColor,
    this.isLoading = false,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      height: 40,
      width: 120,
      decoration: BoxDecoration(
          color: btnColor, borderRadius: BorderRadius.circular(15)),
      child: TextButton.icon(
        onPressed: isLoading ? null : onPressed,
        label: Text(
          title,
          style: TextStyle(color: textColor),
        ),
        icon: isLoading
            ? SizedBox(
                height: 20,
                width: 20,
                child: CircularProgressIndicator(
                  color: textColor,
                  strokeWidth: 2, // Adjust the thickness if needed
                ),
              )
            : Icon(
                icon,
                size: 25,
                weight: 50,
                color: textColor,
              ),
      ),
    );
  }
}
