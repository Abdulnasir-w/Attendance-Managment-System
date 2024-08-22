import 'dart:io';

import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';

class ImagePickerComponent {
  final ImagePicker image = ImagePicker();
  Future<File?> pickImageFromGallery(BuildContext context) async {
    final XFile? file = await image.pickImage(source: ImageSource.gallery);
    if (file != null) {
      return File(file.path);
    }
    return null;
  }
}
