import 'package:flutter/material.dart';

class MyCustomTextFormField extends StatefulWidget {
  final String hintText;
  final String labelText;
  final IconData? prefixIcon;
  final TextEditingController textEditingController;
  final TextInputType keyBoardType;
  final int? maxLines;
  final bool isPassfield;
  final String? Function(String?)? validator;

  const MyCustomTextFormField({
    super.key,
    required this.hintText,
    required this.labelText,
    this.prefixIcon,
    required this.textEditingController,
    required this.keyBoardType,
    this.isPassfield = false,
    this.validator,
    this.maxLines,
  });

  @override
  State<MyCustomTextFormField> createState() => _MyCustomTextFormFieldState();
}

class _MyCustomTextFormFieldState extends State<MyCustomTextFormField> {
  bool isVisible = true;
  @override
  Widget build(BuildContext context) {
    return TextFormField(
      obscureText: widget.isPassfield ? isVisible : false,
      controller: widget.textEditingController,
      maxLines: widget.maxLines,
      keyboardType: widget.keyBoardType,
      decoration: InputDecoration(
        prefixIcon: Icon(widget.prefixIcon),
        labelText: widget.labelText,
        hintText: widget.hintText,
        hintMaxLines: widget.maxLines,
        suffixIcon: widget.isPassfield
            ? IconButton(
                onPressed: () {
                  setState(() {
                    isVisible = !isVisible;
                  });
                },
                icon: Icon(
                  isVisible
                      ? Icons.visibility_off_outlined
                      : Icons.visibility_rounded,
                ),
              )
            : null,
        enabledBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(14),
          borderSide: const BorderSide(
            color: Colors.black,
          ),
        ),
        focusedBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(16),
          borderSide: const BorderSide(
            color: Colors.black,
            width: 2,
          ),
        ),
        errorBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(14),
          borderSide: const BorderSide(
            color: Colors.red,
          ),
        ),
        focusedErrorBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(16),
          borderSide: const BorderSide(
            color: Colors.red,
            width: 2,
          ),
        ),
      ),
      validator: widget.validator,
    );
  }
}
